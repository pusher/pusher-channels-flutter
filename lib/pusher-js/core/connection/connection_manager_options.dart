import 'dart:js_interop';

import '../timeline/timeline.dart' show Timeline;

@JS()
extension type ConnectionManagerOptions._(JSObject _) implements JSObject {
  external factory ConnectionManagerOptions(
      {Timeline timeline,
      JSFunction getStrategy,
      num unavailableTimeout,
      num pongTimeout,
      num activityTimeout,
      bool useTLS});

  external Timeline get timeline;
  external set timeline(Timeline v);

  /// `Strategy Function(dynamic)` in the original JS source; kept as an
  /// opaque JSFunction since Dart function types can't be used as external
  /// member types.
  external JSFunction get getStrategy;
  external set getStrategy(JSFunction v);
  external num get unavailableTimeout;
  external set unavailableTimeout(num v);
  external num get pongTimeout;
  external set pongTimeout(num v);
  external num get activityTimeout;
  external set activityTimeout(num v);
  external bool get useTLS;
  external set useTLS(bool v);
}
