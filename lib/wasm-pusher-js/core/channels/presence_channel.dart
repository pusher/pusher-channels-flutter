import 'dart:js_interop';

import '../connection/protocol/message_types.dart';
import '../pusher.dart';
import 'members.dart';
import 'private_channel.dart';

extension type PresenceChannel._(PrivateChannel _) implements PrivateChannel {
  external PresenceChannel({
    String name,
    Pusher pusher,
  });

  external Members members;

  external void authorize(String socketId, JSFunction callback);

  external void handleEvent(PusherEvent event);

  external void handleInternalEvent(PusherEvent event);

  external void handleSubscriptionSucceededEvent(PusherEvent event);

  external void disconnect();
}
