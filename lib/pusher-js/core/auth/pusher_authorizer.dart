@JS()
library core.auth.pusher_authorizer;

import "package:js/js.dart";
import "options.dart"
    show Authorizer, AuthorizerOptions, AuthOptions, AuthorizerCallback;
import "auth_transports.dart" show AuthTransports;
import "../channels/channel.dart" show Channel;

@JS()
class PusherAuthorizer implements Authorizer {
  external static AuthTransports get authorizers;
  external static set authorizers(AuthTransports v);
  external Channel get channel;
  external set channel(Channel v);
  external String get type;
  external set type(String v);
  external AuthorizerOptions get options;
  external set options(AuthorizerOptions v);
  external AuthOptions get authOptions;
  external set authOptions(AuthOptions v);
  external factory PusherAuthorizer(Channel channel, AuthorizerOptions options);
  external String composeQuery(String socketId);
  @override
  external void authorize(String socketId, AuthorizerCallback callback);
}
