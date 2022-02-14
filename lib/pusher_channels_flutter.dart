import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class PusherEvent {
  String channelName;
  String eventName;
  dynamic data;
  String? userId;
  PusherEvent(
      {required this.channelName,
      required this.eventName,
      this.data,
      this.userId});
  @override
  String toString() {
    return "{ channelName: $channelName, eventName: $eventName, data: $data, userId: $userId }";
  }
}

class PusherMember {
  String userId;
  dynamic userInfo;
  PusherMember(this.userId, this.userInfo);
  @override
  String toString() {
    return "{ userId: $userId, userInfo: $userInfo }";
  }
}

class PusherChannel {
  String channelName;
  Set<PusherMember> members = {};
  PusherMember? me;

  Function(dynamic data)? onSubscriptionSucceeded;
  Function(dynamic event)? onEvent;
  Function(PusherMember member)? onMemberAdded;
  Function(PusherMember member)? onMemberRemoved;
  PusherChannel(
      {required this.channelName,
      this.onSubscriptionSucceeded,
      this.onEvent,
      this.onMemberAdded,
      this.onMemberRemoved,
      this.me});

  Future<void> unsubscribe() async {
    return PusherChannelsFlutter.getInstance()
        .unsubscribe(channelName: channelName);
  }

  Future<void> trigger(PusherEvent event) async {
    if (event.channelName != channelName) {
      throw ('Event is not for this channel');
    }
    return PusherChannelsFlutter.getInstance().trigger(event);
  }
}

class PusherChannelsFlutter {
  static PusherChannelsFlutter? _instance;

  MethodChannel methodChannel = const MethodChannel('pusher_channels_flutter');
  Map<String, PusherChannel> channels = {};
  String connectionState = 'DISCONNECTED';
  Function(String currentState, String previousState)? onConnectionStateChange;
  Function(String channelName, dynamic data)? onSubscriptionSucceeded;
  Function(String message, dynamic error)? onSubscriptionError;
  Function(String event, String reason)? onDecryptionFailure;
  Function(String message, int? code, dynamic error)? onError;
  Function(PusherEvent event)? onEvent;
  Function(String channelName, PusherMember member)? onMemberAdded;
  Function(String channelName, PusherMember member)? onMemberRemoved;
  Function(String channelName, String socketId, dynamic options)? onAuthorizer;

  static PusherChannelsFlutter getInstance() {
    _instance ??= PusherChannelsFlutter();
    return _instance!;
  }

