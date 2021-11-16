// ignore_for_file: non_constant_identifier_names

@JS()
library core.pusher;

import "package:js/js.dart";
//import "../runtimes/interface.dart" show Runtime;
import "config.dart" show Config;
import "channels/channels.dart" show Channels;
// import "events/dispatcher.dart" show Dispatcher;
//import "timeline/timeline.dart" show Timeline;
// import "timeline/timeline_sender.dart" show TimelineSender;
import "connection/connection_manager.dart" show ConnectionManager;
import "options.dart" show Options;
import "channels/channel.dart" show Channel;

@JS()
class Pusher {
  /// STATIC PROPERTIES
  external static List<Pusher> get instances;
  external static set instances(List<Pusher> v);
  external static bool get isReady;
  external static set isReady(bool v);
  external static bool get logToConsole;
  external static set logToConsole(bool v);

  /// for jsonp
//  external static Runtime get Runtime;
//  external static set Runtime(Runtime v);
  external static dynamic get ScriptReceivers;
  external static set ScriptReceivers(dynamic v);
  external static dynamic get DependenciesReceivers;
  external static set DependenciesReceivers(dynamic v);
  external static dynamic get auth_callbacks;
  external static set auth_callbacks(dynamic v);
  external static ready();
  external static void Function(dynamic) get log;
  external static set log(void Function(dynamic) v);
  external static List<String> getClientFeatures();

  /// INSTANCE PROPERTIES
  external String get key;
  external set key(String v);
  external Config get config;
  external set config(Config v);
  external Channels get channels;
  external set channels(Channels v);
//  external Dispatcher get global_emitter;
//  external set global_emitter(Dispatcher v);
  external num get sessionID;
  external set sessionID(num v);
//  external Timeline get timeline;
//  external set timeline(Timeline v);
//  external TimelineSender get timelineSender;
//  external set timelineSender(TimelineSender v);
  external ConnectionManager get connection;
  external set connection(ConnectionManager v);
//  external PeriodicTimer get timelineSenderTimer;
//  external set timelineSenderTimer(PeriodicTimer v);
  external factory Pusher(String app_key, [Options options]);
  external Channel channel(String name);
  external List<Channel> allChannels();
  external connect();
  external disconnect();
  external Pusher bind(String event_name, Function callback, [dynamic context]);
  external Pusher unbind(
      [String event_name, Function callback, dynamic context]);
  external Pusher bind_global(Function callback);
  external Pusher unbind_global([Function callback]);
  external Pusher unbind_all([Function callback]);
  external subscribeAll();
  external subscribe(String channel_name);
  external unsubscribe(String channel_name);
  external send_event(String event_name, dynamic data, [String channel]);
  external bool shouldUseTLS();
}

@JS()
external checkAppKey(key);
