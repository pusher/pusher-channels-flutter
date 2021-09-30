package com.pusher.channels_flutter

import com.pusher.client.Pusher
import com.pusher.client.PusherOptions
import com.pusher.client.channel.Channel
import com.pusher.client.channel.PusherEvent
import com.pusher.client.channel.SubscriptionEventListener
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

class PusherChannelsFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var activity: FlutterActivity? = null
    private lateinit var methodChannel: MethodChannel
    private var pusher: Pusher? = null
    private var pusherChannels = mutableMapOf<String, Channel>()
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "pusher_channels_flutter")
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
            "subscribe" -> this.subscribe(
                call.argument("channelName")!!,
                call.argument("eventName")!!,
                result
            )
            else -> {
                result.notImplemented()
            }
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
        pusher!!.connect(object : ConnectionEventListener {
            override fun onConnectionStateChange(change: ConnectionStateChange) {
                Log.d(
                    TAG,
                    "State changed to " + change.currentState +
                            " from " + change.previousState
                )
                activity!!.runOnUiThread {
                    methodChannel.invokeMethod(
                        "onConnectionStateChange", mapOf(
                            "previousState" to change.previousState.toString(),
                            "currentState" to change.currentState.toString()
                        )
                    )
                }
            }

            override fun onError(message: String, code: String, e: Exception) {
                Log.d(
                    TAG,
                    "There was a problem connecting $pusher! message: $message, code: $code exception: $e"
                )
                activity!!.runOnUiThread {
                    methodChannel.invokeMethod(
                        "onError", mapOf(
                            "message" to message,
                            "code" to code,
                            "e" to e.toString()
                        )
                    )
                }
            }
        }, ConnectionState.ALL)
        result.success(null)
    }

    private fun subscribe(channelName: String, eventName: String, result: Result) {
        pusherChannels[channelName] = pusher!!.subscribe(channelName)
        pusherChannels[channelName]!!.bind(eventName, object : SubscriptionEventListener {
            override fun onEvent(event: PusherEvent) {
                Log.i(TAG, "Received event with data: $event")
                activity!!.runOnUiThread {
                    methodChannel.invokeMethod(
                        "onEvent", mapOf(
                            "channelName" to event.channelName,
                            "eventName" to event.eventName,
                            "userId" to event.userId,
                            "data" to event.data
                        )
                    )
                }
            }
        })
        result.success(null)
    }
}