  Future<void> init({
    required String apiKey,
    required String cluster,
    bool? useTLS,
    int? activityTimeout,
    int? pongTimeout,
    int? maxReconnectionAttempts,
    int? maxReconnectGapInSeconds,
    String? proxy, // pusher-websocket-java only
    bool? enableStats, // pusher-js only
    List<String>? disabledTransports, // pusher-js only
    List<String>? enabledTransports, // pusher-js only
    bool? ignoreNullOrigin, // pusher-js only
    String? authEndpoint, // pusher-js only
    String? authTransport, // pusher-js only
    Map<String, Map<String, String>>? authParams, // pusher-js only
    bool? logToConsole, // pusher-js only
    Function(String currentState, String previousState)?
        onConnectionStateChange,
    Function(String channelName, dynamic data)? onSubscriptionSucceeded,
    Function(String message, dynamic error)? onSubscriptionError,
    Function(String event, String reason)? onDecryptionFailure,
    Function(String message, int? code, dynamic error)? onError,
    Function(PusherEvent event)? onEvent,
    Function(String channelName, PusherMember member)? onMemberAdded,
    Function(String channelName, PusherMember member)? onMemberRemoved,
    Function(String channelName, String socketId, dynamic options)?
        onAuthorizer,
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
      "activityTimeout": activityTimeout,
      "pongTimeout": pongTimeout,
      "maxReconnectionAttempts": maxReconnectionAttempts,
      "maxReconnectGapInSeconds": maxReconnectGapInSeconds,
      "authorizer": onAuthorizer != null ? true : null,
      "proxy": proxy,
      "enableStats": enableStats,
      "disabledTransports": disabledTransports,
      "enabledTransports": enabledTransports,
      "ignoreNullOrigin": ignoreNullOrigin,
      "authEndpoint": authEndpoint,
      "authTransport": authTransport,
      "authParams": authParams,
      "logToConsole": logToConsole
    });
  }

  Future<dynamic> _platformCallHandler(MethodCall call) async {
    final String? channelName = call.arguments['channelName'];
    final String? eventName = call.arguments['eventName'];
    final dynamic data = call.arguments['data'];
    final dynamic user = call.arguments['user'];
    final String? userId = call.arguments["userId"];
    switch (call.method) {
      case 'onConnectionStateChange':
        connectionState = call.arguments['currentState'].toUpperCase();
        onConnectionStateChange?.call(
            call.arguments['currentState'].toUpperCase(),
            call.arguments['previousState'].toUpperCase());
        return Future.value(null);
      case 'onError':
        onError?.call(call.arguments['message'], call.arguments['code'],
            call.arguments['error']);
        return Future.value(null);
      case 'onEvent':
        switch (eventName) {
          case 'pusher_internal:subscription_succeeded':
            // Depending on the platform implementation we get json or a Map.
            var decodedData = data is Map ? data : jsonDecode(data);
            decodedData?["presence"]?["hash"]?.forEach((_userId, userInfo) {
              var member = PusherMember(_userId, userInfo);
              channels[channelName]?.members.add(member);
              if (_userId == userId) {
                channels[channelName]?.me = member;
              }
            });
            onSubscriptionSucceeded?.call(channelName!, decodedData);
            channels[channelName]?.onSubscriptionSucceeded?.call(decodedData);
            break;
          default:
            final event = PusherEvent(
                channelName: channelName!,
                eventName: eventName!,
                data: data,
                userId: call.arguments['userId']);
            onEvent?.call(event);
            channels[channelName]?.onEvent?.call(event);
            break;
        }
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
        var member = PusherMember(user["userId"], user["userInfo"]);
        onMemberAdded?.call(channelName!, member);
        channels[channelName]?.members.add(member);
        channels[channelName]?.onMemberAdded?.call(member);
        return Future.value(null);
      case 'onMemberRemoved':
        var member = PusherMember(user["userId"], user["userInfo"]);
        onMemberRemoved?.call(channelName!, member);
        channels[channelName]?.onMemberRemoved?.call(member);
        return Future.value(null);
      case 'onAuthorizer':
        return await onAuthorizer?.call(channelName!,
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

  Future<PusherChannel> subscribe(
      {required String channelName,
      var onSubscriptionSucceeded,
      var onSubscriptionError,
      var onMemberAdded,
      var onMemberRemoved,
      var onEvent}) async {
    var channel = PusherChannel(
        channelName: channelName,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onEvent: onEvent);
    await methodChannel.invokeMethod("subscribe", {"channelName": channelName});
    channels[channelName] = channel;
    return channel;
  }

  Future<void> unsubscribe({required String channelName}) async {
    channels.remove(channelName);
    await methodChannel
        .invokeMethod("unsubscribe", {"channelName": channelName});
  }

  Future<void> trigger(PusherEvent event) async {
    if (event.channelName.startsWith("private-") ||
        event.channelName.startsWith("presence-")) {
      await methodChannel.invokeMethod('trigger', {
        "channelName": event.channelName,
        "eventName": event.eventName,
        "data": event.data
      });
    } else {
      throw ('Trigger event is only for private/presence channels');
    }
  }

  Future<void> getSocketId() async {
    await methodChannel.invokeMethod('getSocketId');
  }

  PusherChannel? getChannel(String channelName) {
    return channels[channelName];
  }
}
