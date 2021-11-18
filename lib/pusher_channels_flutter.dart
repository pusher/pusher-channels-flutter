import 'dart:async';

import 'package:flutter/services.dart';

class PusherChannel {
  String channelName;
  Function(dynamic data)? onSubscriptionSucceeded;
  Function(Object event)? onEvent;
  Function(dynamic user)? onMemberAdded;
  Function(dynamic user)? onMemberRemoved;
  PusherChannel(this.channelName);

  Future<void> trigger(
      {required String eventName, required String data}) async {
    return PusherChannelsFlutter.getInstance()
        .trigger(channelName: channelName, eventName: eventName, data: data);
  }

  Future<void> unsubscribe() async {
    return PusherChannelsFlutter.getInstance()
        .unsubscribe(channelName: channelName);
  }
}

class PusherChannelsFlutter {
  static PusherChannelsFlutter? _instance;

  MethodChannel methodChannel =
      const MethodChannel('pusher_channels_flutter');
  Map<String, PusherChannel> channels = {};
  Function(dynamic currentState, dynamic previousState)?
      onConnectionStateChange;
  Function(String channelName, dynamic data)? onSubscriptionSucceeded;
  Function(String message, dynamic error)? onSubscriptionError;
  Function(String event, String reason)? onDecryptionFailure;
  Function(String message, int? code, dynamic error)? onError;
  Function(Object event)? onEvent;
  Function(String channelName, dynamic user)? onMemberAdded;
  Function(String channelName, dynamic user)? onMemberRemoved;
  Function(String channelName, String socketId, dynamic options)? onAuthorizer;

  static PusherChannelsFlutter getInstance() {
    _instance ??= PusherChannelsFlutter();
    return _instance!;
  }

  Future<void> init({
    required String apiKey,
    required String cluster,
    bool? useTLS,
    String? host,
    int? wsPort,
    int? wssPort,
    int? activityTimeout,
    int? pongTimeout,
    int? maxReconnectionAttempts,
    int? maxReconnectGapInSeconds,
    Function(dynamic currentState, dynamic previousState)?
        onConnectionStateChange,
    Function(String channelName, dynamic data)? onSubscriptionSucceeded,
    Function(String message, dynamic error)? onSubscriptionError,
    Function(String event, String reason)? onDecryptionFailure,
    Function(String message, int? code, dynamic error)? onError,
    Function(Object event)? onEvent,
    Function(String channelName, dynamic user)? onMemberAdded,
    Function(String channelName, dynamic user)? onMemberRemoved,
    Function(String channelName, String socketId, dynamic options)?
        onAuthorizer,
    String? proxy, // pusher-websocket-java only
    bool? enableStats, // pusher-js only
    List<String>? disabledTransports, // pusher-js only
    List<String>? enabledTransports, // pusher-js only
    bool? ignoreNullOrigin, // pusher-js only
    String? statsHost, // pusher-js only
    String? authEndpoint, // pusher-js only
    String? authTransport, // pusher-js only
    String? httpHost, // pusher-js only
    String? httpPath, // pusher-js only
    int? httpPort, // pusher-js only
    int? httpsPort, // pusher-js only
    Map<String, Map<String, String>>? auth, // pusher-js only
    bool? logToConsole, // pusher-js only
  }) async {
    methodChannel.setMethodCallHandler(_platformCallHandler);
    this.onConnectionStateChange = onConnectionStateChange;
    this.onError = onError;
    this.onSubscriptionSucceeded = onSubscriptionSucceeded;
    this.onEvent = onEvent;
    this.onSubscriptionError = onSubscriptionError;
    this.onDecryptionFailure = onDecryptionFailure;
    this.onMemberAdded = onMemberAdded;
    this.onMemberRemoved = onMemberRemoved;
    this.onAuthorizer = onAuthorizer;
    await methodChannel.invokeMethod('init', {
      "apiKey": apiKey,
      "cluster": cluster,
      "useTLS": useTLS,
      "host": host,
      "wssPort": wssPort,
      "wsPort": wsPort,
      "activityTimeout": activityTimeout,
      "pongTimeout": pongTimeout,
      "maxReconnectionAttempts": maxReconnectionAttempts,
      "maxReconnectGapInSeconds": maxReconnectGapInSeconds,
      "authorizer": onAuthorizer != null,
      "proxy": proxy,
      "enableStats": enableStats,
      "disabledTransports": disabledTransports,
      "enabledTransports": enabledTransports,
      "ignoreNullOrigin": ignoreNullOrigin,
      "statsHost": statsHost,
      "authEndpoint": authEndpoint,
      "authTransport": authTransport,
      "httpHost": httpHost,
      "httpPath": httpPath,
      "httpPort": httpPort,
      "httpsPort": httpsPort,
      "auth": auth,
      "logToConsole": logToConsole
    });
  }

  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onConnectionStateChange':
        onConnectionStateChange?.call(
            call.arguments['currentState'], call.arguments['previousState']);
        return Future.value(null);
      case 'onError':
        onError?.call(call.arguments['message'], call.arguments['code'],
            call.arguments['error']);
        return Future.value(null);
      case 'onEvent':
        onEvent?.call(call.arguments);
        return Future.value(null);
      case 'onSubscriptionSucceeded':
        onSubscriptionSucceeded?.call(
            call.arguments['channelName'], call.arguments['data']);
        channels[call.arguments['channelName']]
            ?.onSubscriptionSucceeded!(call.arguments['data']);
        return Future.value(null);
      case 'onSubscriptionError':
        onSubscriptionError?.call(
            call.arguments['message'], call.arguments['error']);
        return Future.value(null);
      case 'onDecryptionFailure':
        onDecryptionFailure?.call(
            call.arguments['event'], call.arguments['reason']);
        return Future.value(null);
      case 'onMemberAdded':
        onMemberAdded?.call(
            call.arguments['channelName'], call.arguments['user']);
        channels[call.arguments['channelName']]
            ?.onMemberAdded!(call.arguments['user']);
        return Future.value(null);
      case 'onMemberRemoved':
        onMemberRemoved?.call(
            call.arguments['channelName'], call.arguments['user']);
        channels[call.arguments['channelName']]
            ?.onMemberRemoved!(call.arguments['user']);
        return Future.value(null);
      case 'onAuthorizer':
        return onAuthorizer?.call(call.arguments['channelName'],
            call.arguments['socketId'], call.arguments['options']);
      default:
        throw MissingPluginException('Unknown method ${call.method}');
    }
  }

  Future<void> connect() async {
    await methodChannel.invokeMethod('connect');
  }

  Future<void> disconnect() async {
    await methodChannel.invokeMethod('disconnect');
  }

  Future<PusherChannel> subscribe({required String channelName}) async {
    await methodChannel.invokeMethod("subscribe", {"channelName": channelName});
    return PusherChannel(channelName);
  }

  Future<void> unsubscribe({required String channelName}) async {
    await methodChannel
        .invokeMethod("unsubscribe", {"channelName": channelName});
  }

  Future<void> trigger(
      {required String channelName,
      required String eventName,
      required String data}) async {
    await methodChannel.invokeMethod('trigger',
        {"channelName": channelName, "eventName": eventName, "data": data});
  }

  Future<void> getSocketId() async {
    await methodChannel.invokeMethod('getSocketId');
  }
}
