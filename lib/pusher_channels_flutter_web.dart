import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Error forwarded from the pusher-js web client.
class PusherError extends Error {
  /// Human-readable error message.
  String message;

  /// Numeric error code from pusher-js, or `-1` when unknown.
  int code;

  /// Creates a web client error.
  PusherError(this.message, this.code);
}

@JS('Pusher')
extension type _JSPusher._(JSObject _) implements JSObject {
  external factory _JSPusher(String appKey, [JSAny? options]);
  external static set logToConsole(bool v);
  external _JSConnection get connection;
  external void connect();
  external void disconnect();
  external JSAny? subscribe(String channelName);
  external void unsubscribe(String channelName);
  external _JSChannel? channel(String name);
  @JS('unbind_all')
  external _JSPusher unbindAll([JSFunction? callback]);
}

@JS()
extension type _JSConnection._(JSObject _) implements JSObject {
  @JS('socket_id')
  external String get socketId;
  external JSAny bind(String eventName, JSFunction callback);
}

@JS()
extension type _JSChannel._(JSObject _) implements JSObject {
  external String get name;
  external void trigger(String event, JSAny? data);
  @JS('unbind_all')
  external void unbindAll();
  external _JSMembers get members;
}

@JS()
extension type _JSMembers._(JSObject _) implements JSObject {
  external JSAny? get myID;
}

Map<String, dynamic> _asStringKeyedMap(Object? value) {
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val));
  }
  return <String, dynamic>{};
}

/// A web implementation of the PusherChannelsFlutter plugin.
class PusherChannelsFlutterWeb {
  _JSPusher? _pusher;
  MethodChannel? methodChannel;

  /// Registers this implementation with the Flutter web plugin registrar.
  static void registerWith(Registrar registrar) {
    final pluginInstance = PusherChannelsFlutterWeb();
    pluginInstance.methodChannel = MethodChannel(
      'pusher_channels_flutter',
      const StandardMethodCodec(),
      registrar,
    );
    pluginInstance.methodChannel!.setMethodCallHandler(
      pluginInstance.handleMethodCall,
    );
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'init':
        init(call);
        break;
      case 'connect':
        assertPusher();
        _pusher!.connect();
        break;
      case 'disconnect':
        assertPusher();
        _pusher!.disconnect();
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
        return _pusher!.connection.socketId;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'pusher_channels for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  void assertPusher() {
    if (_pusher == null) {
      throw ArgumentError.notNull('Pusher not initialized');
    }
  }

  void assertChannel(String channelName) {
    if (_pusher!.channel(channelName) == null) {
      throw ArgumentError.notNull('Not subscribed to channel: $channelName');
    }
  }

  void onError(JSAny jsError) {
    final Map<String, dynamic> error = _asStringKeyedMap(jsError.dartify());

    if (error['type'] == 'PusherError') {
      final data = _asStringKeyedMap(error['data']);
      methodChannel!.invokeMethod('onError', {
        'message': data['message'],
        'code': data['code'],
        'error': error,
      });
    }
  }

