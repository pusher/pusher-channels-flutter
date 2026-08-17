import 'dart:js_interop';

import '../timeline/timeline.dart' show Timeline;

@JS()
extension type TransportConnectionOptions._(JSObject _) implements JSObject {
  external factory TransportConnectionOptions(
      {Timeline timeline, num activityTimeout});

  external Timeline get timeline;
  external set timeline(Timeline v);
  external num get activityTimeout;
  external set activityTimeout(num v);
}
