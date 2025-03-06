import 'dart:js_interop';

import 'strategy_runner.dart';

extension type Strategy._(JSObject _) implements JSObject {
  external bool isSupported();

  external StrategyRunner connect(num minPriority, JSFunction callback);
}
