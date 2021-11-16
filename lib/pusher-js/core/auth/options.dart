// ignore_for_file: non_constant_identifier_names

@JS()
library core.auth.options;

import "package:js/js.dart";
import "../channels/channel.dart" show Channel;

@anonymous
@JS()
abstract class AuthOptions {
  external dynamic get params;
  external set params(dynamic v);
  external dynamic get headers;
  external set headers(dynamic v);
  external factory AuthOptions({dynamic params, dynamic headers});
}

@anonymous
@JS()
abstract class AuthData {
  external String get auth;
  external set auth(String v);
  external String get channel_data;
  external set channel_data(String v);
  external String get shared_secret;
  external set shared_secret(String v);
  external factory AuthData(
      {String auth, String? channel_data, String? shared_secret});
}

typedef AuthorizerCallback = void Function(Error? error, AuthData authData);

@anonymous
@JS()
abstract class Authorizer {
  external void authorize(String socketId, AuthorizerCallback callback);
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
  external AuthOptions get auth;
  external set auth(AuthOptions v);
  external AuthorizerGenerator get authorizer;
  external set authorizer(AuthorizerGenerator v);
  external factory AuthorizerOptions(
      {String /*'ajax'|'jsonp'*/ authTransport,
      String authEndpoint,
      AuthOptions auth,
      AuthorizerGenerator authorizer});
}
