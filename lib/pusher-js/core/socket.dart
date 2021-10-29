@JS()
library core.socket;

import "package:js/js.dart";

@anonymous
@JS()
abstract class Socket {
  external void send(dynamic payload);
  external void ping();
  external void close([dynamic code, dynamic reason]);
  external bool sendRaw(dynamic payload);
  external Function([dynamic evt])? onopen;
  external Function(dynamic error)? onerror;
  external Function(dynamic closeEvent)? onclose;
  external Function(dynamic message)? onmessage;
  external Function? onactivity;
}

/* WARNING: export assignment not yet supported. */
