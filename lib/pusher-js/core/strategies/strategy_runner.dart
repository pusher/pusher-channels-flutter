import 'dart:js_interop';

@JS()
extension type StrategyRunner._(JSObject _) implements JSObject {
  external factory StrategyRunner(
      {JSFunction forceMinPriority, JSFunction abort});

  external JSFunction get forceMinPriority;
  external set forceMinPriority(JSFunction v);
  external JSFunction get abort;
  external set abort(JSFunction v);
}
