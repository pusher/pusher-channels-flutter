// ignore_for_file: non_constant_identifier_names

@JS()
library core.http.socket_hooks;

import "package:js/js.dart";
import "url_location.dart" show URLLocation;

@anonymous
@JS()
abstract class SocketHooks {
  external String getReceiveURL(URLLocation url, String session);
  external void onHeartbeat(Socket);
  external void sendHeartbeat(Socket);
  external void onFinished(Socket, Status);
}

/* WARNING: export assignment not yet supported. */
