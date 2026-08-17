import 'dart:js_interop';

@JS()
extension type Socket(JSObject _) implements JSObject {
  external void send(JSAny? payload);
  external void ping();
  external void close([JSAny? code, JSAny? reason]);
  external bool sendRaw(JSAny? payload);
  external JSFunction? onopen;
  external JSFunction? onerror;
  external JSFunction? onclose;
  external JSFunction? onmessage;
  external JSFunction? onactivity;
}
