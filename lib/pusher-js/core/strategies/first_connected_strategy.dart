@JS()
library core.strategies.first_connected_strategy;

import "package:js/js.dart";
import "strategy.dart" show Strategy;
import "strategy_runner.dart" show StrategyRunner;

/// Launches the substrategy and terminates on the first open connection.
@JS()
class FirstConnectedStrategy implements Strategy {
  // @Ignore
  FirstConnectedStrategy.fakeConstructor$();
  external Strategy get strategy;
  external set strategy(Strategy v);
  external factory FirstConnectedStrategy(Strategy strategy);
  @override
  external bool isSupported();
  @override
  external StrategyRunner connect(num minPriority, Function callback);
}
