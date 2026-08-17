// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

import 'config.dart' show Config;
import 'channels/channels.dart' show Channels;
import 'connection/connection_manager.dart' show ConnectionManager;
import 'options.dart' show Options;
import 'channels/channel.dart' show Channel;

@JS()
extension type Pusher._(JSObject _) implements JSObject {
  external factory Pusher(String app_key, [Options? options]);

  /// STATIC PROPERTIES
  external static JSArray<Pusher> get instances;
  external static set instances(JSArray<Pusher> v);
  external static bool get isReady;
  external static set isReady(bool v);
  external static bool get logToConsole;
  external static set logToConsole(bool v);

  /// for jsonp
  external static JSAny? get ScriptReceivers;
  external static set ScriptReceivers(JSAny? v);
  external static JSAny? get DependenciesReceivers;
  external static set DependenciesReceivers(JSAny? v);
  external static JSAny? get auth_callbacks;
  external static set auth_callbacks(JSAny? v);
  external static void ready();
  external static JSFunction get log;
  external static set log(JSFunction v);
  external static JSArray<JSString> getClientFeatures();

  /// INSTANCE PROPERTIES
  external String get key;
  external set key(String v);
  external Config get config;
  external set config(Config v);
  external Channels get channels;
  external set channels(Channels v);
  external num get sessionID;
  external set sessionID(num v);
  external ConnectionManager get connection;
  external set connection(ConnectionManager v);
  external Channel? channel(String name);
  external JSArray<Channel> allChannels();
  external void connect();
  external void disconnect();
  external Pusher bind(String event_name, JSFunction callback,
      [JSAny? context]);
  external Pusher unbind(
      [String? event_name, JSFunction? callback, JSAny? context]);
  external Pusher bind_global(JSFunction callback);
  external Pusher unbind_global([JSFunction? callback]);
  external Pusher unbind_all([JSFunction? callback]);
  external void subscribeAll();
  external void subscribe(String channel_name);
  external void unsubscribe(String channel_name);
  external void send_event(String event_name, JSAny? data, [String? channel]);
  external bool shouldUseTLS();
}

@JS()
external JSAny? checkAppKey(JSAny? key);
