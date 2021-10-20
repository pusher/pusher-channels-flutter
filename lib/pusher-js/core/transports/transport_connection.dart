@JS()
library core.transports.transport_connection;

import "package:js/js.dart";
import "../events/dispatcher.dart" show Dispatcher;
import "transport_hooks.dart" show TransportHooks;
import "transport_connection_options.dart" show TransportConnectionOptions;
import "../timeline/timeline.dart" show Timeline;
import "../socket.dart" show Socket;

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
class TransportConnection extends Dispatcher {
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
  external Function get beforeOpen;
  external set beforeOpen(Function v);
  external Function get initialize;
  external set initialize(Function v);
  external factory TransportConnection(TransportHooks hooks, String name,
      num priority, String key, TransportConnectionOptions options);

  /// Checks whether the transport handles activity checks by itself.
  external bool handlesActivityChecks();

  /// Checks whether the transport supports the ping/pong API.
  external bool supportsPing();

  /// Tries to establish a connection.
  external bool connect();

  /// Closes the connection.
  external bool close();

  /// Sends data over the open connection.
  external bool send(dynamic data);

  /// Sends a ping if the connection is open and transport supports it.
  external ping();
  external onOpen();
  external onError(error);
  external onClose([dynamic closeEvent]);
  external onMessage(message);
  external onActivity();
  external bindListeners();
  external unbindListeners();
  external changeState(String state, [dynamic params]);
  external dynamic buildTimelineMessage(message);
}
