@JS()
library core.strategies.strategy_options;

import "package:js/js.dart";
import "../timeline/timeline.dart" show Timeline;

@anonymous
@JS()
abstract class StrategyOptions {
  external bool get failFast;
  external set failFast(bool v);
  external String get hostNonTLS;
  external set hostNonTLS(String v);
  external String get hostTLS;
  external set hostTLS(String v);
  external String get httpPath;
  external set httpPath(String v);
  external bool get ignoreNullOrigin;
  external set ignoreNullOrigin(bool v);
  external String get key;
  external set key(String v);
  external bool get loop;
  external set loop(bool v);
  external Timeline get timeline;
  external set timeline(Timeline v);
  external num get timeout;
  external set timeout(num v);
  external num get timeoutLimit;
  external set timeoutLimit(num v);
  external num get ttl;
  external set ttl(num v);
  external bool get useTLS;
  external set useTLS(bool v);
  external factory StrategyOptions(
      {bool failFast,
      String hostNonTLS,
      String hostTLS,
      String httpPath,
      bool ignoreNullOrigin,
      String key,
      bool loop,
      Timeline timeline,
      num timeout,
      num timeoutLimit,
      num ttl,
      bool useTLS});
}

/* WARNING: export assignment not yet supported. */
