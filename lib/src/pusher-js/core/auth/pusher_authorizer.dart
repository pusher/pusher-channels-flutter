@JS()
library core.auth.pusher_authorizer;

import "package:js/js.dart";
import "options.dart" show Authorizer, AuthorizerOptions, AuthOptions;
import "auth_transports.dart" show AuthTransport;
import "../channels/channel.dart" show Channel;

@JS()
abstract class PusherAuthorizer implements Authorizer {
  external static Map<String, AuthTransport> get authorizers;

  external Channel get channel;
  external set channel(Channel v);
  external String get type;
  external set type(String v);
  external AuthorizerOptions get options;
  external set options(AuthorizerOptions v);
  external AuthOptions get authOptions;
  external set authOptions(AuthOptions v);

  external String composeQuery(String socketId);

  external factory PusherAuthorizer({
    Channel channel,
    AuthorizerOptions options,
  });
}
