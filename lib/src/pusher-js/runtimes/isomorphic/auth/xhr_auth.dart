@JS()
library runtimes.isomorphic.auth.xhr_auth;

import "package:js/js.dart";
import "../../../core/auth/auth_transports.dart" show AuthTransport;

@JS()
external AuthTransport get ajax;
@JS()
external set ajax(
    AuthTransport v); /* WARNING: export assignment not yet supported. */
