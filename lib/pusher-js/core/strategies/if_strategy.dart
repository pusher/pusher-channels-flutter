@JS()
library core.strategies.if_strategy;

import "package:js/js.dart";
import "strategy.dart" show Strategy;
import "strategy_runner.dart" show StrategyRunner;

/// Proxies method calls to one of substrategies basing on the test function.
@JS()
class IfStrategy implements Strategy {
  // @Ignore
  IfStrategy.fakeConstructor$();
  external bool Function() get test;
  external set test(bool Function() v);
  external Strategy get trueBranch;
  external set trueBranch(Strategy v);
  external Strategy get falseBranch;
  external set falseBranch(Strategy v);
  external factory IfStrategy(
      bool Function() test, Strategy trueBranch, Strategy falseBranch);
  @override
  external bool isSupported();
  @override
  external StrategyRunner connect(num minPriority, Function callback);
}
