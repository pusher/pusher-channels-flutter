import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('Error')
external JSErrorConstructor get _jsErrorConstructor;

extension type JSErrorConstructor._(JSFunction _) implements JSFunction {
  JSError call({String message = '', StackTrace? stackTrace}) {
    final wrapper = callAsConstructor<JSError>(message.toJS);
    if (stackTrace != null) {
      wrapper['stack'] = stackTrace.toString().toJS;
    }
    return wrapper;
  }
}

extension type JSError._(JSObject _) implements JSObject {
  static JSError create({String message = '', StackTrace? stackTrace}) {
    return _jsErrorConstructor(
      message: message,
      stackTrace: stackTrace,
    );
  }

  external String get name;

  external String get message;

  external String? get stack;
}
