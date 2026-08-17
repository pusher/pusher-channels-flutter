// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

import '../events/callback_registry.dart' show CallbackRegistry;
import '../events/dispatcher.dart' show Dispatcher;
import '../channels/metadata.dart' show Metadata;
import '../transports/transport_connection.dart' show TransportConnection;

/// Provides Pusher protocol interface for transports.
/// Emits following events:
/// - message - on received messages
/// - ping - on ping requests
/// - pong - on pong responses
/// - error - when the transport emits an error
/// - closed - after closing the transport
/// It also emits more events when connection closes with a code.
/// See Protocol.getCloseAction to get more details.
@JS()
extension type Connection._(JSObject _) implements JSObject {
  external factory Connection(String id, TransportConnection transport);

  external String get id;
  external set id(String v);
  external TransportConnection get transport;
  external set transport(TransportConnection v);
  external num get activityTimeout;
  external set activityTimeout(num v);

  /// Returns whether used transport handles activity checks by itself
  external void handlesActivityChecks();

  /// Sends raw data.
  external bool send(JSAny? data);

  /// Sends an event.
  external bool send_event(String name, JSAny? data, [String? channel]);

  /// Sends a ping message to the server.
  /// Basing on the underlying transport, it might send either transport's
  /// protocol-specific ping or pusher:ping event.
  external void ping();

  /// Closes the connection.
  external void close([JSAny? code, JSAny? reason]);
  external void bindListeners();
  external void handleCloseEvent(JSAny? closeEvent);

  external bool sendRaw(JSAny? payload);
  external JSFunction? onopen;
  external JSFunction? onerror;
  external JSFunction? onclose;
  external JSFunction? onmessage;
  external JSFunction? onactivity;

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
