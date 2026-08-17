import 'dart:js_interop';

/// Index signature is not directly representable in JS interop; this is a
/// typed opaque handle only (`{[key: string]: Callback[]}` in the JS source).
@JS()
extension type CallbackTable(JSObject _) implements JSObject {}
