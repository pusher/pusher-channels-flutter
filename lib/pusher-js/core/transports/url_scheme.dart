import 'dart:js_interop';

@JS()
extension type URLSchemeParams._(JSObject _) implements JSObject {
  external factory URLSchemeParams(
      {bool useTLS, String hostTLS, String hostNonTLS, String httpPath});

  external bool get useTLS;
  external set useTLS(bool v);
  external String get hostTLS;
  external set hostTLS(String v);
  external String get hostNonTLS;
  external set hostNonTLS(String v);
  external String get httpPath;
  external set httpPath(String v);
}

@JS()
extension type URLScheme(JSObject _) implements JSObject {
  external String getInitial(String key, JSAny? params);
  external String getPath(String key, JSAny? options);
}
