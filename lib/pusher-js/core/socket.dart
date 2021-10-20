@JS()
library core.socket;

import "package:js/js.dart";

@anonymous
@JS()
abstract class Socket {
  external void send(dynamic payload);
  external void ping();
  external close([dynamic code, dynamic reason]);
  external bool sendRaw(dynamic payload);
  external void onopen([dynamic evt]);
  external void onerror(dynamic error);
  external void onclose(dynamic closeEvent);
  external void onmessage(dynamic message);
  external void onactivity();
}

/* WARNING: export assignment not yet supported. */
