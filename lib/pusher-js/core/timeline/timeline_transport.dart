@JS()
library core.timeline.timeline_transport;

import "package:js/js.dart";
import "timeline_sender.dart" show TimelineSender;

@anonymous
@JS()
abstract class TimelineTransport {
  external String get name;
  external set name(String v);
  external void Function(dynamic, Function) Function(TimelineSender, bool)
      get getAgent;
  external set getAgent(
      void Function(dynamic, Function) Function(TimelineSender, bool) v);
  external factory TimelineTransport(
      {String name,
      void Function(dynamic, Function) Function(TimelineSender, bool)
          getAgent});
}

/* WARNING: export assignment not yet supported. */
