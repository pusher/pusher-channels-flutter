import Flutter
import UIKit
import PusherSwift
import Foundation

public class SwiftPusherChannelsFlutterPlugin: NSObject, FlutterPlugin, PusherDelegate, Authorizer {
    private var pusher: Pusher!
    public var methodChannel: FlutterMethodChannel!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftPusherChannelsFlutterPlugin()
        instance.methodChannel = FlutterMethodChannel(name: "pusher_channels_flutter", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.methodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        switch call.method {
        case "init":
            self.initChannels(call: call, result: result)
        case "connect":
            self.connect(result: result)
        case "disconnect":
            self.disconnect(result: result)
        case "getSocketId":
            self.getSocketId(result: result)
        case "subscribe":
            self.subscribe(call: call, result: result)
        case "unsubscribe":
            self.unsubscribe(call: call, result: result)
        case "trigger":
            self.trigger(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func initChannels(call:FlutterMethodCall, result:@escaping FlutterResult) {
        if (pusher == nil) {
            let args = call.arguments as! [String: Any]
            var authMethod:AuthMethod = .noMethod
            if args["authEndpoint"] is String {
                authMethod = .endpoint(authEndpoint: args["authEndpoint"] as! String)
            } else if args["authorizer"] is Bool {
                authMethod = .authorizer(authorizer: self)
            }
            var host:PusherHost = .defaultHost
            if args["host"] is String {
                host = .host(args["host"] as! String)
            } else if args["cluster"] != nil {
                host = .cluster(args["cluster"] as! String)
            }
            var useTLS:Bool = true
            if args["useTLS"] is Bool {
                useTLS = args["useTLS"] as! Bool
            }
            var port:Int
            if useTLS {
                port = 443
                if args["wssPort"] is Int {
                    port = args["wssPort"] as! Int
                }
            } else {
                port = 80
                if args["wsPort"] is Int {
                    port = args["wsPort"] as! Int
                }
            }
            var activityTimeout:TimeInterval? = nil
            if args["activityTimeout"] is TimeInterval {
                activityTimeout = args["activityTimeout"] as! Double / 1000.0
            }
            var path:String? = nil
            if args["path"] is String {
                path = (args["path"] as! String)
            }
            let options = PusherClientOptions(
                authMethod: authMethod,
                host: host,
                port: port,
                path: path,
                useTLS: useTLS,
                activityTimeout: activityTimeout
            )
            pusher = Pusher(key: args["apiKey"] as! String, options: options)
            if args["maxReconnectionAttempts"] is Int {
                pusher.connection.reconnectAttemptsMax = (args["maxReconnectionAttempts"] as! Int)
            }
            if args["maxReconnectGapInSeconds"] is TimeInterval {
                pusher.connection.maxReconnectGapInSeconds = (args["maxReconnectGapInSeconds"] as! TimeInterval)
            }
            if args["pongTimeout"] is Int {
                pusher.connection.pongResponseTimeoutInterval = args["pongTimeout"] as! TimeInterval / 1000.0
            }
            pusher.connection.delegate = self
            pusher.bind(eventCallback: onEvent)
            result(nil)
        }
    }
    
    public func fetchAuthValue(socketID: String, channelName: String, completionHandler: @escaping (PusherAuth?) -> Void) {
        methodChannel!.invokeMethod("onAuthorizer", arguments: [
            "socketId": socketID,
            "channelName": channelName
        ]) { authData in
            if authData != nil {
                let authDataCast = authData as! [String:String]
                completionHandler(
                    PusherAuth(
                        auth: authDataCast["auth"]!,
                        channelData: authDataCast["channel_data"],
                        sharedSecret: authDataCast["shared_secret"]));
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        methodChannel.invokeMethod("onConnectionStateChange", arguments: [
            "previousState": old.stringValue(),
            "currentState": new.stringValue()
        ])
    }
    
    public func debugLog(message: String) {
        //print("DEBUG:", message)
    }
    
    public func subscribedToChannel(name: String) {
        // Handled by global handler
    }
    
    public func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
        methodChannel.invokeMethod(
            "onSubscriptionError", arguments: [
                "message": (error != nil) ? error!.localizedDescription : "",
                "error": error.debugDescription
            ]
        )
    }
    
    public func receivedError(error: PusherError) {
        methodChannel.invokeMethod(
            "onError", arguments:[
                "message": error.message,
                "code": error.code ?? -1,
                "error": error.debugDescription
            ]
        )
    }
    
    public func failedToDecryptEvent(eventName: String, channelName: String, data: String?) {
        methodChannel.invokeMethod(
            "onDecryptionFailure", arguments: [
                "eventName": eventName,
                "reason": data
            ]
        )
    }
    
    func connect(result:@escaping FlutterResult) {
        pusher.connect()
        result(nil)
    }
    
    func disconnect(result:@escaping FlutterResult) {
        pusher.disconnect()
        result(nil)
    }
    
    func getSocketId(result:@escaping FlutterResult) {
        result(pusher.connection.socketId)
    }
    
    func onEvent(event:PusherEvent) {
        var userId:String? = nil
        var mappedEventName:String? = nil
        if event.eventName == "pusher:subscription_succeeded" {
            if let channel = pusher.connection.channels.findPresence(name: event.channelName!) {
                userId = channel.myId
            }
            mappedEventName = "pusher_internal:subscription_succeeded"
        }
        methodChannel.invokeMethod(
            "onEvent", arguments:[
                "channelName": event.channelName,
                "eventName": mappedEventName ?? event.eventName,
                "userId": event.userId ?? userId,
                "data": event.data
            ]
        )
    }
    
    func subscribe(call:FlutterMethodCall, result:@escaping FlutterResult) {
        let args = call.arguments as! [String: String]
        let channelName:String = args["channelName"]!
        if channelName.hasPrefix("presence-") {
            let onMemberAdded:(PusherPresenceChannelMember) -> () = { user in
                self.methodChannel.invokeMethod("onMemberAdded", arguments: [
                    "channelName": channelName,
                    "user": ["userId": user.userId, "userInfo": user.userInfo ]
                ])
            }
            let onMemberRemoved:(PusherPresenceChannelMember) -> () = { user in
                self.methodChannel.invokeMethod("onMemberRemoved", arguments: [
                    "channelName": channelName,
                    "user": ["userId": user.userId, "userInfo": user.userInfo ]
                ])
            }
            pusher.subscribeToPresenceChannel(
                channelName: channelName,
                onMemberAdded: onMemberAdded,
                onMemberRemoved: onMemberRemoved
            )
        } else {
            pusher.subscribe(channelName: channelName)
        }
        result(nil)
    }
    
    func unsubscribe(call:FlutterMethodCall, result:@escaping FlutterResult) {
        let args = call.arguments as! [String: String]
        let channelName: String = args["channelName"]!
        pusher.unsubscribe(channelName)
        result(nil)
    }
    
    func trigger(call:FlutterMethodCall, result:@escaping FlutterResult) {
        let args = call.arguments as! [String: String]
        let channelName:String = args["channelName"]!
        let eventName:String = args["eventName"]!
        let data:String? = args["data"]
        if let channel = pusher.connection.channels.find(name: channelName) {
            channel.trigger(eventName: eventName, data: data as Any)
        }
    }
}
