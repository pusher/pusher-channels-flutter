// ignore_for_file: non_constant_identifier_names

@JS()
library core.transports.transports_table;

import "package:js/js.dart";
import "transport.dart" show Transport;

@anonymous
@JS()
abstract class TransportsTable {
  external Transport get ws;
  external set ws(Transport v);
  external Transport get xhr_streaming;
  external set xhr_streaming(Transport v);
  external Transport get xdr_streaming;
  external set xdr_streaming(Transport v);
  external Transport get xhr_polling;
  external set xhr_polling(Transport v);
  external Transport get xdr_polling;
  external set xdr_polling(Transport v);
  external Transport get sockjs;
  external set sockjs(Transport v);
  external factory TransportsTable(
      {Transport ws,
      Transport xhr_streaming,
      Transport xdr_streaming,
      Transport xhr_polling,
      Transport xdr_polling,
      Transport sockjs});
}

/* WARNING: export assignment not yet supported. */
