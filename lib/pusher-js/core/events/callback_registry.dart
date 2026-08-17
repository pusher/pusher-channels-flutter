// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

import 'callback_table.dart' show CallbackTable;
import 'callback.dart' show Callback;

@JS()
extension type CallbackRegistry._(JSObject _) implements JSObject {
  external factory CallbackRegistry();

  external CallbackTable get JS$_callbacks;
  external set JS$_callbacks(CallbackTable v);
  external JSArray<Callback> get(String name);
  external void add(String name, JSFunction callback, [JSAny? context]);
  external void remove([String? name, JSFunction? callback, JSAny? context]);
  external void removeCallback(
      JSArray<JSString> names, JSFunction callback, JSAny? context);
  external void removeAllCallbacks(JSArray<JSString> names);
}

@JS()
external String prefix(String name);
