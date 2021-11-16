// ignore_for_file: non_constant_identifier_names

@JS()
library runtimes.isomorphic.transports.transports;

import "package:js/js.dart";
import "../../../core/transports/transports_table.dart" show TransportsTable;

/// WebSocket transport.
/// Uses native WebSocket implementation, including MozWebSocket supported by
/// earlier Firefox versions.
@JS()
external get WSTransport;
@JS()
external set WSTransport(v);
@JS()
external get httpConfiguration;
@JS()
external set httpConfiguration(v);
@JS()
external get streamingConfiguration;
@JS()
external set streamingConfiguration(v);
@JS()
external get pollingConfiguration;
@JS()
external set pollingConfiguration(v);
@JS()
external get xhrConfiguration;
@JS()
external set xhrConfiguration(v);

/// HTTP streaming transport using CORS-enabled XMLHttpRequest.
@JS()
external get XHRStreamingTransport;
@JS()
external set XHRStreamingTransport(v);

/// HTTP long-polling transport using CORS-enabled XMLHttpRequest.
@JS()
external get XHRPollingTransport;
@JS()
external set XHRPollingTransport(v);
@JS()
external TransportsTable get Transports;
@JS()
external set Transports(
    TransportsTable v); /* WARNING: export assignment not yet supported. */
