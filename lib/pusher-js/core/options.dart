import 'dart:js_interop';

import 'auth/deprecated_channel_authorizer.dart';
import 'auth/options.dart';

extension type Options._(JSObject _) implements JSObject {
  external Options({
    num? activityTimeout,
    DeprecatedAuthOptions? auth,
    String? authEndpoint,
    String? authTransport,
    ChannelAuthorizerGenerator? authorizer,
    ChannelAuthorizationOptions? channelAuthorization,
    UserAuthenticationOptions? userAuthentication,
    String? cluster,
    bool? enableStats,
    bool? disableStats,
    JSArray<JSString>? disabledTransports,
    JSArray<JSString>? enabledTransports,
    bool? forceTLS,
    String? httpHost,
    String? httpPath,
    num? httpPort,
    bool? ignoreNullOrigin,
    // Nacl? nacl;
    num? pongTimeout,
    String? statsHost,
    JSAny timelineParams,
    num? unavailableTimeout,
    String? wsHost,
    String? wsPath,
    num? wsPort,
    num? wssPort,
  });

  external num? activityTimeout;

  @Deprecated('Use channelAuthorization instead')
  external DeprecatedAuthOptions? auth;

  @Deprecated('Use channelAuthorization instead')
  external String? authEndpoint;

  /// Allow 'ajax' | 'jsonp'
  @Deprecated('Use channelAuthorization instead')
  external String? authTransport;

  @Deprecated('Use channelAuthorization instead')
  external ChannelAuthorizerGenerator? authorizer;

  external ChannelAuthorizationOptions? channelAuthorization;

  external UserAuthenticationOptions? userAuthentication;

  external String? cluster;

  external bool? enableStats;

  external bool? disableStats;

  // Allow 'ws' | 'wss' | 'xhr_streaming' | 'xhr_polling' | 'sockjs'
  external JSArray<JSString>? disabledTransports;

  // Allow 'ws' | 'wss' | 'xhr_streaming' | 'xhr_polling' | 'sockjs'
  external JSArray<JSAny>? enabledTransports;

  external bool? forceTLS;

  external String? httpHost;

  external String? httpPath;

  external num? httpPort;

  external bool? ignoreNullOrigin;

  // external Nacl? nacl;

  external num? pongTimeout;

  external String? statsHost;

  external JSAny? timelineParams;

  external num? unavailableTimeout;

  external String? wsHost;

  external String? wsPath;

  external num? wsPort;

  external num? wssPort;
}
