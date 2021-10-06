package com.pusher.channels_flutter

import com.pusher.client.Pusher
import com.pusher.client.PusherOptions
import com.pusher.client.channel.*
import com.pusher.client.connection.ConnectionEventListener
import com.pusher.client.connection.ConnectionState
import com.pusher.client.connection.ConnectionStateChange
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


const val TAG = "PusherChannelsFlutter"



class PusherChannelsFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    ConnectionEventListener, ChannelEventListener, SubscriptionEventListener,
    PrivateChannelEventListener, PrivateEncryptedChannelEventListener, PresenceChannelEventListener {
    private var activity: FlutterActivity? = null
    private lateinit var methodChannel: MethodChannel
    private var pusher: Pusher? = null
    private var pusherChannels = mutableMapOf<String, Channel>()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "pusher_channels_flutter")
        methodChannel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterActivity
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterActivity
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
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "init" -> this.init(call, result)
            "connect" -> this.connect(result)
            "disconnect" -> this.disconnect(result)
            "subscribe" -> this.subscribe(
                call.argument("channelName")!!,
                call.argument("eventName")!!,
                result
            )
            "subscribePrivate" -> this.subscribePrivate(
                call.argument("channelName")!!,
                call.argument("eventName")!!,
                result
            )
            "subscribePrivateEncrypted" -> this.subscribePrivateEncrypted(
                call.argument("channelName")!!,
                call.argument("eventName")!!,
                result
            )
            "subscribePresence" -> this.subscribePresence(
                call.argument("channelName")!!,
                call.argument("eventName")!!,
                result
            )
            "trigger" -> this.trigger(
                call.argument("channelName")!!,
                call.argument("eventName")!!,
                call.argument("data")!!,
                result
            )
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun callback(method: String, args: Map<String, Any?>) {
        activity!!.runOnUiThread {
            methodChannel.invokeMethod(method, args)
        }
    }

    private fun init(
        call: MethodCall,
        result: Result
    ) {
        try {
            if (pusher == null) {
                val options = PusherOptions()
                if (call.argument<String>("cluster") != null) options.setCluster(call.argument("cluster"))
                if (call.argument<Boolean>("useTLS") != null) options.isUseTLS =
                    call.argument("useTLS")!!
                if (call.argument<String>("host") != null) options.setHost(call.argument("host"))
                if (call.argument<Int>("wsPort") != null) options.setWsPort(call.argument("wsPort")!!)
                if (call.argument<Int>("wssPort") != null) options.setWssPort(call.argument("wssPort")!!)
                if (call.argument<Long>("activityTimeout") != null) options.activityTimeout =
                    call.argument("wssPort")!!
                if (call.argument<Long>("pongTimeout") != null) options.pongTimeout =
                    call.argument("pongTimeout")!!
                if (call.argument<Int>("maxReconnectionAttempts") != null) options.maxReconnectionAttempts =
                    call.argument("maxReconnectionAttempts")!!
                if (call.argument<Int>("maxReconnectGapInSeconds") != null) options.maxReconnectGapInSeconds =
                    call.argument("maxReconnectGapInSeconds")!!
                pusher = Pusher(call.argument("apiKey"), options)
            } else {
                throw Exception("Pusher Channels already initialized.")
            }

            Log.i(TAG, "Start $pusher")
            result.success(null)
        } catch (e: Exception) {
            result.error("PusherChannels", e.message, null)
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

    private fun subscribe(channelName: String, eventName: String, result: Result) {
        if (pusherChannels[channelName] == null) {
            pusherChannels[channelName] = pusher!!.subscribe(channelName, this)
        }
        pusherChannels[channelName]!!.bind(eventName, this)
        result.success(null)
    }

    private fun subscribePrivate(channelName: String, eventName: String, result: Result) {
        if (pusherChannels[channelName] == null) {
            pusherChannels[channelName] = pusher!!.subscribePrivate(channelName, this)
        }
        pusherChannels[channelName]!!.bind(eventName, this)
        result.success(null)
    }

    private fun subscribePrivateEncrypted(channelName: String, eventName: String, result: Result) {
        if (pusherChannels[channelName] == null) {
            pusherChannels[channelName] =
                pusher!!.subscribePrivateEncrypted(channelName, this)
        }
        pusherChannels[channelName]!!.bind(eventName, this)
        result.success(null)
    }

    private fun subscribePresence(channelName: String, eventName: String, result: Result) {
        if (pusherChannels[channelName] == null) {
            pusherChannels[channelName] = pusher!!.subscribePresence(channelName, this)
        }
        pusherChannels[channelName]!!.bind(eventName, this)
        result.success(null)
    }

    private fun trigger(channelName: String, eventName: String, data:String, result:Result) {
        (pusherChannels[channelName] as PrivateChannel)!!.trigger(eventName, data)
        result.success(null)
    }

    override fun onConnectionStateChange(change: ConnectionStateChange) {
        Log.i(
            TAG,
            "State changed to " + change.currentState +
                    " from " + change.previousState
        )
        callback(
            "onConnectionStateChange", mapOf(
                "previousState" to change.previousState.toString(),
                "currentState" to change.currentState.toString()
            )
        )
    }

    override fun onSubscriptionSucceeded(channelName: String) {
        Log.i(TAG, "Subscribed to channel: $channelName")
        callback(
            "onSubscriptionSucceeded", mapOf(
                "channelName" to channelName
            )
        )
    }

    override fun onEvent(event: PusherEvent) {
        Log.i(TAG, "Received event with data: $event")
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
        Log.e(TAG, "Authentication failure due to $message, exception was $e")
        callback(
            "onAuthenticationFailure", mapOf(
                "message" to message,
                "e" to e.toString()
            )
        )
    } // Other ChannelEventListener methods

    override fun onDecryptionFailure(event: String?, reason: String?) {
        Log.e(TAG, "Decryption failure due to $event, exception was $reason")
        callback(
            "onDecryptionFailure", mapOf(
                "event" to event,
                "reason" to reason
            )
        )
    }

    override fun onUsersInformationReceived(channelName: String, users: Set<User>) {
        callback(
            "onUsersInformationReceived", mapOf(
                "channelName" to channelName,
                "users" to users
            )
        )
    }

    override fun userSubscribed(channelName: String, user: User) {
        Log.i(TAG, "A new user joined channel [$channelName]: ${user.id}, ${user.info}")
        callback(
            "userSubscribed", mapOf(
                "channelName" to channelName,
                "user" to user
            )
        )
    }

    override fun userUnsubscribed(channelName: String, user: User) {
        Log.i(TAG, "A user left channel [$channelName]: ${user.id}, ${user.info}")
        callback(
            "userUnsubscribed", mapOf(
                "channelName" to channelName,
                "user" to user
            )
        )
    } // Other ChannelEventListener methods

    override fun onError(message: String, code: String, e: Exception) {
        Log.d(
            TAG,
            "There was a problem connecting $pusher! message: $message, code: $code exception: $e"
        )
        callback(
            "onError", mapOf(
                "message" to message,
                "code" to code,
                "e" to e.toString()
            )
        )
    }

    override fun onError(message: String, e: Exception) {
        onError(message, "", e)
    }
}
