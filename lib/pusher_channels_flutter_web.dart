@JS()
library pusher_channels_flutter;

import 'dart:async';
import 'package:js/js.dart';
import 'package:js/js_util.dart' as js_util;
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:pusher_channels_flutter/pusher-js/core/channels/channel.dart';
import 'package:pusher_channels_flutter/pusher-js/core/options.dart';
import 'package:pusher_channels_flutter/pusher-js/core/pusher.dart';

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

/// A web implementation of the PusherChannelsFlutter plugin.
class PusherChannelsFlutterWeb {
  Pusher? pusher;
  Map<String, Channel> channels = {};
  Map<String, Set<String>> events = {};
  MethodChannel? channel;

  static void registerWith(Registrar registrar) {
    final pluginInstance = PusherChannelsFlutterWeb();
    pluginInstance.channel = MethodChannel(
      'pusher_channels_flutter',
      const StandardMethodCodec(),
      registrar,
    );
    pluginInstance.channel!
        .setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    print("METHODCALL:" + call.toString());
    switch (call.method) {
      case 'init':
        init(call);
        break;
      case 'connect':
        pusher!.connect();
        break;
      case 'subscribe':
      case 'subscribePrivate':
      case 'subscribePrivateEncrypted':
      case 'subscribePresence':
        subscribe(call);
        break;
      case 'unsubscribe':
        unsubscribe(call);
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

  void onError(err) {
    print("ERROR: " + stringify(err));
    //if( err.error.data.code === 4004 ) {
    //  log('Over limit!');
    //}

    channel!.invokeMethod("onError", {
      "message": err.message,
      "code": err.error?.data?.code,
      "e": dartify(err.error),
    });
  }

  void onMessage(msg) {
    print("Message: " + stringify(msg));
    if (events[msg.channel]?.contains(msg.event) == true) {
      channel!.invokeMethod("onEvent", {
        "channelName": msg.channel,
        "eventName": msg.event,
        "data": dartify(msg.data),
        "userId": msg.user_id
      });
    }
    if (msg.event.startsWith('pusher:')) {
      print("INTERNAL EVENT!");
    }
    if (msg.event== 'pusher_internal:subscription_succeeded') {
      channel!.invokeMethod("onSubscriptionSucceeded", msg.channel);
    }
  }

  void onStateChange(state) {
    channel!.invokeMethod("onConnectionStateChange",
        {"currentState": state.current, "previousState": state.previous});
  }

  void onConnected(state) {
    print("Connected: " + stringify(state));

  }

  void onDisconnected(state) {
    print("Disconnected: " + stringify(state));
  }

  void subscribe(MethodCall call) {
    var channelName = call.arguments['channelName'];
    print("channelname:" + channelName);
    if (channels[channelName] == null) {
      channels[channelName] = pusher!.subscribe(channelName);
      events[channelName] = {};
    }
    events[channelName]!.add(call.arguments['eventName']);
  }

  void unsubscribe(MethodCall call) {
    var channelName = call.arguments['channelName'];
    print("unsubscribe channelname:" + channelName);
    pusher!.unsubscribe(channelName);
    channels[channelName]!.unbind_all();
    channels.remove(channelName);
    events.remove(channelName);
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
    if (call.arguments['httpHost'] != null) {
      options.httpHost = call.arguments['httpHost'];
    }
    if (call.arguments['httpPath'] != null) {
      options.httpPath = call.arguments['httpPath'];
    }
    if (call.arguments['httpPort'] != null) {
      options.httpPort = call.arguments['httpPort'];
    }
    if (call.arguments['httpsPort'] != null) {
      options.httpsPort = call.arguments['httpsPort'];
    }
    if (call.arguments['ignoreNullOrigin'] != null) {
      options.ignoreNullOrigin = call.arguments['ignoreNullOrigin'];
    }
    if (call.arguments['wsHost'] != null) {
      options.wsHost = call.arguments['wsHost'];
    }
    if (call.arguments['wsPath'] != null) {
      options.wsPath = call.arguments['wsPath'];
    }
    if (call.arguments['wsPort'] != null) {
      options.wsPort = call.arguments['wsPort'];
    }
    if (call.arguments['wssPort'] != null) {
      options.wssPort = call.arguments['wssPort'];
    }
    if (call.arguments['authTransport'] != null) {
      options.authTransport = call.arguments['authTransport'];
    }
    if (call.arguments['authEndpoint'] != null) {
      options.authEndpoint = call.arguments['authEndpoint'];
    }
    if (call.arguments['statsHost'] != null) {
      options.statsHost = call.arguments['statsHost'];
    }

    /* Options({
          activityTimeout,
          AuthOptions auth,
          String authEndpoint,
          String /*'ajax'|'jsonp'*/ authTransport,
          AuthorizerGenerator authorizer,
          String cluster,
          bool enableStats,
          bool disableStats,
          List<String /*'ws'|'wss'|'xhr_streaming'|'xhr_polling'|'sockjs'*/ >
              disabledTransports,
          List<String /*'ws'|'wss'|'xhr_streaming'|'xhr_polling'|'sockjs'*/ >
              enabledTransports,
          bool forceTLS,
          String httpHost,
          String httpPath,
          num httpPort,
          num httpsPort,
          bool ignoreNullOrigin,
          //    nacl nacl,
          num pongTimeout,
          String statsHost,
          dynamic timelineParams,
          num unavailableTimeout,
          String wsHost,
          String wsPath,
          num wsPort,
          num wssPort} */

    pusher = Pusher(call.arguments['apiKey'], options);
    pusher!.connection.bind('error', allowInterop(onError));
    pusher!.connection.bind('message', allowInterop(onMessage));
    pusher!.connection.bind('state_change', allowInterop(onStateChange));
    pusher!.connection.bind('connected', allowInterop(onConnected));
    pusher!.connection.bind('disconnected', allowInterop(onDisconnected));
  }
}
