import 'dart:js_interop';

import '../auth/options.dart';
import '../connection/protocol/message_types.dart';
import '../events/dispatcher.dart';
import '../pusher.dart';

extension type Channel._(Dispatcher _) implements Dispatcher {
  external Channel(String name, Pusher pusher);

  external String name;

  external Pusher pusher;

  external bool subscribed;

  external bool subscriptionPending;

  external bool subscriptionCancelled;

  external void authorize(
    String socketId,
    ChannelAuthorizationCallback callback,
  );

  external bool trigger(String event, [JSAny data]);

  external void disconnect();

  external void handleEvent(PusherEvent event);

  external void handleSubscriptionSucceededEvent(PusherEvent event);

  external void handleSubscriptionCountEvent(PusherEvent event);

  external void subscribe();

  external void unsubscribe();

  external void cancelSubscription();

  external void reinstateSubscription();
}
