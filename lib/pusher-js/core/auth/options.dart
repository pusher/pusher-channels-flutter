// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

@JS()
extension type AuthOptions._(JSObject _) implements JSObject {
  external factory AuthOptions({JSObject? params, JSObject? headers});

  external JSObject? get params;
  external set params(JSObject? v);
  external JSObject? get headers;
  external set headers(JSObject? v);
}

extension AuthOptionsExt on AuthOptions {
  Map<String, dynamic> toMap() => {
        'params': params?.dartify(),
        'headers': headers?.dartify(),
      };
}

@JS()
extension type AuthData._(JSObject _) implements JSObject {
  external factory AuthData({
    String auth,
    String? channel_data,
    String? shared_secret,
  });

  external String get auth;
  external set auth(String v);
  external String? get channel_data;
  external set channel_data(String? v);
  external String? get shared_secret;
  external set shared_secret(String? v);
}

/// `void Function(Error? error, AuthData authData)` in the original JS
/// source; kept as an opaque JSFunction since Dart function types can't be
/// used as external member types.
typedef AuthorizerCallback = JSFunction;

/// `void Function(String socketId, AuthorizerCallback callback)`.
typedef AuthorizeFunc = JSFunction;

@JS()
extension type Authorizer._(JSObject _) implements JSObject {
  external factory Authorizer({AuthorizeFunc authorize});

  external set authorize(AuthorizeFunc v);
  external AuthorizeFunc get authorize;
}

/// `Authorizer Function(Channel channel, AuthorizerOptions options)`.
typedef AuthorizerGenerator = JSFunction;

@JS()
extension type AuthorizerOptions._(JSObject _) implements JSObject {
  external factory AuthorizerOptions({
    String authTransport,
    String authEndpoint,
    AuthOptions? auth,
    AuthorizerGenerator? authorizer,
  });

  external String get authTransport;
  external set authTransport(String v);
  external String get authEndpoint;
  external set authEndpoint(String v);
  external AuthOptions? get auth;
  external set auth(AuthOptions? v);
  external AuthorizerGenerator? get authorizer;
  external set authorizer(AuthorizerGenerator? v);
}

extension AuthorizerOptionsExt on AuthorizerOptions {
  Map<String, dynamic> toMap() => {
        'authTransport': authTransport,
        'authEndpoint': authEndpoint,
        'auth': auth?.toMap(),
      };
}
