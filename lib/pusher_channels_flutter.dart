import 'dart:async';

import 'package:flutter/services.dart';

class PusherChannelsFlutter {
  static const MethodChannel _channel =
      MethodChannel('pusher_channels_flutter');
  static Function(dynamic currentState, dynamic previousState)?
      onConnectionStateChange;
  static Function(String channelName)? onSubscriptionSucceeded;
  static Function(String message, dynamic e)? onAuthenticationFailure;
  static Function(String event, String reason)? onDecryptionFailure;
  static Function(String message, int? code, dynamic e)? onError;
  static Function(Object event)? onEvent;
  static Function(String channelName, dynamic user)? userSubscribed;
  static Function(String channelName, dynamic user)? userUnsubscribed;
  static Function(String channelName, dynamic users)?
      onUsersInformationReceived;
  static dynamic onAuthorizer;

  static Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onConnectionStateChange':
        onConnectionStateChange?.call(
            call.arguments['currentState'], call.arguments['previousState']);
        return Future.value('called from platform!');
      case 'onError':
        onError?.call(call.arguments['message'], call.arguments['code'],
            call.arguments['e']);
        return Future.value('called from platform!');
      case 'onEvent':
        onEvent?.call(call.arguments);
        return Future.value('called from platform!');
      case 'onSubscriptionSucceeded':
        onSubscriptionSucceeded?.call(call.arguments['channelName']);
        return Future.value('called from platform!');
      case 'onAuthenticationFailure':
        onAuthenticationFailure?.call(
            call.arguments['message'], call.arguments['e']);
        return Future.value('called from platform!');
      case 'onDecryptionFailure':
        onDecryptionFailure?.call(
            call.arguments['event'], call.arguments['reason']);
        return Future.value('called from platform!');
      case 'userSubscribed':
        userSubscribed?.call(
            call.arguments['channelName'], call.arguments['user']);
        return Future.value('called from platform!');
      case 'userUnsubscribed':
        userUnsubscribed?.call(
            call.arguments['channelName'], call.arguments['user']);
        return Future.value('called from platform!');
      case 'onUsersInformationReceived':
        onUsersInformationReceived?.call(
            call.arguments['channelName'], call.arguments['users']);
        return Future.value('called from platform!');
      case 'onAuthorizer':
          return onAuthorizer?.call(call.arguments['channelName'], call.arguments['socketId'], call.arguments['options']);
      default:
        throw MissingPluginException('Unknown method ${call.method}');
    }
  }

  static Future<void> init({
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
    Function(String channelName)? onSubscriptionSucceeded,
    Function(String message, dynamic e)? onAuthenticationFailure,
    Function(String event, String reason)? onDecryptionFailure,
    Function(String message, int? code, dynamic e)? onError,
    Function(Object event)? onEvent,
    Function(String channelName, dynamic user)? userSubscribed,
    Function(String channelName, dynamic user)? userUnsubscribed,
    Function(String channelName, dynamic users)? onUsersInformationReceived,
    dynamic authorizer,
    String? proxy,
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
    _channel.setMethodCallHandler(_platformCallHandler);
    PusherChannelsFlutter.onConnectionStateChange = onConnectionStateChange;
    PusherChannelsFlutter.onError = onError;
    PusherChannelsFlutter.onSubscriptionSucceeded = onSubscriptionSucceeded;
    PusherChannelsFlutter.onEvent = onEvent;
    PusherChannelsFlutter.onAuthenticationFailure = onAuthenticationFailure;
    PusherChannelsFlutter.onDecryptionFailure = onDecryptionFailure;
    PusherChannelsFlutter.userSubscribed = userSubscribed;
    PusherChannelsFlutter.userUnsubscribed = userUnsubscribed;
    PusherChannelsFlutter.onUsersInformationReceived =
        onUsersInformationReceived;
    // For pusher-js we pass a function to authorizer, so we map it to a callback.
    if (authorizer is Function) {
      PusherChannelsFlutter.onAuthorizer = authorizer;
      authorizer = true;
    }
    await _channel.invokeMethod('init', {
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
      "authorizer": authorizer,
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

  static Future<void> connect() async {
    await _channel.invokeMethod('connect');
  }

  static Future<void> _subscribe(
      {required String method,
      required String channelName,
      required String eventName}) async {
    await _channel.invokeMethod(
        method, {"channelName": channelName, "eventName": eventName});
  }

  static Future<void> subscribe(
      {required String channelName, required String eventName}) async {
    await _subscribe(
        method: 'subscribe', channelName: channelName, eventName: eventName);
  }

  static Future<void> subscribePrivate(
      {required String channelName, required String eventName}) async {
    await _subscribe(
        method: 'subscribePrivate',
        channelName: channelName,
        eventName: eventName);
  }

  static Future<void> subscribePrivateEncrypted(
      {required String channelName, required String eventName}) async {
    await _subscribe(
        method: 'subscribePrivateEncrypted',
        channelName: channelName,
        eventName: eventName);
  }

  static Future<void> subscribePresence(
      {required String channelName, required String eventName}) async {
    await _subscribe(
        method: 'subscribePresence',
        channelName: channelName,
        eventName: eventName);
  }

  static Future<void> trigger(
      {required String channelName,
      required String eventName,
      required String data}) async {
    await _channel.invokeMethod('trigger',
        {"channelName": channelName, "eventName": eventName, "data": data});
  }

  static Future<void> getSocketId() async {
    await _channel.invokeMethod('getSocketId');
  }
}
