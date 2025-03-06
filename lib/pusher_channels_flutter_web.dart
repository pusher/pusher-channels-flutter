import 'dart:async';
import 'dart:js_interop';
import 'dart:js_util' as js_util;

// In order to *not* need this ignore, consider extracting the 'web' version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'pusher-js/core/auth/deprecated_channel_authorizer.dart';
import 'pusher-js/core/auth/options.dart';
import 'pusher-js/core/channels/channel.dart';
import 'pusher-js/core/channels/presence_channel.dart';
import 'pusher-js/core/options.dart';
import 'pusher-js/core/pusher.dart';
import 'pusher-js/error.dart';

@JS('JSON.stringify')
external String stringify(JSObject obj);

@JS('Object.keys')
external JSArray<JSString> objectKeys(JSObject object);

bool _isBasicType(value) {
  if (value == null || value is num || value is bool || value is String) {
    return true;
  }
  return false;
}

T dartify<T>(dynamic jsObject) {
  if (_isBasicType(jsObject)) {
    return jsObject as T;
  }
  if (jsObject is List) {
    return jsObject.map(dartify).toList() as T;
  }
  var keys = objectKeys(jsObject);
  var result = <String, dynamic>{};
  for (var key in keys.toDart.map((e) => e.toDart)) {
    result[key] = dartify(js_util.getProperty(jsObject, key));
  }
  return result as T;
}

/// A web implementation of the PusherChannelsFlutter plugin.
class PusherChannelsFlutterWeb {
  Pusher? pusher;
  MethodChannel? methodChannel;

  static void registerWith(Registrar registrar) {
    final pluginInstance = PusherChannelsFlutterWeb();
    pluginInstance.methodChannel = MethodChannel(
      'pusher_channels_flutter',
      const StandardMethodCodec(),
      registrar,
    );
    pluginInstance.methodChannel!
        .setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'init':
        init(call);
        break;
      case 'connect':
        assertPusher();
        pusher!.connect();
        break;
      case 'disconnect':
        assertPusher();
        pusher!.disconnect();
        break;
      case 'subscribe':
        subscribe(call);
        break;
      case 'unsubscribe':
        unsubscribe(call);
        break;
      case 'trigger':
        trigger(call);
        break;
      case 'getSocketId':
        return pusher!.connection.socketId;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'pusher_channels for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  void assertPusher() {
    if (pusher == null) {
      throw ArgumentError.notNull('Pusher not initialized');
    }
  }

  void assertChannel(String channelName) {
    if (pusher!.channel(channelName) == null) {
      throw ArgumentError.notNull('Not subscribed to channel: $channelName');
    }
  }

  void onError(JSAny? jsError) {
    final Map<String, dynamic> error = dartify<Map<String, dynamic>>(jsError);

    if (error['type'] == 'PusherError') {
      methodChannel!.invokeMethod('onError', {
        'message': error['data']?['message'],
        'code': error['data']?['code'],
        'error': error,
      });
    }
  }

  void onMessage(JSAny? jsMessage) {
    final Map<String, dynamic> msg = dartify<Map<String, dynamic>>(jsMessage);
    final String event = msg['event'] ?? '';
    final String channel = msg['channel'] ?? '';
    final Map<String, dynamic> data = msg['data'] ?? {};
    String? userId = data['user_id'];
    final Map<String, dynamic>? userInfo = data['user_info'];

    if (event == 'pusher_internal:subscription_error') {
      methodChannel!.invokeMethod(
          'onSubscriptionError', {'message': msg['error'], 'error': data});
    } else if (event == 'pusher_internal:member_added') {
      methodChannel!.invokeMethod('onMemberAdded', {
        'channelName': channel,
        'user': {
          'userId': userId,
          'userInfo': userInfo,
        }
      });
    } else if (event == 'pusher_internal:member_removed') {
      methodChannel!.invokeMethod('onMemberRemoved', {
        'channelName': channel,
        'user': {
          'userId': userId,
          'userInfo': userInfo,
        }
      });
    } else {
      if (event == 'pusher_internal:subscription_succeeded') {
        if (channel.startsWith('presence-')) {
          final presenceChannel = pusher!.channel(channel) as PresenceChannel;
          final id = presenceChannel.members.myId;
          if (id.isA<JSString>()) {
            userId = (id as JSString).toDart;
          }
        }
      }
      methodChannel!.invokeMethod('onEvent', {
        'channelName': channel,
        'eventName': event,
        'data': data,
        'userId': userId,
      });
    }
  }

