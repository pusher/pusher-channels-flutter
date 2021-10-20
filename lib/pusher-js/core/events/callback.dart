@JS()
library core.events.callback;

import "package:js/js.dart";

@anonymous
@JS()
abstract class Callback {
  external Function get fn;
  external set fn(Function v);
  external dynamic get context;
  external set context(dynamic v);
  external factory Callback({Function fn, dynamic context});
}

/* WARNING: export assignment not yet supported. */
