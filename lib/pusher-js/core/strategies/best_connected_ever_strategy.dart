@JS()
library core.strategies.best_connected_ever_strategy;

import "package:js/js.dart";
import "strategy.dart" show Strategy;

/// Launches all substrategies and emits prioritized connected transports.
@JS()
class BestConnectedEverStrategy implements Strategy {
  // @Ignore
  BestConnectedEverStrategy.fakeConstructor$();
  external List<Strategy> get strategies;
  external set strategies(List<Strategy> v);
  external factory BestConnectedEverStrategy(List<Strategy> strategies);
  @override
  external bool isSupported();
  @override
  external connect(num minPriority, Function callback);
}

/// Connects to all strategies in parallel.
/// Callback builder should be a function that takes two arguments: index
/// and a list of runners. It should return another function that will be
/// passed to the substrategy with given index. Runners can be aborted using
/// abortRunner(s) functions from this class.
@JS()
external connect(
    List<Strategy> strategies, num minPriority, Function callbackBuilder);
@JS()
external bool allRunnersFailed(runners);
@JS()
external abortRunner(runner);
