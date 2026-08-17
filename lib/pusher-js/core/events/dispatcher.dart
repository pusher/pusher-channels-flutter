// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

import 'callback_registry.dart' show CallbackRegistry;
import '../channels/metadata.dart' show Metadata;

/// Manages callback bindings and event emitting.
@JS()
extension type Dispatcher._(JSObject _) implements JSObject {
  external factory Dispatcher([JSFunction? failThrough]);

  external CallbackRegistry get callbacks;
  external set callbacks(CallbackRegistry v);
  external JSArray<JSFunction> get global_callbacks;
  external set global_callbacks(JSArray<JSFunction> v);
  external JSFunction get failThrough;
  external set failThrough(JSFunction v);
  external Dispatcher bind(String eventName, JSFunction callback,
      [JSAny? context]);
  external Dispatcher bind_global(JSFunction callback);
  external Dispatcher unbind(
      [String? eventName, JSFunction? callback, JSAny? context]);
  external Dispatcher unbind_global([JSFunction? callback]);
  external Dispatcher unbind_all();
  external Dispatcher emit(String eventName,
      [JSAny? data, Metadata? metadata]);
}
