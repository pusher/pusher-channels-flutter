// ignore_for_file: non_constant_identifier_names

@JS()
library core.timeline.timeline;

import "package:js/js.dart";

@JS()
class Level {
  external static num get ERROR;
  external static num get INFO;
  external static num get DEBUG;
}

@anonymous
@JS()
abstract class TimelineOptions {
  external Level get level;
  external set level(Level v);
  external num get limit;
  external set limit(num v);
  external String get version;
  external set version(String v);
  external String get cluster;
  external set cluster(String v);
  external List<String> get features;
  external set features(List<String> v);
  external dynamic get params;
  external set params(dynamic v);
  external factory TimelineOptions(
      {Level level,
      num limit,
      String version,
      String cluster,
      List<String> features,
      dynamic params});
}

@JS()
class Timeline {
  external String get key;
  external set key(String v);
  external num get session;
  external set session(num v);
  external List<dynamic> get events;
  external set events(List<dynamic> v);
  external TimelineOptions get options;
  external set options(TimelineOptions v);
  external num get sent;
  external set sent(num v);
  external num get uniqueID;
  external set uniqueID(num v);
  external factory Timeline(String key, num session, TimelineOptions options);
  external log(level, event);
  external error(event);
  external info(event);
  external debug(event);
  external isEmpty();
  external send(sendfn, callback);
  external num generateUniqueID();
}
