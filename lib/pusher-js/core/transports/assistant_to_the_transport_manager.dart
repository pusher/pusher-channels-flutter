@JS()
library core.transports.assistant_to_the_transport_manager;

import "package:js/js.dart";
import "transport_manager.dart" show TransportManager;
import "transport.dart" show Transport;
import "ping_delay_options.dart" show PingDelayOptions;
import "transport_connection.dart" show TransportConnection;

/// Creates transport connections monitored by a transport manager.
/// When a transport is closed, it might mean the environment does not support
/// it. It's possible that messages get stuck in an intermediate buffer or
/// proxies terminate inactive connections. To combat these problems,
/// assistants monitor the connection lifetime, report unclean exits and
/// adjust ping timeouts to keep the connection active. The decision to disable
/// a transport is the manager's responsibility.
@JS()
class AssistantToTheTransportManager {
  // @Ignore
  AssistantToTheTransportManager.fakeConstructor$();
  external TransportManager get manager;
  external set manager(TransportManager v);
  external Transport get transport;
  external set transport(Transport v);
  external num get minPingDelay;
  external set minPingDelay(num v);
  external num get maxPingDelay;
  external set maxPingDelay(num v);
  external num get pingDelay;
  external set pingDelay(num v);
  external factory AssistantToTheTransportManager(
      TransportManager manager, Transport transport, PingDelayOptions options);

  /// Creates a transport connection.
  /// This function has the same API as Transport#createConnection.
  external TransportConnection createConnection(
      String name, num priority, String key, Object options);

  /// Returns whether the transport is supported in the environment.
  /// This function has the same API as Transport#isSupported. Might return false
  /// when the manager decides to kill the transport.
  external bool isSupported(String environment);
}
