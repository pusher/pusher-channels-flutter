@JS()
library core.connection.protocol.action;

import "package:js/js.dart";

@anonymous
@JS()
abstract class Action {
  external String get action;
  external set action(String v);
  external String get id;
  external set id(String v);
  external num get activityTimeout;
  external set activityTimeout(num v);
  external dynamic get error;
  external set error(dynamic v);
  external factory Action(
      {String action, String id, num activityTimeout, dynamic error});
}

/* WARNING: export assignment not yet supported. */
