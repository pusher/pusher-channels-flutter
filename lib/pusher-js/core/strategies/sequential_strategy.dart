@JS()
library core.strategies.sequential_strategy;

import "package:js/js.dart";
import "strategy.dart" show Strategy;
import "strategy_options.dart" show StrategyOptions;

/// Loops through strategies with optional timeouts.
/// Options:
/// - loop - whether it should loop through the substrategy list
/// - timeout - initial timeout for a single substrategy
/// - timeoutLimit - maximum timeout
@JS()
class SequentialStrategy implements Strategy {
  // @Ignore
  SequentialStrategy.fakeConstructor$();
  external List<Strategy> get strategies;
  external set strategies(List<Strategy> v);
  external bool get loop;
  external set loop(bool v);
  external bool get failFast;
  external set failFast(bool v);
  external num get timeout;
  external set timeout(num v);
  external num get timeoutLimit;
  external set timeoutLimit(num v);
  external factory SequentialStrategy(
      List<Strategy> strategies, StrategyOptions options);
  @override
  external bool isSupported();
  @override
  external connect(num minPriority, Function callback);
  external tryStrategy(Strategy strategy, num minPriority,
      StrategyOptions options, Function callback);
}
