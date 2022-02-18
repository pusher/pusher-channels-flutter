@JS()
library pusher_channels_flutter;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart' as js_util;
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:pusher_channels_flutter/pusher-js/core/auth/options.dart';
import 'package:pusher_channels_flutter/pusher-js/core/channels/channel.dart';
import 'package:pusher_channels_flutter/pusher-js/core/channels/presence_channel.dart';
import 'package:pusher_channels_flutter/pusher-js/core/options.dart';
import 'package:pusher_channels_flutter/pusher-js/core/pusher.dart';

class PusherError extends Error {
  String message;
  int code;
  PusherError(this.message, this.code);
}

@JS('JSON.stringify')
external String stringify(Object obj);

@JS('Object.keys')
external List<String> objectKeys(object);

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
  for (var key in keys) {
    result[key] = dartify(js_util.getProperty(jsObject, key));
  }
  return result as T;
}

class PusherChannelsFlutterWebAuthorizer implements Authorizer {
  final void Function(String socketId, AuthorizerCallback callback) _authorize;
  PusherChannelsFlutterWebAuthorizer(
      void Function(String socketId, AuthorizerCallback callback) authorize)
      : _authorize = authorize;

  @override
  void authorize(String socketId, AuthorizerCallback callback) {
    _authorize(socketId, callback);
  }
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
        return pusher!.sessionID;
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
      throw ArgumentError.notNull("Pusher not initialized");
    }
  }

  void assertChannel(channelName) {
    if (pusher!.channel(channelName) == null) {
      throw ArgumentError.notNull("Not subscribed to channel: $channelName");
    }
  }

  void onError(err) {
    methodChannel!.invokeMethod("onError", {
      "message": err.data?.message,
      "code": err.data?.code,
      "error": dartify(err),
    });
  }

  void onMessage(msg) {
    if (msg.event == 'pusher_internal:subscription_error') {
      methodChannel!.invokeMethod("onSubscriptionError",
          {"message": msg.error, "error": dartify(msg.data)});
    } else if (msg.event == 'pusher_internal:member_added') {
      methodChannel!.invokeMethod("onMemberAdded", {
        "channelName": msg.channel,
        "user": {
          "userId": msg.data.user_id,
          "userInfo": dartify(msg.data.user_info)
        }
      });
    } else if (msg.event == 'pusher_internal:member_removed') {
      methodChannel!.invokeMethod("onMemberRemoved", {
        "channelName": msg.channel,
        "user": {
          "userId": msg.data.user_id,
          "userInfo": dartify(msg.data.user_info)
        }
      });
    } else {
      if (msg.event == 'pusher_internal:subscription_succeeded') {
        if (msg.channel.startsWith('presence-')) {
          final presenceChannel =
              pusher!.channel(msg.channel) as PresenceChannel;
          msg.user_id = presenceChannel.members.myID;
        }
      }
      methodChannel!.invokeMethod("onEvent", {
        "channelName": msg.channel ?? '',
        "eventName": msg.event,
        "data": dartify(msg.data),
        "userId": msg.user_id
      });
    }
  }

  void onStateChange(state) {
    final dartState = dartify(state);
    methodChannel!.invokeMethod("onConnectionStateChange", {
      "currentState": dartState["current"],
      "previousState": dartState["previous"]
    });
  }

  void onConnected(state) {
    print("Connected: " + stringify(state));
  }

  void onDisconnected(state) {
    print("Disconnected: " + stringify(state));
  }

  Authorizer onAuthorizer(Channel channel, AuthorizerOptions options) {
    return PusherChannelsFlutterWebAuthorizer(
        (String socketId, AuthorizerCallback callback) async {
      try {
        var authData = await methodChannel!.invokeMethod('onAuthorizer', {
          "socketId": socketId,
          "channelName": channel.name,
          "options": dartify(options)
        });
        callback(
            null,
            AuthData(
                auth: authData['auth'],
                channel_data: authData['channel_data'],
                shared_secret: authData['shared_secret']));
      } catch (e) {
        callback(PusherError(e.toString(), -1), AuthData(auth: ""));
      }
    });
  }

  void subscribe(MethodCall call) {
    assertPusher();
    var channelName = call.arguments['channelName'];
    pusher!.subscribe(channelName);
  }

  void unsubscribe(MethodCall call) {
    var channelName = call.arguments['channelName'];
    var channel = pusher!.channel(channelName);
    pusher!.unsubscribe(channelName);
    channel.unbind_all();
  }

  void trigger(MethodCall call) {
    var channelName = call.arguments['channelName'];
    var channel = pusher!.channel(channelName);
    channel.trigger(call.arguments['eventName'], call.arguments['data']);
  }

  void init(MethodCall call) {
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
      options.authorizer = allowInterop(onAuthorizer);
    }
    pusher = Pusher(call.arguments['apiKey'], options);
    pusher!.connection.bind('error', allowInterop(onError));
    pusher!.connection.bind('message', allowInterop(onMessage));
    pusher!.connection.bind('state_change', allowInterop(onStateChange));
    pusher!.connection.bind('connected', allowInterop(onConnected));
    pusher!.connection.bind('disconnected', allowInterop(onDisconnected));
  }
}
