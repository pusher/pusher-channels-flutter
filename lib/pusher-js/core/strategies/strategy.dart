import 'dart:js_interop';

import 'strategy_runner.dart' show StrategyRunner;

@JS()
extension type Strategy(JSObject _) implements JSObject {
  external bool isSupported();
  external StrategyRunner connect(num minPriority, JSFunction callback);
}
