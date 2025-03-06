import 'dart:js_interop';

import '../channels/channel.dart';
import 'options.dart';

@JSExport()
abstract class DartDeprecatedChannelAuthorizer {
  @JSExport()
  void authorize(
    String socketId,
    ChannelAuthorizationCallback callback,
  ) {}
}

extension type DeprecatedChannelAuthorizer._(JSObject _) implements JSObject {
  static DeprecatedChannelAuthorizer create(
    DartDeprecatedChannelAuthorizer authorizer,
  ) =>
      createJSInteropWrapper<DartDeprecatedChannelAuthorizer>(authorizer)
          as DeprecatedChannelAuthorizer;

  external void authorize(
    String socketId,
    ChannelAuthorizationCallback callback,
  );
}

typedef DartChannelAuthorizerGenerator = DeprecatedChannelAuthorizer Function(
  Channel channel,
  DeprecatedAuthorizerOptions options,
);

extension type ChannelAuthorizerGenerator._(JSFunction _)
    implements JSFunction {
  static ChannelAuthorizerGenerator create(
          DartChannelAuthorizerGenerator function) =>
      function.toJS as ChannelAuthorizerGenerator;
}

extension type DeprecatedAuthOptions._(JSObject _) implements JSObject {
  external DeprecatedAuthOptions({JSAny? params, JSAny? headers});

  external JSAny? params;

  external JSAny? headers;
}

extension type DeprecatedAuthorizerOptions._(JSObject _) implements JSObject {
  /// Allow 'ajax' | 'jsonp'
  external String authTransport;

  external String authEndpoint;

  external DeprecatedAuthOptions? auth;
}

extension DeprecatedAuthorizerOptionsToDart on DeprecatedAuthorizerOptions {
  Map<String, dynamic> toMap() => {
        'authTransport': authTransport,
        'authEndpoint': authEndpoint,
        'auth': {
          'params': auth?.params?.toExternalReference.toDartObject,
          'headers': auth?.headers?.toExternalReference.toDartObject
        }
      };
}
