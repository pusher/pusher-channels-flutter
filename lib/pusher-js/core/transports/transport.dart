@JS()
library core.transports.transport;

import "package:js/js.dart";
import "transport_hooks.dart" show TransportHooks;
import "transport_connection.dart" show TransportConnection;

/// Provides interface for transport connection instantiation.
/// Takes transport-specific hooks as the only argument, which allow checking
/// for transport support and creating its connections.
/// Supported hooks: * - file - the name of the file to be fetched during initialization
/// - urls - URL scheme to be used by transport
/// - handlesActivityCheck - true when the transport handles activity checks
/// - supportsPing - true when the transport has a ping/activity API
/// - isSupported - tells whether the transport is supported in the environment
/// - getSocket - creates a WebSocket-compatible transport socket
/// See transports.js for specific implementations.
@JS()
class Transport {
  external TransportHooks get hooks;
  external set hooks(TransportHooks v);
  external factory Transport(TransportHooks hooks);

  /// Returns whether the transport is supported in the environment.
  external bool isSupported(dynamic environment);

  /// Creates a transport connection.
  external TransportConnection createConnection(
      String name, num priority, String key, dynamic options);
}
