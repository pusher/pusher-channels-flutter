import 'dart:js_interop';

import 'url_scheme.dart' show URLScheme;
import '../socket.dart' show Socket;

@JS()
extension type TransportHooks(JSObject _) implements JSObject {
  external String get file;
  external set file(String v);
  external URLScheme get urls;
  external set urls(URLScheme v);
  external bool get handlesActivityChecks;
  external set handlesActivityChecks(bool v);
  external bool get supportsPing;
  external set supportsPing(bool v);
  external bool isInitialized();
  external bool isSupported([JSAny? environment]);
  external Socket getSocket(String url, [JSAny? options]);
  external JSFunction get beforeOpen;
  external set beforeOpen(JSFunction v);
}
