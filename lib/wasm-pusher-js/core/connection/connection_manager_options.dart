import 'dart:js_interop';

import '../timeline/timeline.dart';

extension type ConnectionManagerOptions._(JSObject _) implements JSObject {
  external Timeline timeline;

  external JSFunction getStrategy;

  external num unavailableTimeout;

  external num pongTimeout;

  external num activityTimeout;

  @JS('useTLS')
  external bool useTls;
}

