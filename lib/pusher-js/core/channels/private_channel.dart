@JS()
library core.channels.private_channel;

import "package:js/js.dart";
import "channel.dart" show Channel;
import "../auth/options.dart" show AuthorizerCallback;

/// Extends public channels to provide private channel interface.
@JS()
class PrivateChannel extends Channel {
  /// Authorizes the connection to use the channel.
  external authorize(String socketId, AuthorizerCallback callback);
}
