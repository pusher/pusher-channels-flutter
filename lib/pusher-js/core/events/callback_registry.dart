// ignore_for_file: non_constant_identifier_names

@JS()
library core.events.callback_registry;

import "package:js/js.dart";
import "callback_table.dart" show CallbackTable;
import "callback.dart" show Callback;

@JS()
class CallbackRegistry {
  // @Ignore
  // CallbackRegistry.fakeConstructor$();
  external CallbackTable get JS$_callbacks;
  external set JS$_callbacks(CallbackTable v);
  external factory CallbackRegistry();
  external List<Callback> get(String name);
  external add(String name, Function callback, dynamic context);
  external remove([String name, Function callback, dynamic context]);
  external removeCallback(
      List<String> names, Function callback, dynamic context);
  external removeAllCallbacks(List<String> names);
}

@JS()
external String prefix(String name);
