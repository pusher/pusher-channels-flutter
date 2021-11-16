@JS()
library core.strategies.transport_strategy;

import "package:js/js.dart";
import "strategy.dart" show Strategy;
import "../transports/transport.dart" show Transport;
import "strategy_options.dart" show StrategyOptions;

/// Provides a strategy interface for transports.
@JS()
class TransportStrategy implements Strategy {
  // @Ignore
  TransportStrategy.fakeConstructor$();
  external String get name;
  external set name(String v);
  external num get priority;
  external set priority(num v);
  external Transport get transport;
  external set transport(Transport v);
  external StrategyOptions get options;
  external set options(StrategyOptions v);
  external factory TransportStrategy(
      String name, num priority, Transport transport, StrategyOptions options);

  /// Returns whether the transport is supported in the browser.
  @override
  external bool isSupported();

  /// Launches a connection attempt and returns a strategy runner.
  @override
  external connect(num minPriority, Function callback);
}

@JS()
external failAttempt(Error error, Function callback);
