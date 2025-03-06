import 'dart:js_interop';

import '../channels/metadata.dart';
import 'callback_registry.dart';

extension type Dispatcher._(JSObject _) implements JSObject {
  external Dispatcher([JSFunction? failThrough]);

  external CallbackRegistry callbacks;

  @JS('global_callbacks')
  external JSArray<JSFunction> globalCallbacks;

  external JSFunction failThrough;

  external Dispatcher bind(String eventName, JSFunction callback,
      [JSAny? context]);

  @JS('bind_global')
  external Dispatcher bindGlobal(JSFunction callback);

  external Dispatcher unbind(
      [String? eventName, JSFunction? callback, JSAny? context]);

  @JS('unbind_global')
  external Dispatcher unbindGlobal([JSFunction? callback]);

  @JS('unbind_all')
  external Dispatcher unbindAll();

  external Dispatcher emit(String eventName, [JSAny? data, Metadata? metadata]);
}
