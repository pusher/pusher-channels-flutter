@JS()
library core.strategies.strategy_runner;

import "package:js/js.dart";

@anonymous
@JS()
abstract class StrategyRunner {
  external void Function(dynamic) get forceMinPriority;
  external set forceMinPriority(void Function(dynamic) v);
  external void Function() get abort;
  external set abort(void Function() v);
  external factory StrategyRunner(
      {void Function(dynamic) forceMinPriority, void Function() abort});
}

/* WARNING: export assignment not yet supported. */
