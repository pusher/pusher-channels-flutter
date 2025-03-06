import 'dart:js_interop';

extension type StrategyRunnerForceMinPriorityFunction._(JSFunction _)
    implements JSFunction {
  void call(JSAny? number) => callAsFunction(null, number);
}

extension type StrategyRunnerAbortFunction._(JSFunction _)
    implements JSFunction {
  void call() => callAsFunction(null);
}

extension type StrategyRunner._(JSObject _) implements JSObject {
  external StrategyRunnerForceMinPriorityFunction forceMinPriority;

  external StrategyRunnerAbortFunction abort;
}
