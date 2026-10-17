@JS()
library core.transports.url_scheme;

import "package:js/js.dart";

@anonymous
@JS()
abstract class URLSchemeParams {
  external bool get useTLS;
  external set useTLS(bool v);
  external String get hostTLS;
  external set hostTLS(String v);
  external String get hostNonTLS;
  external set hostNonTLS(String v);
  external String get httpPath;
  external set httpPath(String v);
  external factory URLSchemeParams(
      {bool useTLS, String hostTLS, String hostNonTLS, String httpPath});
}

@anonymous
@JS()
abstract class URLScheme {
  external String getInitial(String key, dynamic params);
  external String getPath(String key, dynamic options);
}

/* WARNING: export assignment not yet supported. */
