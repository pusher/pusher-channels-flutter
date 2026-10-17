@JS()
library core.strategies.cached_strategy;

import "package:js/js.dart";
import "strategy.dart" show Strategy;
import "../timeline/timeline.dart" show Timeline;
import "strategy_options.dart" show StrategyOptions;
import "transport_strategy.dart" show TransportStrategy;

@anonymous
@JS()
abstract class TransportStrategyDictionary {
  /* Index signature is not yet supported by JavaScript interop. */
}

/// Caches last successful transport and uses it for following attempts.
@JS()
class CachedStrategy implements Strategy {
  // @Ignore
  CachedStrategy.fakeConstructor$();
  external Strategy get strategy;
  external set strategy(Strategy v);
  external TransportStrategyDictionary get transports;
  external set transports(TransportStrategyDictionary v);
  external num get ttl;
  external set ttl(num v);
  external bool get usingTLS;
  external set usingTLS(bool v);
  external Timeline get timeline;
  external set timeline(Timeline v);
  external factory CachedStrategy(Strategy strategy,
      TransportStrategyDictionary transports, StrategyOptions options);
  @override
  external bool isSupported();
  @override
  external connect(num minPriority, Function callback);
}

@JS()
external String getTransportCacheKey(bool usingTLS);
@JS()
external dynamic fetchTransportCache(bool usingTLS);
@JS()
external storeTransportCache(
    bool usingTLS, TransportStrategy transport, num latency);
@JS()
external flushTransportCache(bool usingTLS);
