// ignore_for_file: non_constant_identifier_names, file_names

@JS()
library core.connection.protocol.message_types;

import "package:js/js.dart";

@anonymous
@JS()
abstract class PusherEvent {
  external String get event;
  external set event(String v);
  external String get channel;
  external set channel(String v);
  external dynamic get data;
  external set data(dynamic v);
  external String get user_id;
  external set user_id(String v);
  external factory PusherEvent(
      {String event, String channel, dynamic data, String user_id});
}
