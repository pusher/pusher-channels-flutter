@JS()
library core.channels.private_channel;

import "package:js/js.dart";
import 'package:pusher_channels_flutter/pusher-js/core/pusher.dart';
import "channel.dart" show Channel;
import "../auth/options.dart" show AuthorizerCallback;

/// Extends public channels to provide private channel interface.
@JS()
class PrivateChannel extends Channel {
  external factory PrivateChannel(String name, Pusher pusher);

  /// Authorizes the connection to use the channel.
  @override
  external authorize(String socketId, AuthorizerCallback callback);
}
