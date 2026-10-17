@JS()
library runtimes.worker.auth.fetch_auth;

import "package:js/js.dart";
import "../../../core/auth/auth_transports.dart" show AuthTransport;

@JS()
external AuthTransport get fetchAuth;
@JS()
external set fetchAuth(
    AuthTransport v); /* WARNING: export assignment not yet supported. */
