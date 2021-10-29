@JS()
library runtimes.web.dom.script_receiver;

import "package:js/js.dart";

@anonymous
@JS()
abstract class ScriptReceiver {
  external num get number;
  external set number(num v);
  external String get id;
  external set id(String v);
  external String get name;
  external set name(String v);
  external Function get callback;
  external set callback(Function v);
  external factory ScriptReceiver(
      {num number, String id, String name, Function callback});
}

/* WARNING: export assignment not yet supported. */
