import 'dart:js_interop';

@JS()
extension type Callback._(JSObject _) implements JSObject {
  external factory Callback({JSFunction fn, JSAny? context});

  external JSFunction get fn;
  external set fn(JSFunction v);
  external JSAny? get context;
  external set context(JSAny? v);
}
