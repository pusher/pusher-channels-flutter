// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:js_interop';

@JS()
extension type PusherEvent._(JSObject _) implements JSObject {
  external factory PusherEvent(
      {String event, String channel, JSAny? data, String user_id});

  external String get event;
  external set event(String v);
  external String get channel;
  external set channel(String v);
  external JSAny? get data;
  external set data(JSAny? v);
  external String get user_id;
  external set user_id(String v);
}
