import 'dart:js_interop';

abstract class Socket {
  external void send(dynamic payload);

  external void Function()? ping;

  external dynamic close([dynamic code, dynamic reason]);

  external bool Function(dynamic payload)? sendRaw;

  @JS('onopen')
  external void Function([dynamic evt])? onOpen;

  @JS('onerror')
  external void Function(dynamic error)? onerror;

  @JS('onclose')
  external void Function(dynamic closeEvent)? onclose;

  @JS('onmessage')
  external void Function(dynamic message)? onMessage;

  @JS('onactivity')
  external void Function()? onActivity;
}
