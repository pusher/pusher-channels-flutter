import 'dart:js_interop';

extension type Callback._(JSObject _) implements JSObject {
  external JSFunction fn;

  external JSAny? context;
}
