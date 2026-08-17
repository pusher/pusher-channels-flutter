import 'dart:js_interop';

import 'auth/options.dart' show AuthOptions, AuthorizerGenerator;

@JS()
extension type Options._(JSObject _) implements JSObject {
  external factory Options(
      {num activityTimeout,
      AuthOptions auth,
      String authEndpoint,
      String /*'ajax'|'jsonp'*/ authTransport,
      AuthorizerGenerator authorizer,
      String cluster,
      bool enableStats,
      bool disableStats,
      JSArray<JSString> disabledTransports,
      JSArray<JSString> enabledTransports,
      bool forceTLS,
      String httpHost,
      String httpPath,
      num httpPort,
      num httpsPort,
      bool ignoreNullOrigin,
      num pongTimeout,
      String statsHost,
      JSAny? timelineParams,
      num unavailableTimeout,
      String wsHost,
      String wsPath,
      num wsPort,
      num wssPort});

  external num get activityTimeout;
  external set activityTimeout(num v);
  external AuthOptions get auth;
  external set auth(AuthOptions v);
  external String get authEndpoint;
  external set authEndpoint(String v);
  external String /*'ajax'|'jsonp'*/ get authTransport;
  external set authTransport(String /*'ajax'|'jsonp'*/ v);
  external AuthorizerGenerator get authorizer;
  external set authorizer(AuthorizerGenerator v);
  external String get cluster;
  external set cluster(String v);
  external bool get enableStats;
  external set enableStats(bool v);
  external bool get disableStats;
  external set disableStats(bool v);
  external JSArray<JSString> get disabledTransports;
  external set disabledTransports(JSArray<JSString> v);
  external JSArray<JSString> get enabledTransports;
  external set enabledTransports(JSArray<JSString> v);
  external bool get forceTLS;
  external set forceTLS(bool v);
  external String get httpHost;
  external set httpHost(String v);
  external String get httpPath;
  external set httpPath(String v);
  external num get httpPort;
  external set httpPort(num v);
  external num get httpsPort;
  external set httpsPort(num v);
  external bool get ignoreNullOrigin;
  external set ignoreNullOrigin(bool v);
  external num get pongTimeout;
  external set pongTimeout(num v);
  external String get statsHost;
  external set statsHost(String v);
  external JSAny? get timelineParams;
  external set timelineParams(JSAny? v);
  external num get unavailableTimeout;
  external set unavailableTimeout(num v);
  external String get wsHost;
  external set wsHost(String v);
  external String get wsPath;
  external set wsPath(String v);
  external num get wsPort;
  external set wsPort(num v);
  external num get wssPort;
  external set wssPort(num v);
}
