@JS()
library runtimes.web.default_strategy;

import "package:js/js.dart";
import "../../core/strategies/strategy.dart" show Strategy;

@JS()
external testSupportsStrategy(Strategy strategy);
@JS()
external get getDefaultStrategy;
@JS()
external set getDefaultStrategy(
    v); /* WARNING: export assignment not yet supported. */
