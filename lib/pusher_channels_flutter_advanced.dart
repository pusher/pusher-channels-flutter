import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

/// An event received from or sent to a Pusher channel.
class PusherEvent {
  /// Channel that produced or should receive the event.
  String channelName;

  /// Event name, such as `my-event` or `pusher:subscription_succeeded`.
  String eventName;

  /// Event payload. May be a JSON [String], [Map], or other dynamic value.
  dynamic data;

  /// Presence-channel user id when the event is associated with a member.
  String? userId;

  /// Creates a channel event.
  PusherEvent({
    required this.channelName,
    required this.eventName,
    this.data,
    this.userId,
  });

  @override
  String toString() =>
      '{ channelName: $channelName, eventName: $eventName, data: $data, userId: $userId }';
}

/// A member of a Pusher presence channel.
class PusherMember {
  /// Unique user id supplied by the authentication endpoint.
  String userId;

  /// Optional user info object from channel authentication.
  dynamic userInfo;

  /// Creates a presence-channel member.
  PusherMember(this.userId, this.userInfo);

  @override
  String toString() => '{ userId: $userId, userInfo: $userInfo }';
}

/// A subscribed Pusher channel and its local callbacks.
class PusherChannel {
  /// Name of the subscribed channel.
  String channelName;

  /// Presence members keyed by user id.
  Map<String, PusherMember> members = {};

  /// The local user when subscribed to a presence channel.
  PusherMember? me;

  /// Latest `subscription_count` value reported by Pusher.
  int subscriptionCount = 0;

  /// Called when the channel subscription succeeds.
  Function(dynamic data)? onSubscriptionSucceeded;

  /// Called for events on this channel.
  Function(dynamic event)? onEvent;

  /// Called when a presence member is added.
  Function(PusherMember member)? onMemberAdded;

  /// Called when a presence member is removed.
  Function(PusherMember member)? onMemberRemoved;

  /// Called when the channel subscription count changes.
  Function(int subscriptionCount)? onSubscriptionCount;

  /// Creates a local channel handle. Prefer [PusherChannelsFlutter.subscribe].
  PusherChannel({
    required this.channelName,
    this.onSubscriptionSucceeded,
    this.onEvent,
    this.onMemberAdded,
    this.onMemberRemoved,
    this.onSubscriptionCount,
    this.me,
  });

  /// Unsubscribes from this channel.
  Future<void> unsubscribe() async {
    return PusherChannelsFlutter.getInstance()
        .unsubscribe(channelName: channelName);
  }

  /// Triggers a client event on a private or presence channel.
  Future<void> trigger(PusherEvent event) async {
    if (event.channelName != channelName) {
      throw ('Event is not for this channel');
    }
    return PusherChannelsFlutter.getInstance().trigger(event);
  }
}

/// Flutter client for Pusher Channels on Android, iOS, and web.
class PusherChannelsFlutter {
  static PusherChannelsFlutter? _instance;

  /// Platform channel used to talk to native and web implementations.
  MethodChannel methodChannel = const MethodChannel('pusher_channels_flutter');

  /// Currently subscribed channels keyed by name.
  Map<String, PusherChannel> channels = {};

  /// Latest connection state reported by the platform implementation.
  String connectionState = 'DISCONNECTED';

  /// Called when the connection state changes.
  Function(String currentState, String previousState)? onConnectionStateChange;

  /// Called when any channel subscription succeeds.
  Function(String channelName, dynamic data)? onSubscriptionSucceeded;

  /// Called when a channel subscription fails.
  Function(String message, dynamic error)? onSubscriptionError;

  /// Called when decrypting an encrypted event fails.
  Function(String event, String reason)? onDecryptionFailure;

  /// Called when the client reports an error.
  Function(String message, int? code, dynamic error)? onError;

  /// Called for events on any subscribed channel.
  Function(PusherEvent event)? onEvent;

  /// Called when a presence member is added.
  Function(String channelName, PusherMember member)? onMemberAdded;

