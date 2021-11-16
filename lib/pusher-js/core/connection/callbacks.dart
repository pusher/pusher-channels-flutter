// ignore_for_file: non_constant_identifier_names

@JS()
library core.connection.callbacks;

import "package:js/js.dart";
import "handshake/handshake_payload.dart" show HandshakePayload;

@anonymous
@JS()
abstract class ErrorCallbacks {
  external void Function(dynamic /*Action|HandshakePayload*/) get tls_only;
  external set tls_only(void Function(dynamic /*Action|HandshakePayload*/) v);
  external void Function(dynamic /*Action|HandshakePayload*/) get refused;
  external set refused(void Function(dynamic /*Action|HandshakePayload*/) v);
  external void Function(dynamic /*Action|HandshakePayload*/) get backoff;
  external set backoff(void Function(dynamic /*Action|HandshakePayload*/) v);
  external void Function(dynamic /*Action|HandshakePayload*/) get retry;
  external set retry(void Function(dynamic /*Action|HandshakePayload*/) v);
  external factory ErrorCallbacks(
      {void Function(dynamic /*Action|HandshakePayload*/) tls_only,
      void Function(dynamic /*Action|HandshakePayload*/) refused,
      void Function(dynamic /*Action|HandshakePayload*/) backoff,
      void Function(dynamic /*Action|HandshakePayload*/) retry});
}

@anonymous
@JS()
abstract class HandshakeCallbacks {
  external void Function(HandshakePayload) get connected;
  external set connected(void Function(HandshakePayload) v);
  external factory HandshakeCallbacks(
      {void Function(HandshakePayload) connected});
}

@anonymous
@JS()
abstract class ConnectionCallbacks {
  external void Function(dynamic) get message;
  external set message(void Function(dynamic) v);
  external void Function() get ping;
  external set ping(void Function() v);
  external void Function() get activity;
  external set activity(void Function() v);
  external void Function(dynamic) get error;
  external set error(void Function(dynamic) v);
  external void Function() get closed;
  external set closed(void Function() v);
  external factory ConnectionCallbacks(
      {void Function(dynamic) message,
      void Function() ping,
      void Function() activity,
      void Function(dynamic) error,
      void Function() closed});
}
