@JS()
library runtimes.isomorphic.http.http_xhr_request;

import "package:js/js.dart";
import "../../../core/http/request_hooks.dart" show RequestHooks;

@JS()
external RequestHooks get hooks;
@JS()
external set hooks(
    RequestHooks v); /* WARNING: export assignment not yet supported. */
