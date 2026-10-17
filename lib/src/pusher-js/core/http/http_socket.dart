// ignore_for_file: non_constant_identifier_names

@JS()
library http_socket;

import "package:js/js.dart";
import "../socket.dart" show Socket;
import "socket_hooks.dart" show SocketHooks;
import "url_location.dart" show URLLocation;
import "http_request.dart" show HTTPRequest;

@JS()
class State {
  external static num get CONNECTING;
  external static num get OPEN;
  external static num get CLOSED;
}

@JS()
class HTTPSocket implements Socket {
  external SocketHooks get hooks;
  external set hooks(SocketHooks v);
  external String get session;
  external set session(String v);
  external URLLocation get location;
  external set location(URLLocation v);
  external State readyState;
  external HTTPRequest get stream;
  external set stream(HTTPRequest v);
  @override
  external Function([dynamic evt])? onopen;
  @override
  external Function(dynamic)? onerror;
  @override
  external Function(dynamic)? onclose;
  @override
  external Function(dynamic)? onmessage;
  @override
  external Function? onactivity;
  external factory HTTPSocket(SocketHooks hooks, String url);
  @override
  external bool send(dynamic payload);
  @override
  external void ping();
  @override
  external void close([dynamic code, dynamic reason]);
  @override
  external bool sendRaw(dynamic payload);
  external void reconnect();
  external void onClose(dynamic code, dynamic reason, dynamic wasClean);
  external get onChunk;
  external set onChunk(v);
  external get onOpen;
  external set onOpen(v);
  external get onEvent;
  external set onEvent(v);
  external get onActivity;
  external set onActivity(v);
  external get onError;
  external set onError(v);
  external get openStream;
  external set openStream(v);
  external get closeStream;
  external set closeStream(v);
} /* WARNING: export assignment not yet supported. */
