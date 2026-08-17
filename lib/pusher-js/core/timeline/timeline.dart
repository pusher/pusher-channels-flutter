// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

@JS()
extension type Level._(JSObject _) implements JSObject {
  external static num get ERROR;
  external static num get INFO;
  external static num get DEBUG;
}

@JS()
extension type TimelineOptions._(JSObject _) implements JSObject {
  external factory TimelineOptions(
      {Level level,
      num limit,
      String version,
      String cluster,
      JSArray<JSString> features,
      JSAny? params});

  external Level get level;
  external set level(Level v);
  external num get limit;
  external set limit(num v);
  external String get version;
  external set version(String v);
  external String get cluster;
  external set cluster(String v);
  external JSArray<JSString> get features;
  external set features(JSArray<JSString> v);
  external JSAny? get params;
  external set params(JSAny? v);
}

@JS()
extension type Timeline._(JSObject _) implements JSObject {
  external factory Timeline(String key, num session, TimelineOptions options);

  external String get key;
  external set key(String v);
  external num get session;
  external set session(num v);
  external JSArray<JSAny?> get events;
  external set events(JSArray<JSAny?> v);
  external TimelineOptions get options;
  external set options(TimelineOptions v);
  external num get sent;
  external set sent(num v);
  external num get uniqueID;
  external set uniqueID(num v);
  external void log(JSAny? level, JSAny? event);
  external void error(JSAny? event);
  external void info(JSAny? event);
  external void debug(JSAny? event);
  external bool isEmpty();
  external void send(JSFunction sendfn, JSFunction callback);
  external num generateUniqueID();
}
