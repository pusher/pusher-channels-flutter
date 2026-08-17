// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

@JS()
extension type ErrorCallbacks._(JSObject _) implements JSObject {
  external factory ErrorCallbacks(
      {JSFunction tls_only,
      JSFunction refused,
      JSFunction backoff,
      JSFunction retry});

  /// `void Function(Action|HandshakePayload)` in the original JS source.
  external JSFunction get tls_only;
  external set tls_only(JSFunction v);
  external JSFunction get refused;
  external set refused(JSFunction v);
  external JSFunction get backoff;
  external set backoff(JSFunction v);
  external JSFunction get retry;
  external set retry(JSFunction v);
}

@JS()
extension type HandshakeCallbacks._(JSObject _) implements JSObject {
  external factory HandshakeCallbacks({JSFunction connected});

  /// `void Function(HandshakePayload)` in the original JS source.
  external JSFunction get connected;
  external set connected(JSFunction v);
}

@JS()
extension type ConnectionCallbacks._(JSObject _) implements JSObject {
  external factory ConnectionCallbacks(
      {JSFunction message,
      JSFunction ping,
      JSFunction activity,
      JSFunction error,
      JSFunction closed});

  external JSFunction get message;
  external set message(JSFunction v);
  external JSFunction get ping;
  external set ping(JSFunction v);
  external JSFunction get activity;
  external set activity(JSFunction v);
  external JSFunction get error;
  external set error(JSFunction v);
  external JSFunction get closed;
  external set closed(JSFunction v);
}
