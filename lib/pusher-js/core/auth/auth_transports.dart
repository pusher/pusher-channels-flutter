@JS()
library core.auth.auth_transports;

import "package:js/js.dart";
import "../../runtimes/interface.dart" show Runtime;

typedef void AuthTransport(Runtime context, String socketId, Function callback);

@anonymous
@JS()
abstract class AuthTransports {
  /* Index signature is not yet supported by JavaScript interop. */
}
