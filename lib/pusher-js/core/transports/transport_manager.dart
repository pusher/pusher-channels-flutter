@JS()
library core.transports.transport_manager;

import "package:js/js.dart";
import "ping_delay_options.dart" show PingDelayOptions;
import "assistant_to_the_transport_manager.dart"
    show AssistantToTheTransportManager;
import "transport.dart" show Transport;

@anonymous
@JS()
abstract class TransportManagerOptions implements PingDelayOptions {
  external num get lives;
  external set lives(num v);
  external factory TransportManagerOptions(
      {num lives, num minPingDelay, num maxPingDelay, num pingDelay});
}

/// Keeps track of the number of lives left for a transport.
/// In the beginning of a session, transports may be assigned a number of
/// lives. When an AssistantToTheTransportManager instance reports a transport
/// connection closed uncleanly, the transport loses a life. When the number
/// of lives drops to zero, the transport gets disabled by its manager.
@JS()
class TransportManager {
  // @Ignore
  TransportManager.fakeConstructor$();
  external TransportManagerOptions get options;
  external set options(TransportManagerOptions v);
  external num get livesLeft;
  external set livesLeft(num v);
  external factory TransportManager(TransportManagerOptions options);

  /// Creates a assistant for the transport.
  external AssistantToTheTransportManager getAssistant(Transport transport);

  /// Returns whether the transport has any lives left.
  external bool isAlive();

  /// Takes one life from the transport.
  external reportDeath();
}
