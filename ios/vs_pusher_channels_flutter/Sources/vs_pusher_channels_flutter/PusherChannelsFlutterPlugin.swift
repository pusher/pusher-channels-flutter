import Flutter
import Foundation
import PusherSwift
import UIKit

public class PusherChannelsFlutterPlugin: NSObject, FlutterPlugin, PusherDelegate, Authorizer {
  private var pusher: Pusher?
  public var methodChannel: FlutterMethodChannel!

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = PusherChannelsFlutterPlugin()
    instance.methodChannel = FlutterMethodChannel(name: "pusher_channels_flutter", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: instance.methodChannel)
  }

  /// Returns the active Pusher client, or replies to `result` with a
  /// `FlutterError` and returns `nil` if `init` hasn't been called yet.
  /// Avoids crashing the host app on a force-unwrap of an uninitialized client.
  private func requirePusher(_ result: FlutterResult) -> Pusher? {
    guard let pusher = pusher else {
      result(FlutterError(
        code: "uninitialized",
        message: "PusherChannelsFlutter: init() must be called before this method.",
        details: nil
      ))
      return nil
    }
    return pusher
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "init":
      initChannels(call: call, result: result)
    case "connect":
      connect(result: result)
    case "disconnect":
      disconnect(result: result)
    case "getSocketId":
      getSocketId(result: result)
    case "subscribe":
      subscribe(call: call, result: result)
    case "unsubscribe":
      unsubscribe(call: call, result: result)
    case "trigger":
      trigger(call: call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func initChannels(call: FlutterMethodCall, result: @escaping FlutterResult) {
    pusher?.disconnect()
    let args = call.arguments as! [String: Any]
    var authMethod: AuthMethod = .noMethod
    if args["authEndpoint"] is String {
      let authEndpoint = args["authEndpoint"] as! String
      // authParams["headers"] is forwarded to the auth endpoint, which the
      // plain .endpoint method cannot express.
      if let authParams = args["authParams"] as? [String: [String: String]],
         let headers = authParams["headers"], !headers.isEmpty {
        authMethod = .authRequestBuilder(
          authRequestBuilder: PusherAuthRequestBuilder(
            authEndpoint: authEndpoint, headers: headers))
      } else {
        authMethod = .endpoint(authEndpoint: authEndpoint)
      }
    } else if args["authorizer"] is Bool {
      authMethod = .authorizer(authorizer: self)
    }
    var host: PusherHost = .defaultHost
    if args["host"] is String {
      host = .host(args["host"] as! String)
    } else if args["cluster"] != nil {
      host = .cluster(args["cluster"] as! String)
    }
    var useTLS: Bool = true
    if args["useTLS"] is Bool {
      useTLS = args["useTLS"] as! Bool
    }
    var port: Int
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
    var activityTimeout: TimeInterval?
    if args["activityTimeout"] is TimeInterval {
      activityTimeout = args["activityTimeout"] as! Double / 1000.0
    }
    var path: String?
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
    let newPusher = Pusher(key: args["apiKey"] as! String, options: options)
    if args["maxReconnectionAttempts"] is Int {
      newPusher.connection.reconnectAttemptsMax = (args["maxReconnectionAttempts"] as! Int)
    }
    if args["maxReconnectGapInSeconds"] is TimeInterval {
      newPusher.connection.maxReconnectGapInSeconds = (args["maxReconnectGapInSeconds"] as! TimeInterval)
    }
    if args["pongTimeout"] is Int {
      newPusher.connection.pongResponseTimeoutInterval = args["pongTimeout"] as! TimeInterval / 1000.0
    }
    newPusher.connection.delegate = self
    newPusher.bind(eventCallback: onEvent)
    pusher = newPusher
    result(nil)
  }

  public func fetchAuthValue(socketID: String, channelName: String, completionHandler: @escaping (PusherAuth?) -> Void) {
    methodChannel!.invokeMethod("onAuthorizer", arguments: [
      "socketId": socketID,
      "channelName": channelName,
    ]) { authData in
      if authData != nil {
        let authDataCast = authData as! [String: String]
        completionHandler(
          PusherAuth(
            auth: authDataCast["auth"]!,
            channelData: authDataCast["channel_data"],
            sharedSecret: authDataCast["shared_secret"]
          ))
      } else {
        completionHandler(nil)
      }
    }
  }

  public func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
    methodChannel.invokeMethod("onConnectionStateChange", arguments: [
      "previousState": old.stringValue(),
      "currentState": new.stringValue(),
    ])
  }

  public func debugLog(message _: String) {
    // print("DEBUG:", message)
  }

  public func subscribedToChannel(name _: String) {
    // Handled by global handler
  }

  public func failedToSubscribeToChannel(name _: String, response _: URLResponse?, data _: String?, error: NSError?) {
    methodChannel.invokeMethod(
      "onSubscriptionError", arguments: [
        "message": (error != nil) ? error!.localizedDescription : "",
        "error": error.debugDescription,
      ]
    )
  }

  public func receivedError(error: PusherError) {
    methodChannel.invokeMethod(
      "onError", arguments: [
        "message": error.message,
        "code": error.code ?? -1,
        "error": error.debugDescription,
      ]
    )
  }

  public func failedToDecryptEvent(eventName: String, channelName _: String, data: String?) {
    methodChannel.invokeMethod(
      "onDecryptionFailure", arguments: [
        "eventName": eventName,
        "reason": data,
      ]
    )
  }

  func connect(result: @escaping FlutterResult) {
    guard let pusher = requirePusher(result) else { return }
    pusher.connect()
    result(nil)
  }

  func disconnect(result: @escaping FlutterResult) {
    guard let pusher = requirePusher(result) else { return }
    pusher.disconnect()
    result(nil)
  }

  func getSocketId(result: @escaping FlutterResult) {
    guard let pusher = requirePusher(result) else { return }
    result(pusher.connection.socketId)
  }

  func onEvent(event: PusherEvent) {
    var userId: String?
    if event.eventName == "pusher:subscription_succeeded" {
      if let channel = pusher?.connection.channels.findPresence(name: event.channelName!) {
        userId = channel.myId
      }
    }
    methodChannel.invokeMethod(
      "onEvent", arguments: [
        "channelName": event.channelName,
        "eventName": event.eventName,
        "userId": event.userId ?? userId,
        "data": event.data,
      ]
    )
  }

  func subscribe(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let pusher = requirePusher(result) else { return }
    let args = call.arguments as! [String: String]
    let channelName: String = args["channelName"]!
    if channelName.hasPrefix("presence-") {
      let onMemberAdded: (PusherPresenceChannelMember) -> Void = { user in
        self.methodChannel.invokeMethod("onMemberAdded", arguments: [
          "channelName": channelName,
          "user": ["userId": user.userId, "userInfo": user.userInfo],
        ])
      }
      let onMemberRemoved: (PusherPresenceChannelMember) -> Void = { user in
        self.methodChannel.invokeMethod("onMemberRemoved", arguments: [
          "channelName": channelName,
          "user": ["userId": user.userId, "userInfo": user.userInfo],
        ])
      }
      pusher.subscribeToPresenceChannel(
        channelName: channelName,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved
      )
    } else {
      let onSubscriptionCount: (Int) -> Void = { subscriptionCount in
        self.methodChannel.invokeMethod(
          "onEvent", arguments: [
            "channelName": channelName,
            "eventName": "pusher:subscription_count",
            "userId": nil,
            "data": [
              "subscription_count": subscriptionCount,
            ],
          ]
        )
      }
      pusher.subscribe(channelName: channelName,
                       onSubscriptionCountChanged: onSubscriptionCount)
    }
    result(nil)
  }

  func unsubscribe(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let pusher = requirePusher(result) else { return }
    let args = call.arguments as! [String: String]
    let channelName: String = args["channelName"]!
    pusher.unsubscribe(channelName)
    result(nil)
  }

  func trigger(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let pusher = requirePusher(result) else { return }
    let args = call.arguments as! [String: String]
    let channelName: String = args["channelName"]!
    let eventName: String = args["eventName"]!
    let data: String? = args["data"]
    guard let channel = pusher.connection.channels.find(name: channelName) else {
      result(FlutterError(
        code: "not_subscribed",
        message: "PusherChannelsFlutter: not subscribed to channel \(channelName).",
        details: nil
      ))
      return
    }
    channel.trigger(eventName: eventName, data: data as Any)
    result(nil)
  }
}

/// Posts the channel authorization request with caller-supplied headers.
///
/// PusherSwift's `.endpoint` auth method sends no custom headers, so a
/// self-hosted endpoint expecting a token or session header needs this.
class PusherAuthRequestBuilder: NSObject, AuthRequestBuilderProtocol {
  let authEndpoint: String
  let headers: [String: String]

  init(authEndpoint: String, headers: [String: String]) {
    self.authEndpoint = authEndpoint
    self.headers = headers
  }

  func requestFor(socketID: String, channelName: String) -> URLRequest? {
    guard let url = URL(string: authEndpoint) else {
      return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    // Matches the form encoding the default endpoint authorizer uses.
    var body = URLComponents()
    body.queryItems = [
      URLQueryItem(name: "socket_id", value: socketID),
      URLQueryItem(name: "channel_name", value: channelName),
    ]
    request.httpBody = body.percentEncodedQuery?.data(using: .utf8)
    request.setValue(
      "application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    for (key, value) in headers {
      request.setValue(value, forHTTPHeaderField: key)
    }
    return request
  }
}
