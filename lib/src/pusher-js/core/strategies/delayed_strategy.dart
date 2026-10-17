@JS()
library core.strategies.delayed_strategy;

import "package:js/js.dart";
import "strategy.dart" show Strategy;

/// Runs substrategy after specified delay.
/// Options:
/// - delay - time in miliseconds to delay the substrategy attempt
@JS()
class DelayedStrategy implements Strategy {
  // @Ignore
  DelayedStrategy.fakeConstructor$();
  external Strategy get strategy;
  external set strategy(Strategy v);
  external dynamic /*{ delay: number }*/ get options;
  external set options(dynamic /*{ delay: number }*/ v);
  external factory DelayedStrategy(
      Strategy strategy, Object number /*{ delay: number }*/);
  @override
  external bool isSupported();
  @override
  external connect(num minPriority, Function callback);
}
