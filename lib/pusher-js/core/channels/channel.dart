// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

import '../events/callback_registry.dart' show CallbackRegistry;
import '../events/dispatcher.dart' show Dispatcher;
import '../pusher.dart' show Pusher;
import '../auth/options.dart' show AuthorizerCallback;
import '../connection/protocol/message-types.dart' show PusherEvent;
import 'metadata.dart' show Metadata;

/// Provides base public channel interface with an event emitter.
/// Emits:
/// - pusher:subscription_succeeded - after subscribing successfully
/// - other non-internal events
@JS()
extension type Channel._(JSObject _) implements JSObject {
  external factory Channel(String name, Pusher pusher);

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

  /// Skips authorization, since public channels don't require it.
  external void authorize(String socketId, AuthorizerCallback callback);

  /// Triggers an event
  external void trigger(String event, JSAny? data);

  /// Signals disconnection to the channel. For internal use only.
  external void disconnect();

  /// Handles a PusherEvent. For internal use only.
  external void handleEvent(PusherEvent event);
  external void handleSubscriptionSucceededEvent(PusherEvent event);

  /// Sends a subscription request. For internal use only.
  external void subscribe();

  /// Sends an unsubscription request. For internal use only.
  external void unsubscribe();

  /// Cancels an in progress subscription. For internal use only.
  external void cancelSubscription();

  /// Reinstates an in progress subscripiton. For internal use only.
  external void reinstateSubscription();

  // Flattened from Dispatcher (extension types can't inherit via `extends`).
  external CallbackRegistry get callbacks;
  external set callbacks(CallbackRegistry v);
  external JSArray<JSFunction> get global_callbacks;
  external set global_callbacks(JSArray<JSFunction> v);
  external JSFunction get failThrough;
  external set failThrough(JSFunction v);
  external Dispatcher bind(String eventName, JSFunction callback,
      [JSAny? context]);
  external Dispatcher bind_global(JSFunction callback);
  external Dispatcher unbind(
      [String? eventName, JSFunction? callback, JSAny? context]);
  external Dispatcher unbind_global([JSFunction? callback]);
  external Dispatcher unbind_all();
  external Dispatcher emit(String eventName,
      [JSAny? data, Metadata? metadata]);
}
