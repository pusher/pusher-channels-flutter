@JS()
library core.utils.timers.abstract_timer;

import "package:js/js.dart";
import "scheduling.dart" show Canceller, Scheduler;
import "timed_callback.dart" show TimedCallback;

@JS()
abstract class Timer {
  external Canceller get clear;
  external set clear(Canceller v);
  external dynamic /*num|void*/ get timer;
  external set timer(dynamic /*num|void*/ v);
  external factory Timer(
      Scheduler set, Canceller clear, num delay, TimedCallback callback);

  /// Returns whether the timer is still running.
  external bool isRunning();

  /// Aborts a timer when it's running.
  external ensureAborted();
}

/* WARNING: export assignment not yet supported. */
