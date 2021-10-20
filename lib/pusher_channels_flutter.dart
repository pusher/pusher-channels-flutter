import 'dart:async';

import 'package:flutter/services.dart';

class PusherChannelsFlutter {
  static const MethodChannel _channel =
      MethodChannel('pusher_channels_flutter');
  static Function? onConnectionStateChange;
  static Function? onSubscriptionSucceeded;
  static Function? onAuthenticationFailure;
  static Function? onDecryptionFailure;
  static Function? onError;
  static Function? onEvent;
  static Function? userSubscribed;
  static Function? userUnsubscribed;
  static Function? onUsersInformationReceived;

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
        onSubscriptionSucceeded?.call(call.arguments('channelName'));
        return Future.value('called from platform!');
      case 'onAuthenticationFailure':
        onAuthenticationFailure?.call(
            call.arguments('message'), call.arguments('e'));
        return Future.value('called from platform!');
      case 'onDecryptionFailure':
        onDecryptionFailure?.call(
            call.arguments('event'), call.arguments('reason'));
        return Future.value('called from platform!');
      case 'userSubscribed':
        userSubscribed?.call(
            call.arguments('channelName'), call.arguments('user'));
        return Future.value('called from platform!');
      case 'userUnsubscribed':
        userUnsubscribed?.call(
            call.arguments('channelName'), call.arguments('user'));
        return Future.value('called from platform!');
      case 'onUsersInformationReceived':
        onUsersInformationReceived?.call(
            call.arguments('channelName'), call.arguments('users'));
        return Future.value('called from platform!');
      default:
        throw MissingPluginException('Unknown method ${call.method}');
    }
  }

  static Future<void> init(
      {required String apiKey,
      required String cluster,
      bool? useTLS,
      String? host,
      int? wsPort,
      int? wssPort,
      int? activityTimeout,
      int? pongTimeout,
      int? maxReconnectionAttempts,
      int? maxReconnectGapInSeconds,
      Function? onConnectionStateChange,
      Function? onError,
      Function? onSubscriptionSucceeded,
      Function? onEvent,
      Function? onAuthenticationFailure,
      Function? onDecryptionFailure,
      Function? userSubscribed,
      Function? userUnsubscribed,
      Function? onUsersInformationReceived,
      String? authorizer,
      String? proxy}) async {
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
      "proxy": proxy
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
    await _channel.invokeMethod('invoke',
        {"channelName": channelName, "eventName": eventName, "data": data});
  }

  static Future<void> getSocketId() async {
    await _channel.invokeMethod('getSocketId');
  }
}
