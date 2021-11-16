// ignore_for_file: non_constant_identifier_names

@JS()
library core.http.http_request;

import "package:js/js.dart";
import "../events/dispatcher.dart" show Dispatcher;
import "request_hooks.dart" show RequestHooks;
import "ajax.dart" show Ajax;

@JS()
external get MAX_BUFFER_LENGTH;

@JS()
class HTTPRequest extends Dispatcher {
  external RequestHooks get hooks;
  external set hooks(RequestHooks v);
  external String get method;
  external set method(String v);
  external String get url;
  external set url(String v);
  external num get position;
  external set position(num v);
  external Ajax get xhr;
  external set xhr(Ajax v);
  external Function get unloader;
  external set unloader(Function v);
  external factory HTTPRequest(RequestHooks hooks, String method, String url);
  external start([dynamic payload]);
  external close();
  external onChunk(num status, dynamic data);
  external dynamic advanceBuffer(List<dynamic> buffer);
  external bool isBufferTooLong(dynamic buffer);
}