  void onMessage(JSAny jsMessage) {
    final Map<String, dynamic> msg = _asStringKeyedMap(jsMessage.dartify());
    final String event = msg['event'] ?? '';
    final String channel = msg['channel'] ?? '';
    final Map<String, dynamic> data = _asStringKeyedMap(msg['data']);
    String? userId = data['user_id']?.toString();
    final Map<String, dynamic>? userInfo = data['user_info'] is Map
        ? _asStringKeyedMap(data['user_info'])
        : null;

    if (event == 'pusher_internal:subscription_error') {
      methodChannel!.invokeMethod('onSubscriptionError', {
        'message': msg['error'],
        'error': data,
      });
    } else if (event == 'pusher_internal:member_added') {
      methodChannel!.invokeMethod('onMemberAdded', {
        'channelName': channel,
        'user': {'userId': userId, 'userInfo': userInfo},
      });
    } else if (event == 'pusher_internal:member_removed') {
      methodChannel!.invokeMethod('onMemberRemoved', {
        'channelName': channel,
        'user': {'userId': userId, 'userInfo': userInfo},
      });
    } else {
      if (event == 'pusher_internal:subscription_succeeded') {
        if (channel.startsWith('presence-')) {
          final presenceChannel = _pusher!.channel(channel);
          final myId = presenceChannel?.members.myID?.dartify();
          if (myId != null) {
            userId = myId.toString();
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

  void onStateChange(JSAny jsState) {
    final Map<String, dynamic> state = _asStringKeyedMap(jsState.dartify());
    final String current = state['current'] ?? '';
    final String previous = state['previous'] ?? '';
    methodChannel!.invokeMethod('onConnectionStateChange', {
      'currentState': current,
      'previousState': previous,
    });
  }

  void onConnected(JSAny jsMessage) {}

  void onDisconnected() {}

  JSObject onAuthorizer(JSAny channel, JSAny options) {
    void authorize(JSString socketId, JSFunction callback) {
      unawaited(_authorize(channel, options, socketId.toDart, callback));
    }

    final authorizer = JSObject();
    authorizer['authorize'] = authorize.toJS;
    return authorizer;
  }

  Future<void> _authorize(
    JSAny channel,
    JSAny options,
    String socketId,
    JSFunction callback,
  ) async {
    try {
      final channelName = (channel as JSObject)['name']?.dartify()?.toString();
      var authData = await methodChannel!.invokeMethod('onAuthorizer', {
        'socketId': socketId,
        'channelName': channelName,
        'options': _asStringKeyedMap(options.dartify()),
      });
      callback.callAsFunction(
        null,
        null,
        {
          'auth': authData['auth'],
          'channel_data': authData['channel_data'],
          'shared_secret': authData['shared_secret'],
        }.jsify(),
      );
    } catch (e) {
      callback.callAsFunction(null, e.toString().toJS, {'auth': ''}.jsify());
    }
  }

  void subscribe(MethodCall call) {
    assertPusher();
    var channelName = call.arguments['channelName'];
    _pusher!.subscribe(channelName);
  }

  void unsubscribe(MethodCall call) {
    var channelName = call.arguments['channelName'];
    var channel = _pusher!.channel(channelName);
    _pusher!.unsubscribe(channelName);
    channel?.unbindAll();
  }

  void trigger(MethodCall call) {
    var channelName = call.arguments['channelName'];
    var channel = _pusher!.channel(channelName);
    channel?.trigger(
      call.arguments['eventName'],
      (call.arguments['data'] as Object?).jsify(),
    );
  }

  void init(MethodCall call) {
    if (_pusher != null) {
      _pusher!.unbindAll();
      _pusher!.disconnect();
    }
    final options = JSObject();
    if (call.arguments['cluster'] != null) {
      options['cluster'] = (call.arguments['cluster'] as String).toJS;
    }
    if (call.arguments['forceTLS'] != null) {
      options['forceTLS'] = (call.arguments['forceTLS'] as bool).toJS;
    }
    if (call.arguments['pongTimeout'] != null) {
      options['pongTimeout'] = (call.arguments['pongTimeout'] as num).toJS;
    }
    if (call.arguments['enableStats'] != null) {
      options['enableStats'] = (call.arguments['enableStats'] as bool).toJS;
    }
    if (call.arguments['disabledTransports'] != null) {
      options['disabledTransports'] =
          (call.arguments['disabledTransports'] as Object).jsify();
    }
    if (call.arguments['enabledTransports'] != null) {
      options['enabledTransports'] =
          (call.arguments['enabledTransports'] as Object).jsify();
    }
    if (call.arguments['ignoreNullOrigin'] != null) {
      options['ignoreNullOrigin'] =
          (call.arguments['ignoreNullOrigin'] as bool).toJS;
    }
    if (call.arguments['authTransport'] != null) {
      options['authTransport'] =
          (call.arguments['authTransport'] as String).toJS;
    }
    if (call.arguments['authEndpoint'] != null) {
      options['authEndpoint'] = (call.arguments['authEndpoint'] as String).toJS;
    }
    if (call.arguments['authParams'] != null) {
      options['auth'] = (call.arguments['authParams'] as Object).jsify();
    }
    if (call.arguments['logToConsole'] != null) {
      _JSPusher.logToConsole = call.arguments['logToConsole'];
    }
    if (call.arguments['authorizer'] != null) {
      options['authorizer'] = onAuthorizer.toJS;
    }
    _pusher = _JSPusher(call.arguments['apiKey'], options);
    _pusher!.connection.bind('error', onError.toJS);
    _pusher!.connection.bind('message', onMessage.toJS);
    _pusher!.connection.bind('state_change', onStateChange.toJS);
    _pusher!.connection.bind('connected', onConnected.toJS);
    _pusher!.connection.bind('disconnected', onDisconnected.toJS);
  }
}
