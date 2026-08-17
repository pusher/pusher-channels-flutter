import 'dart:js_interop';

import 'scheduling.dart' show Canceller, Scheduler;
import 'timed_callback.dart' show TimedCallback;

@JS()
extension type Timer._(JSObject _) implements JSObject {
  external factory Timer(
      Scheduler set, Canceller clear, num delay, TimedCallback callback);

  external Canceller get clear;
  external set clear(Canceller v);
  external JSAny? get timer;
  external set timer(JSAny? v);

  /// Returns whether the timer is still running.
  external bool isRunning();

  /// Aborts a timer when it's running.
  external void ensureAborted();
}
