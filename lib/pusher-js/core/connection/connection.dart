@JS()
library core.connection.connection;

import "package:js/js.dart";
import "../events/dispatcher.dart" show Dispatcher;
import "../socket.dart" show Socket;
import "../transports/transport_connection.dart" show TransportConnection;

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
class Connection extends Dispatcher implements Socket {
  external String get id;
  external set id(String v);
  external TransportConnection get transport;
  external set transport(TransportConnection v);
  external num get activityTimeout;
  external set activityTimeout(num v);
  external factory Connection(String id, TransportConnection transport);

  /// Returns whether used transport handles activity checks by itself
  external handlesActivityChecks();

  /// Sends raw data.
  external bool send(dynamic data);

  /// Sends an event.
  external bool send_event(String name, dynamic data, [String channel]);

  /// Sends a ping message to the server.
  /// Basing on the underlying transport, it might send either transport's
  /// protocol-specific ping or pusher:ping event.
  external ping();

  /// Closes the connection.
  external close([dynamic code, dynamic reason]);
  external bindListeners();
  external handleCloseEvent(dynamic closeEvent);


  external bool sendRaw(dynamic payload);
  external void onopen([dynamic evt]);
  external void onerror(dynamic error);
  external void onclose(dynamic closeEvent);
  external void onmessage(dynamic message);
  external void onactivity();
}
