@JS()
library core.auth.auth_transports;

import "package:js/js.dart";
import "../../runtimes/interface.dart" show Runtime;

typedef AuthTransport = void Function(
    Runtime context, String socketId, Function callback);

// @anonymous
// @JS()
// abstract class AuthTransports {

// }
