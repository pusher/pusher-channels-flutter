// ignore_for_file: non_constant_identifier_names

@JS()
library core.auth.options;

import "package:js/js.dart";
import "../channels/channel.dart" show Channel;

@anonymous
@JS()
abstract class AuthOptions {
  external Map<String, dynamic> get params;
  external set params(Map<String, dynamic> v);
  external Map<String, dynamic> get headers;
  external set headers(Map<String, dynamic> v);

  external factory AuthOptions({
    Map<String, dynamic> params,
    Map<String, dynamic> headers,
  });
}

extension AuthOptionsExt on AuthOptions {
  Map<String, dynamic> toMap() => {
        'params': params,
        'headers': headers,
      };
}

@anonymous
@JS()
abstract class AuthData {
  external String get auth;
  external set auth(String v);
  external String? get channel_data;
  external set channel_data(String? v);
  external String? get shared_secret;
  external set shared_secret(String? v);

  external factory AuthData({
    String auth,
    String? channel_data,
    String? shared_secret,
  });
}

typedef AuthorizerCallback = void Function(Error? error, AuthData authData);

typedef AuthorizeFunc = void Function(
    String socketId, AuthorizerCallback callback);

@anonymous
@JS()
abstract class Authorizer {
  external set authorize(AuthorizeFunc v);
  external AuthorizeFunc get authorize;

  external factory Authorizer({AuthorizeFunc authorize});
}

typedef AuthorizerGenerator = Authorizer Function(
    Channel channel, AuthorizerOptions options);

@anonymous
@JS()
abstract class AuthorizerOptions {
  external String /*'ajax'|'jsonp'*/ get authTransport;
  external set authTransport(String /*'ajax'|'jsonp'*/ v);
  external String get authEndpoint;
  external set authEndpoint(String v);
  external AuthOptions? get auth;
  external set auth(AuthOptions? v);
  external AuthorizerGenerator? get authorizer;
  external set authorizer(AuthorizerGenerator? v);
  external factory AuthorizerOptions({
    String /*'ajax'|'jsonp'*/ authTransport,
    String authEndpoint,
    AuthOptions? auth,
    AuthorizerGenerator? authorizer,
  });
}

extension AuthorizerOptionsExt on AuthorizerOptions {
  Map<String, dynamic> toMap() => {
        'authTransport': authTransport,
        'authEndpoint': authEndpoint,
        'auth': auth,
      };
}