  /// Called when a presence member is removed.
  Function(String channelName, PusherMember member)? onMemberRemoved;

  /// Called when a private or presence channel needs authentication.
  Function(String channelName, String socketId, dynamic options)? onAuthorizer;

  /// Called when a channel subscription count changes.
  Function(String channelName, int subscriptionCount)? onSubscriptionCount;

  /// Returns the shared client instance.
  static PusherChannelsFlutter getInstance() {
    _instance ??= PusherChannelsFlutter();
    return _instance!;
  }

  /// Configures the client and platform connection options.
  ///
  /// [apiKey] and [cluster] are required. Callbacks may also be supplied later
  /// when calling [subscribe].
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
    Function(String channelName, int subscriptionCount)? onSubscriptionCount,
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
    this.onSubscriptionCount = onSubscriptionCount;
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
          case 'pusher:subscription_succeeded':
          case 'pusher_internal:subscription_succeeded':
            // Depending on the platform implementation we get json or a Map.
            var decodedData = data is Map ? data : jsonDecode(data);
            decodedData?["presence"]?["hash"]?.forEach((userId_, userInfo) {
              var member = PusherMember(userId_, userInfo);
              channels[channelName]?.members[userId_] = member;
              if (userId_ == userId) {
                channels[channelName]?.me = member;
              }
            });
            onSubscriptionSucceeded?.call(channelName!, decodedData);
            channels[channelName]?.onSubscriptionSucceeded?.call(decodedData);
            break;
          case 'pusher:subscription_count':
          case 'pusher_internal:subscription_count':
            // Depending on the platform implementation we get json or a Map.
            var decodedData = data is Map ? data : jsonDecode(data);
            var subscriptionCount = decodedData['subscription_count'];
            channels[channelName]?.subscriptionCount = subscriptionCount;
            onSubscriptionCount?.call(channelName!, subscriptionCount);
            channels[channelName]?.onSubscriptionCount?.call(subscriptionCount);
            break;
        }
        final event = PusherEvent(
            channelName: channelName!,
            eventName: eventName!.replaceFirst("pusher_internal", "pusher"),
            data: data,
            userId: call.arguments['userId']);
        onEvent?.call(event);
        channels[channelName]?.onEvent?.call(event);
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
        channels[channelName]?.members[member.userId] = member;
        onMemberAdded?.call(channelName!, member);
        channels[channelName]?.onMemberAdded?.call(member);
        return Future.value(null);
      case 'onMemberRemoved':
        var member = PusherMember(user["userId"], user["userInfo"]);
        channels[channelName]?.members.remove(member.userId);
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

  /// Opens the connection to Pusher.
  Future<void> connect() async {
    await methodChannel.invokeMethod('connect');
  }

  /// Closes the connection to Pusher.
  Future<void> disconnect() async {
    await methodChannel.invokeMethod('disconnect');
  }

  /// Subscribes to [channelName] and returns a [PusherChannel] handle.
  Future<PusherChannel> subscribe(
      {required String channelName,
      var onSubscriptionSucceeded,
      var onSubscriptionError,
      var onMemberAdded,
      var onMemberRemoved,
      var onEvent,
      var onSubscriptionCount}) async {
    var channel = PusherChannel(
        channelName: channelName,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onSubscriptionCount: onSubscriptionCount,
        onEvent: onEvent);
    await methodChannel.invokeMethod("subscribe", {"channelName": channelName});
    channels[channelName] = channel;
    return channel;
  }

  /// Unsubscribes from [channelName].
  Future<void> unsubscribe({required String channelName}) async {
    channels.remove(channelName);
    await methodChannel
        .invokeMethod("unsubscribe", {"channelName": channelName});
  }

  /// Triggers a client event on a private or presence channel.
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

  /// Returns the current Pusher socket id.
  Future<String> getSocketId() async {
    return (await methodChannel.invokeMethod('getSocketId')).toString();
  }

  /// Returns a previously subscribed channel, if any.
  PusherChannel? getChannel(String channelName) {
    return channels[channelName];
  }
}
