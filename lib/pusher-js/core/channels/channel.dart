@JS()
library core.channels.channel;

import "package:js/js.dart";
import "../events/dispatcher.dart" show Dispatcher;
import "../pusher.dart" show Pusher;
import "../auth/options.dart" show AuthorizerCallback;
import "../connection/protocol/message-types.dart" show PusherEvent;

/// Provides base public channel interface with an event emitter.
/// Emits:
/// - pusher:subscription_succeeded - after subscribing successfully
/// - other non-internal events
@JS()
class Channel extends Dispatcher {
  external String get name;
  external set name(String v);
  external Pusher get pusher;
  external set pusher(Pusher v);
  external bool get subscribed;
  external set subscribed(bool v);
  external bool get subscriptionPending;
  external set subscriptionPending(bool v);
  external bool get subscriptionCancelled;
  external set subscriptionCancelled(bool v);
  external factory Channel(String name, Pusher pusher);

  /// Skips authorization, since public channels don't require it.
  external authorize(String socketId, AuthorizerCallback callback);

  /// Triggers an event
  external trigger(String event, dynamic data);

  /// Signals disconnection to the channel. For internal use only.
  external disconnect();

  /// Handles a PusherEvent. For internal use only.
  external handleEvent(PusherEvent event);
  external handleSubscriptionSucceededEvent(PusherEvent event);

  /// Sends a subscription request. For internal use only.
  external subscribe();

  /// Sends an unsubscription request. For internal use only.
  external unsubscribe();

  /// Cancels an in progress subscription. For internal use only.
  external cancelSubscription();

  /// Reinstates an in progress subscripiton. For internal use only.
  external reinstateSubscription();
}
