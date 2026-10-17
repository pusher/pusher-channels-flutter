// ignore_for_file: non_constant_identifier_names

@JS()
library core.defaults;

import "package:js/js.dart";

@anonymous
@JS()
abstract class DefaultConfig {
  external String get VERSION;
  external set VERSION(String v);
  external num get PROTOCOL;
  external set PROTOCOL(num v);
  external num get wsPort;
  external set wsPort(num v);
  external num get wssPort;
  external set wssPort(num v);
  external String get wsPath;
  external set wsPath(String v);
  external String get httpHost;
  external set httpHost(String v);
  external num get httpPort;
  external set httpPort(num v);
  external num get httpsPort;
  external set httpsPort(num v);
  external String get httpPath;
  external set httpPath(String v);
  external String get stats_host;
  external set stats_host(String v);
  external String get authEndpoint;
  external set authEndpoint(String v);
  external String /*'ajax'|'jsonp'*/ get authTransport;
  external set authTransport(String /*'ajax'|'jsonp'*/ v);
  external num get activityTimeout;
  external set activityTimeout(num v);
  external num get pongTimeout;
  external set pongTimeout(num v);
  external num get unavailableTimeout;
  external set unavailableTimeout(num v);
  external String get cluster;
  external set cluster(String v);
  external String get cdn_http;
  external set cdn_http(String v);
  external String get cdn_https;
  external set cdn_https(String v);
  external String get dependency_suffix;
  external set dependency_suffix(String v);
  external factory DefaultConfig(
      {String VERSION,
      num PROTOCOL,
      num wsPort,
      num wssPort,
      String wsPath,
      String httpHost,
      num httpPort,
      num httpsPort,
      String httpPath,
      String stats_host,
      String authEndpoint,
      String /*'ajax'|'jsonp'*/ authTransport,
      num activityTimeout,
      num pongTimeout,
      num unavailableTimeout,
      String cluster,
      String cdn_http,
      String cdn_https,
      String dependency_suffix});
}

@JS()
external DefaultConfig get Defaults;
@JS()
external set Defaults(
    DefaultConfig v); /* WARNING: export assignment not yet supported. */
