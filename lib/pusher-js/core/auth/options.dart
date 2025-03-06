import 'dart:js_interop';

import '../../error.dart';

extension type ChannelAuthorizationData._(JSObject _) implements JSObject {
  static ChannelAuthorizationData create({
    required String auth,
    String? channelData,
    String? sharedSecret,
  }) {
    return (JSObject() as ChannelAuthorizationData)
      ..auth = auth
      ..channelData = channelData
      ..sharedSecret = sharedSecret;
  }

  external String auth;

  @JS('channel_data')
  external String? channelData;

  @JS('shared_secret')
  external String? sharedSecret;
}

extension type ChannelAuthorizationCallback._(JSFunction _)
    implements JSFunction {
  void call(
    JSError? error,
    ChannelAuthorizationData? authData,
  ) =>
      callAsFunction(null, error, authData);
}

extension type ChannelAuthorizationRequestParams._(JSObject _)
    implements JSObject {
  external ChannelAuthorizationRequestParams({
    String socketId,
    String channelName,
  });

  external String socketId;

  external String channelName;
}

typedef DartChannelAuthorizationHandler = void Function(
  ChannelAuthorizationRequestParams params,
  ChannelAuthorizationCallback callback,
);

extension type ChannelAuthorizationHandler._(JSFunction _)
    implements JSFunction {
  static ChannelAuthorizationHandler create(
    DartChannelAuthorizationHandler handler,
  ) =>
      handler.toJS as ChannelAuthorizationHandler;
}

extension type UserAuthenticationData._(JSObject _) implements JSObject {
  static UserAuthenticationData create({
    required String auth,
    required String userData,
  }) {
    return (JSObject() as UserAuthenticationData)
      ..auth = auth
      ..userData = userData;
  }

  external String auth;

  @JS('user_data')
  external String userData;
}

extension type UserAuthenticationCallback._(JSFunction _)
    implements JSFunction {
  void call(
    JSError? error,
    UserAuthenticationData? authData,
  ) =>
      callAsFunction(null, error, authData);
}

extension type UserAuthenticationRequestParams._(JSObject _)
    implements JSObject {
  external String socketId;
}

typedef DartUserAuthenticationHandler = void Function(
  UserAuthenticationRequestParams params,
  UserAuthenticationCallback callback,
);

extension type UserAuthenticationHandler._(JSFunction _) implements JSFunction {
  static UserAuthenticationHandler create(
    DartUserAuthenticationHandler handler,
  ) =>
      handler.toJS as UserAuthenticationHandler;
}

typedef UserAuthenticationOptions = AuthOptionsT<UserAuthenticationHandler>;

typedef ChannelAuthorizationOptions = AuthOptionsT<ChannelAuthorizationHandler>;

extension type AuthOptionsT<AuthHandler extends JSObject>._(JSObject _)
    implements JSObject {
  // Allow 'ajax' | 'jsonp'
  external String transport;

  external String endpoint;

  external JSAny params;

  external JSAny headers;

  external JSFunction? paramsProvider;

  external JSFunction? headersProvider;

  external AuthHandler? customHandler;
}
