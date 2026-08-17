// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

import '../channels/metadata.dart' show Metadata;
import '../events/callback_registry.dart' show CallbackRegistry;
import '../events/dispatcher.dart' show Dispatcher;
import 'connection_manager_options.dart' show ConnectionManagerOptions;
import 'connection.dart' show Connection;
import '../timeline/timeline.dart' show Timeline;
import '../strategies/strategy.dart' show Strategy;
import '../strategies/strategy_runner.dart' show StrategyRunner;
import '../utils/timers/abstract_timer.dart' show Timer;
import 'callbacks.dart'
    show ErrorCallbacks, HandshakeCallbacks, ConnectionCallbacks;

/// Manages connection to Pusher.
/// Uses a strategy (currently only default), timers and network availability
/// info to establish a connection and export its state. In case of failures,
/// manages reconnection attempts.
/// Exports state changes as following events:
/// - "state_change", { previous: p, current: state }
/// - state
/// States:
/// - initialized - initial state, never transitioned to
/// - connecting - connection is being established
/// - connected - connection has been fully established
/// - disconnected - on requested disconnection
/// - unavailable - after connection timeout or when there's no network
/// - failed - when the connection strategy is not supported
/// Options:
/// - unavailableTimeout - time to transition to unavailable state
/// - activityTimeout - time after which ping message should be sent
/// - pongTimeout - time for Pusher to respond with pong before reconnecting
@JS()
extension type ConnectionManager._(JSObject _) implements JSObject {
  external factory ConnectionManager(
      String key, ConnectionManagerOptions options);

  external String get key;
  external set key(String v);
  external ConnectionManagerOptions get options;
  external set options(ConnectionManagerOptions v);
  external String get state;
  external set state(String v);
  external Connection get connection;
  external set connection(Connection v);
  external bool get usingTLS;
  external set usingTLS(bool v);
  external Timeline get timeline;
  external set timeline(Timeline v);
  external String get socket_id;
  external set socket_id(String v);
  external Timer get unavailableTimer;
  external set unavailableTimer(Timer v);
  external Timer get activityTimer;
  external set activityTimer(Timer v);
  external Timer get retryTimer;
  external set retryTimer(Timer v);
  external num get activityTimeout;
  external set activityTimeout(num v);
  external Strategy get strategy;
  external set strategy(Strategy v);
  external StrategyRunner get runner;
  external set runner(StrategyRunner v);
  external ErrorCallbacks get errorCallbacks;
  external set errorCallbacks(ErrorCallbacks v);
  external HandshakeCallbacks get handshakeCallbacks;
  external set handshakeCallbacks(HandshakeCallbacks v);
  external ConnectionCallbacks get connectionCallbacks;
  external set connectionCallbacks(ConnectionCallbacks v);

  /// Establishes a connection to Pusher.
  /// Does nothing when connection is already established. See top-level doc
  /// to find events emitted on connection attempts.
  external void connect();

  /// Sends raw data.
  external void send(JSAny? data);

  /// Sends an event.
  external void send_event(String name, JSAny? data, [String? channel]);

  /// Closes the connection.
  external void disconnect();
  external void isUsingTLS();
  external void startConnecting();
  external void abortConnecting();
  external void disconnectInternally();
  external void updateStrategy();
  external void retryIn(num delay);
  external void clearRetryTimer();
  external void setUnavailableTimer();
  external void clearUnavailableTimer();
  external void sendActivityCheck();
  external void resetActivityCheck();
  external void stopActivityCheck();
  external ConnectionCallbacks buildConnectionCallbacks(
      ErrorCallbacks errorCallbacks);
  external HandshakeCallbacks buildHandshakeCallbacks(
      ErrorCallbacks errorCallbacks);
  external ErrorCallbacks buildErrorCallbacks();
  external void setConnection(Connection? connection);
  external void abandonConnection();
  external void updateState(String newState, [JSAny? data]);
  external bool shouldRetry();

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
