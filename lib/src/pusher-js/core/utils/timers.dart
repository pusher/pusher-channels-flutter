@JS()
library core.utils.timers;

import "package:js/js.dart";
import "timers/abstract_timer.dart" show Timer;
import "timers/timed_callback.dart" show TimedCallback;

/// We need to bind clear functions this way to avoid exceptions on IE8
@JS()
external clearTimeout(timer);
@JS()
external clearInterval(timer);

/// Cross-browser compatible one-off timer abstraction.
@JS()
class OneOffTimer extends Timer {
  external factory OneOffTimer(num delay, TimedCallback callback);
}

/// Cross-browser compatible periodic timer abstraction.
@JS()
class PeriodicTimer extends Timer {
  external factory PeriodicTimer(num delay, TimedCallback callback);
}
