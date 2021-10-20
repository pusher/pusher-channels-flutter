@JS()
library core.connection.connection_manager_options;

import "package:js/js.dart";
import "../timeline/timeline.dart" show Timeline;
import "../strategies/strategy.dart" show Strategy;

@anonymous
@JS()
abstract class ConnectionManagerOptions {
  external Timeline get timeline;
  external set timeline(Timeline v);
  external Strategy Function(dynamic) get getStrategy;
  external set getStrategy(Strategy Function(dynamic) v);
  external num get unavailableTimeout;
  external set unavailableTimeout(num v);
  external num get pongTimeout;
  external set pongTimeout(num v);
  external num get activityTimeout;
  external set activityTimeout(num v);
  external bool get useTLS;
  external set useTLS(bool v);
  external factory ConnectionManagerOptions(
      {Timeline timeline,
      Strategy Function(dynamic) getStrategy,
      num unavailableTimeout,
      num pongTimeout,
      num activityTimeout,
      bool useTLS});
}

/* WARNING: export assignment not yet supported. */
