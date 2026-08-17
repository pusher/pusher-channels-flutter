import 'dart:js_interop';

import 'auth/options.dart' show AuthOptions, AuthorizerGenerator;
import 'options.dart' show Options;

/*export type AuthTransport = 'ajax' | 'jsonp';*/
/*export type Transport =
  | 'ws'
  | 'wss'
  | 'xhr_streaming'
  | 'xhr_polling'
  | 'sockjs';
*/
@JS()
extension type Config._(JSObject _) implements JSObject {
  external factory Config(
      {num activityTimeout,
      String authEndpoint,
      String /*'ajax'|'jsonp'*/ authTransport,
      bool enableStats,
      String httpHost,
      String httpPath,
      num httpPort,
      num httpsPort,
      num pongTimeout,
      String statsHost,
      num unavailableTimeout,
      bool useTLS,
      String wsHost,
      String wsPath,
      num wsPort,
      num wssPort,
      bool forceTLS,
      AuthOptions auth,
      AuthorizerGenerator authorizer,
      String cluster,
      JSArray<JSString> disabledTransports,
      JSArray<JSString> enabledTransports,
      bool ignoreNullOrigin,
      JSAny? timelineParams});

  /// these are all 'required' config parameters, it's not necessary for the user
  /// to set them, but they have configured defaults.
  external num get activityTimeout;
  external set activityTimeout(num v);
  external String get authEndpoint;
  external set authEndpoint(String v);
  external String /*'ajax'|'jsonp'*/ get authTransport;
  external set authTransport(String /*'ajax'|'jsonp'*/ v);
  external bool get enableStats;
  external set enableStats(bool v);
  external String get httpHost;
  external set httpHost(String v);
  external String get httpPath;
  external set httpPath(String v);
  external num get httpPort;
  external set httpPort(num v);
  external num get httpsPort;
  external set httpsPort(num v);
  external num get pongTimeout;
  external set pongTimeout(num v);
  external String get statsHost;
  external set statsHost(String v);
  external num get unavailableTimeout;
  external set unavailableTimeout(num v);
  external bool get useTLS;
  external set useTLS(bool v);
  external String get wsHost;
  external set wsHost(String v);
  external String get wsPath;
  external set wsPath(String v);
  external num get wsPort;
  external set wsPort(num v);
  external num get wssPort;
  external set wssPort(num v);

  /// these are all optional parameters or overrrides. The customer can set these
  /// but it's not strictly necessary
  external bool get forceTLS;
  external set forceTLS(bool v);
  external AuthOptions get auth;
  external set auth(AuthOptions v);
  external AuthorizerGenerator get authorizer;
  external set authorizer(AuthorizerGenerator v);
  external String get cluster;
  external set cluster(String v);
  external JSArray<JSString> get disabledTransports;
  external set disabledTransports(JSArray<JSString> v);
  external JSArray<JSString> get enabledTransports;
  external set enabledTransports(JSArray<JSString> v);
  external bool get ignoreNullOrigin;
  external set ignoreNullOrigin(bool v);
  external JSAny? get timelineParams;
  external set timelineParams(JSAny? v);
}

@JS()
external Config getConfig(Options opts);
@JS()
external String getHttpHost(Options opts);
@JS()
external String getWebsocketHost(Options opts);
@JS()
external String getWebsocketHostFromCluster(String cluster);
@JS()
external bool shouldUseTLS(Options opts);

/// if enableStats is set take the value
/// if disableStats is set take the inverse
/// otherwise default to false
@JS()
external bool getEnableStatsConfig(Options opts);
