@JS()
library core.logger;

import "package:js/js.dart";

@JS()
class Logger {
  // @Ignore
  Logger.fakeConstructor$();
  external debug(
      [dynamic args1,
      dynamic args2,
      dynamic args3,
      dynamic args4,
      dynamic args5]);
  external warn(
      [dynamic args1,
      dynamic args2,
      dynamic args3,
      dynamic args4,
      dynamic args5]);
  external error(
      [dynamic args1,
      dynamic args2,
      dynamic args3,
      dynamic args4,
      dynamic args5]);
  external get globalLog;
  external set globalLog(v);
  external globalLogWarn(String message);
  external globalLogError(String message);
  external log(void Function(String message) defaultLoggingFunction,
      [dynamic args1,
      dynamic args2,
      dynamic args3,
      dynamic args4,
      dynamic args5]);
}

/* WARNING: export assignment not yet supported. */
