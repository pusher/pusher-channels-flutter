// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

import '../events/callback_registry.dart' show CallbackRegistry;
import '../events/dispatcher.dart' show Dispatcher;
import 'transport_hooks.dart' show TransportHooks;
import 'transport_connection_options.dart' show TransportConnectionOptions;
import '../timeline/timeline.dart' show Timeline;
import '../socket.dart' show Socket;
import '../channels/metadata.dart' show Metadata;

/// Provides universal API for transport connections.
/// Transport connection is a low-level object that wraps a connection method
/// and exposes a simple evented interface for the connection state and
/// messaging. It does not implement Pusher-specific WebSocket protocol.
/// Additionally, it fetches resources needed for transport to work and exposes
/// an interface for querying transport features.
/// States:
/// - new - initial state after constructing the object
/// - initializing - during initialization phase, usually fetching resources
/// - intialized - ready to establish a connection
/// - connection - when connection is being established
/// - open - when connection ready to be used
/// - closed - after connection was closed be either side
/// Emits:
/// - error - after the connection raised an error
/// Options:
/// - useTLS - whether connection should be over TLS
/// - hostTLS - host to connect to when connection is over TLS
/// - hostNonTLS - host to connect to when connection is over TLS
@JS()
extension type TransportConnection._(JSObject _) implements JSObject {
  external factory TransportConnection(TransportHooks hooks, String name,
      num priority, String key, TransportConnectionOptions options);

  external TransportHooks get hooks;
  external set hooks(TransportHooks v);
  external String get name;
  external set name(String v);
  external num get priority;
  external set priority(num v);
  external String get key;
  external set key(String v);
  external TransportConnectionOptions get options;
  external set options(TransportConnectionOptions v);
  external String get state;
  external set state(String v);
  external Timeline get timeline;
  external set timeline(Timeline v);
  external num get activityTimeout;
  external set activityTimeout(num v);
  external num get id;
  external set id(num v);
  external Socket get socket;
  external set socket(Socket v);
  external JSFunction get beforeOpen;
  external set beforeOpen(JSFunction v);
  external JSFunction get initialize;
  external set initialize(JSFunction v);

  /// Checks whether the transport handles activity checks by itself.
  external bool handlesActivityChecks();

  /// Checks whether the transport supports the ping/pong API.
  external bool supportsPing();

  /// Tries to establish a connection.
  external bool connect();

  /// Closes the connection.
  external bool close();

  /// Sends data over the open connection.
  external bool send(JSAny? data);

  /// Sends a ping if the connection is open and transport supports it.
  external void ping();
  external void onOpen();
  external void onError(JSAny? error);
  external void onClose([JSAny? closeEvent]);
  external void onMessage(JSAny? message);
  external void onActivity();
  external void bindListeners();
  external void unbindListeners();
  external void changeState(String state, [JSAny? params]);
  external JSAny? buildTimelineMessage(JSAny? message);

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
