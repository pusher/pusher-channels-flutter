// ignore_for_file: non_constant_identifier_names

@JS()
library runtimes.web.transports.transports;

import "package:js/js.dart";

@JS()
external get SockJSTransport;
@JS()
external set SockJSTransport(v);
@JS()
external get xdrConfiguration;
@JS()
external set xdrConfiguration(v);

/// HTTP streaming transport using XDomainRequest (IE 8,9).
@JS()
external get XDRStreamingTransport;
@JS()
external set XDRStreamingTransport(v);

/// HTTP long-polling transport using XDomainRequest (IE 8,9).
@JS()
external get XDRPollingTransport;
@JS()
external set XDRPollingTransport(
    v); /* WARNING: export assignment not yet supported. */
