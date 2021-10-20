@JS()
library core.http.request_hooks;

import "package:js/js.dart";
import "ajax.dart" show Ajax;

@anonymous
@JS()
abstract class RequestHooks {
  external Ajax getRequest(HTTPRequest);
  external void abortRequest(HTTPRequest);
}

/* WARNING: export assignment not yet supported. */
