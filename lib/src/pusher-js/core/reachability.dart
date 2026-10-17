@JS()
library core.reachability;

import "package:js/js.dart";
import "events/dispatcher.dart" show Dispatcher;

@anonymous
@JS()
abstract class Reachability implements Dispatcher {
  external bool isOnline();
}

/* WARNING: export assignment not yet supported. */