  void onStateChange(JSAny? jsState) {
    final Map<String, dynamic> state =
        dartify<Map<String, dynamic>>(jsState ?? {});
    final String current = state['current'] ?? '';
    final String previous = state['previous'] ?? '';
    methodChannel!.invokeMethod('onConnectionStateChange', {
      'currentState': current,
      'previousState': previous,
    });
  }

  void onConnected(JSAny? jsMessage) {}

  void onDisconnected() {}

  DeprecatedChannelAuthorizer onAuthorizer(
    Channel channel,
    DeprecatedAuthorizerOptions options,
  ) =>
      DeprecatedChannelAuthorizer.create(
        FlutterDartDeprecatedChannelAuthorizer(
          methodChannel: methodChannel!,
          channel: channel,
          options: options,
        ),
      );

  void subscribe(MethodCall call) {
    assertPusher();
    var channelName = call.arguments['channelName'];
    pusher!.subscribe(channelName);
  }

  void unsubscribe(MethodCall call) {
    var channelName = call.arguments['channelName'];
    var channel = pusher!.channel(channelName);
    pusher!.unsubscribe(channelName);
    channel?.unbindAll();
  }

  void trigger(MethodCall call) {
    var channelName = call.arguments['channelName'];
    var channel = pusher!.channel(channelName);
    channel?.trigger(call.arguments['eventName'], call.arguments['data']);
  }

  void init(MethodCall call) {
    if (pusher != null) {
      pusher!.unbindAll();
      pusher!.disconnect();
    }
    var options = Options();
    if (call.arguments['cluster'] != null) {
      options.cluster = call.arguments['cluster'];
    }
    if (call.arguments['forceTLS'] != null) {
      options.forceTLS = call.arguments['forceTLS'];
    }
    if (call.arguments['pongTimeout'] != null) {
      options.pongTimeout = call.arguments['pongTimeout'];
    }
    if (call.arguments['enableStats'] != null) {
      options.enableStats = call.arguments['enableStats'];
    }
    if (call.arguments['disabledTransports'] != null) {
      options.disabledTransports = call.arguments['disabledTransports'];
    }
    if (call.arguments['enabledTransports'] != null) {
      options.enabledTransports = call.arguments['enabledTransports'];
    }
    if (call.arguments['ignoreNullOrigin'] != null) {
      options.ignoreNullOrigin = call.arguments['ignoreNullOrigin'];
    }
    if (call.arguments['authTransport'] != null) {
      options.authTransport = call.arguments['authTransport'];
    }
    if (call.arguments['authEndpoint'] != null) {
      options.authEndpoint = call.arguments['authEndpoint'];
    }
    if (call.arguments['authParams'] != null) {
      options.auth = call.arguments['authParams'];
    }
    if (call.arguments['logToConsole'] != null) {
      Pusher.logToConsole = call.arguments['logToConsole'];
    }
    if (call.arguments['authorizer'] != null) {
      options.authorizer = ChannelAuthorizerGenerator.create(onAuthorizer);
    }
    pusher = Pusher(call.arguments['apiKey'], options);
    pusher!.connection.bind('error', onError.toJS);
    pusher!.connection.bind('message', onMessage.toJS);
    pusher!.connection.bind('state_change', onStateChange.toJS);
    pusher!.connection.bind('connected', onConnected.toJS);
    pusher!.connection.bind('disconnected', onDisconnected.toJS);
  }
}

final class FlutterDartDeprecatedChannelAuthorizer
    implements DartDeprecatedChannelAuthorizer {
  const FlutterDartDeprecatedChannelAuthorizer({
    required this.methodChannel,
    required this.channel,
    required this.options,
  });

  final MethodChannel methodChannel;
  final Channel channel;
  final DeprecatedAuthorizerOptions options;

  @override
  void authorize(String socketId, ChannelAuthorizationCallback callback) async {
    try {
      var authData = await methodChannel.invokeMethod('onAuthorizer', {
        'socketId': socketId,
        'channelName': channel.name,
        'options': options.toMap(),
      });
      callback.call(
        null,
        ChannelAuthorizationData.create(
          auth: authData['auth'],
          channelData: authData['channel_data'],
          sharedSecret: authData['shared_secret'],
        ),
      );
    } catch (e, stackTrace) {
      callback.call(
        JSError.create(
          message: '$e',
          stackTrace: stackTrace,
        ),
        null,
      );
    }
  }
}
