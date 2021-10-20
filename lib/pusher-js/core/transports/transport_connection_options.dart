@JS()
library core.transports.transport_connection_options;

import "package:js/js.dart";
import "../timeline/timeline.dart" show Timeline;

@anonymous
@JS()
abstract class TransportConnectionOptions {
  external Timeline get timeline;
  external set timeline(Timeline v);
  external num get activityTimeout;
  external set activityTimeout(num v);
  external factory TransportConnectionOptions(
      {Timeline timeline, num activityTimeout});
}

/* WARNING: export assignment not yet supported. */
