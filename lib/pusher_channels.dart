import 'dart:async';

import 'package:flutter/services.dart';

class PusherChannels {
  static const MethodChannel _channel = MethodChannel('pusher_channels');
  static Function? onConnectionStateChangeCallback;
  static Function? onErrorCallback;
  static var eventMap = <String, Map<String, Function>>{};

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onConnectionStateChange':
        onConnectionStateChangeCallback?.call(
            call.arguments['currentState'], call.arguments['previousState']);
        return Future.value('called from platform!');
      case 'onError':
        onErrorCallback?.call(call.arguments['message'], call.arguments['code'],
            call.arguments['e']);
        return Future.value('called from platform!');
      case 'onEvent':
        eventMap[call.arguments['channelName']]?[call.arguments['eventName']]
            ?.call(call.arguments['channelName'], call.arguments['eventName'], call.arguments['event']);
        return Future.value('called from platform!');
      default:
        print('Unknowm method ${call.method}');
        throw MissingPluginException();
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
      int? maxReconnectGapInSeconds}) async {
    Object args = {
      "apiKey": apiKey,
      "cluster": cluster,
    };
    _channel.setMethodCallHandler(_platformCallHandler);
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
      "maxReconnectGapInSeconds": maxReconnectGapInSeconds
    });
  }

  static Future<void> connect(
      {Function? onConnectionStateChange, Function? onError}) async {
    onConnectionStateChangeCallback = onConnectionStateChange;
    onErrorCallback = onError;
    await _channel.invokeMethod('connect');
  }

  static Future<void> subscribe(
      {required String channelName,
      required String eventName,
      required Function onEvent}) async {
    if (eventMap[channelName] == null) {
      await _channel.invokeMethod('subscribe', {"channelName": channelName, "eventName": eventName});
      eventMap[channelName] = <String, Function>{};
    }
    eventMap[channelName]![eventName] = onEvent;
  }
}
