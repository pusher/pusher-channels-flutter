package com.pusher.channels_flutter

import com.google.gson.Gson
import com.pusher.client.ChannelAuthorizer
import com.pusher.client.Pusher
import com.pusher.client.PusherOptions
import com.pusher.client.channel.*
import com.pusher.client.connection.ConnectionEventListener
import com.pusher.client.connection.ConnectionState
import com.pusher.client.connection.ConnectionStateChange
import com.pusher.client.util.HttpChannelAuthorizer
import io.flutter.Log
import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.net.InetSocketAddress
import java.net.Proxy
import java.util.concurrent.Semaphore

class PusherChannelsFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    ConnectionEventListener, ChannelEventListener, SubscriptionEventListener,
    PrivateChannelEventListener, PrivateEncryptedChannelEventListener, PresenceChannelEventListener,
    ChannelAuthorizer {
    private var activity: Activity? = null
    private lateinit var methodChannel: MethodChannel
    private var pusher: Pusher? = null
    private val TAG = "PusherChannelsFlutter"

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel =
            MethodChannel(
                flutterPluginBinding.binaryMessenger,
                "pusher_channels_flutter"
            )
        methodChannel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> this.init(call, result)
            "connect" -> this.connect(result)
            "disconnect" -> this.disconnect(result)
            "subscribe" -> this.subscribe(
                call.argument("channelName")!!,
                result
            )
            "unsubscribe" -> this.unsubscribe(
                call.argument("channelName")!!,
                result
            )
            "trigger" -> this.trigger(
                call.argument("channelName")!!,
                call.argument("eventName")!!,
                call.argument("data")!!,
                result
            )
            "getSocketId" -> this.getSocketId(result)
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun callback(method: String, args: Any) {
        activity?.runOnUiThread {
            methodChannel.invokeMethod(method, args)
        }
    }

    private fun init(
        call: MethodCall,
        result: Result
    ) {
        try {
            if (pusher != null) {
                pusher!!.disconnect()
            }
            val options = PusherOptions()
            if (call.argument<String>("cluster") != null) options.setCluster(call.argument("cluster"))
            if (call.argument<Boolean>("useTLS") != null) options.isUseTLS =
                call.argument("useTLS")!!
            if (call.argument<Long>("activityTimeout") != null) options.activityTimeout =
                call.argument("activityTimeout")!!
            if (call.argument<Long>("pongTimeout") != null) options.pongTimeout =
                call.argument("pongTimeout")!!
            if (call.argument<Int>("maxReconnectionAttempts") != null) options.maxReconnectionAttempts =
                call.argument("maxReconnectionAttempts")!!
            if (call.argument<Int>("maxReconnectGapInSeconds") != null) options.maxReconnectGapInSeconds =
                call.argument("maxReconnectGapInSeconds")!!
            if (call.argument<String>("authEndpoint") != null) options.channelAuthorizer =
                HttpChannelAuthorizer(call.argument("authEndpoint"))
            if (call.argument<String>("authorizer") != null) options.channelAuthorizer = this
            if (call.argument<String>("proxy") != null) {
                val (host, port) = call.argument<String>("proxy")!!.split(':')
                options.proxy = Proxy(Proxy.Type.HTTP, InetSocketAddress(host, port.toInt()))
            }
            pusher = Pusher(call.argument("apiKey"), options)
            Log.i(TAG, "Start $pusher")
            result.success(null)
        } catch (e: Exception) {
            result.error(TAG, e.message, null)
        }
    }

    private fun connect(result: Result) {
        pusher!!.connect(this, ConnectionState.ALL)
        result.success(null)
    }

    private fun disconnect(result: Result) {
        pusher!!.disconnect()
        result.success(null)
    }

    private fun subscribe(channelName: String, result: Result) {
        val channel = when {
            channelName.startsWith("private-encrypted-") -> pusher!!.subscribePrivateEncrypted(
                channelName, this
            )
            channelName.startsWith("private-") -> pusher!!.subscribePrivate(channelName, this)
            channelName.startsWith("presence-") -> pusher!!.subscribePresence(
                channelName, this
            )
            else -> pusher!!.subscribe(channelName, this)
        }
        channel.bindGlobal(this)
        result.success(null)
    }

    private fun unsubscribe(channelName: String, result: Result) {
        pusher!!.unsubscribe(channelName)
        result.success(null)
    }

    private fun trigger(channelName: String, eventName: String, data: String, result: Result) {
        when {
            channelName.startsWith("private-encrypted-") -> throw Exception("It's not currently possible to send a message using private encrypted channels.")
            channelName.startsWith("private-") -> pusher!!.getPrivateChannel(channelName)
                .trigger(eventName, data)
            channelName.startsWith("presence-") -> pusher!!.getPresenceChannel(channelName)
                .trigger(eventName, data)
            else -> throw Exception("Messages can only be sent to private and presence channels.")
        }
        result.success(null)
    }

    private fun getSocketId(result: Result) {
        val socketId = pusher!!.connection.socketId
        result.success(socketId)
    }

    override fun authorize(channelName: String?, socketId: String?): String? {
        var result: String? = null
        val mutex = Semaphore(0)
        try {
            activity!!.runOnUiThread {
                methodChannel.invokeMethod("onAuthorizer", mapOf(
                    "channelName" to channelName,
                    "socketId" to socketId
                ), object : Result {
                    override fun success(o: Any?) {
                        if (o != null) {
                            val gson = Gson()
                            result = gson.toJson(o)
                        } else {
                            result = "{ }"
                        }
                        mutex.release()
                    }
                    override fun error(s: String, s1: String?, o: Any?) {
                        Log.i(TAG, "Pusher authorize error: " + s)
                        result = "{ }"
                        mutex.release()
                    }
                    override fun notImplemented() {
                        result = "{ }"
                        mutex.release()
                    }
                })
            }
        } catch (exception: Exception) {
            Log.i(TAG, "Pusher authorize error: " + exception.toString())
            result = "{ }"
            mutex.release()
        }
        mutex.acquire()
        return result
    }

    // Event handlers
    override fun onConnectionStateChange(change: ConnectionStateChange) {
        callback(
            "onConnectionStateChange", mapOf(
                "previousState" to change.previousState.toString(),
                "currentState" to change.currentState.toString()
            )
        )
    }

    override fun onSubscriptionSucceeded(channelName: String) {
        if (!channelName.startsWith("presence-")) {
            callback(
                "onEvent", mapOf(
                    "channelName" to channelName,
                    "eventName" to "pusher:subscription_succeeded",
                    "data" to emptyMap<String,String>()
                )
            )
        }
    }

    override fun onEvent(event: PusherEvent) {
        callback(
            "onEvent", mapOf(
                "channelName" to event.channelName,
                "eventName" to event.eventName,
                "userId" to event.userId,
                "data" to event.data
            )
        )
    }

    override fun onAuthenticationFailure(message: String, e: Exception) {
        callback(
            "onSubscriptionError", mapOf(
                "message" to message,
                "error" to e.toString()
            )
        )
    } 
    
    // Other ChannelEventListener methods
    override fun onUsersInformationReceived(channelName: String?, users: MutableSet<User>?) {
        val gson = Gson()
        val channel = pusher!!.getPresenceChannel(channelName)
        val hash = mutableMapOf<String, Any?>()
        // convert users back to original structure.
        for (user in users!!) {
            hash[user.id] = gson.fromJson(user.info, Map::class.java)
        }
        val data = mapOf(
            "presence" to mapOf(
                "count" to users.size,
                "ids" to users.map { it.id },
                "hash" to hash
            )
        )
        callback(
            "onEvent", mapOf(
                "channelName" to channelName,
                "eventName" to "pusher:subscription_succeeded",
                "userId" to channel.me.id,
                "data" to data
            )
        )
    }

    override fun onDecryptionFailure(event: String?, reason: String?) {
        callback(
            "onDecryptionFailure", mapOf(
                "event" to event,
                "reason" to reason
            )
        )
    }

    override fun userSubscribed(channelName: String, user: User) {
        callback(
            "onMemberAdded", mapOf(
                "channelName" to channelName,
                "user" to mapOf(
                    "userId" to user.id,
                    "userInfo" to user.info
                )
            )
        )
    }

    override fun userUnsubscribed(channelName: String, user: User) {
        callback(
            "onMemberRemoved", mapOf(
                "channelName" to channelName,
                "user" to mapOf(
                    "userId" to user.id,
                    "userInfo" to user.info
                )
            )
        )
    } // Other ChannelEventListener methods

    override fun onError(message: String, code: String?, e: Exception?) {
        callback(
            "onError", mapOf(
                "message" to message,
                "code" to code,
                "error" to e.toString()
            )
        )
    }

    override fun onError(message: String, e: Exception) {
        onError(message, "", e)
    }
}

