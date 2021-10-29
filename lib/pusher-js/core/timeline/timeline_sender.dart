@JS()
library core.timeline.timeline_sender;

import "package:js/js.dart";
import "timeline.dart" show Timeline;

@anonymous
@JS()
abstract class TimelineSenderOptions {
  external String get host;
  external set host(String v);
  external num get port;
  external set port(num v);
  external String get path;
  external set path(String v);
  external factory TimelineSenderOptions({String host, num port, String path});
}

@JS()
class TimelineSender {
  external Timeline get timeline;
  external set timeline(Timeline v);
  external TimelineSenderOptions get options;
  external set options(TimelineSenderOptions v);
  external String get host;
  external set host(String v);
  external factory TimelineSender(
      Timeline timeline, TimelineSenderOptions options);
  external send(bool useTLS, [Function callback]);
}
