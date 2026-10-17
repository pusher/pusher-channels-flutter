@JS()
library core.http.http_factory;

import "package:js/js.dart";
import "http_socket.dart" show HTTPSocket;
import "socket_hooks.dart" show SocketHooks;
import "http_request.dart" show HTTPRequest;
import "request_hooks.dart" show RequestHooks;

@anonymous
@JS()
abstract class HTTPFactory {
  external HTTPSocket createStreamingSocket(String url);
  external HTTPSocket createPollingSocket(String url);
  external HTTPSocket createSocket(SocketHooks hooks, String url);
  external HTTPRequest createXHR(String method, String url);
  external HTTPRequest createXDR(String method, String url);
  external HTTPRequest createRequest(
      RequestHooks hooks, String method, String url);
}

/* WARNING: export assignment not yet supported. */
