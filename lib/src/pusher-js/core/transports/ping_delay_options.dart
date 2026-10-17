@JS()
library core.transports.ping_delay_options;

import "package:js/js.dart";

@anonymous
@JS()
abstract class PingDelayOptions {
  external num get minPingDelay;
  external set minPingDelay(num v);
  external num get maxPingDelay;
  external set maxPingDelay(num v);
  external num get pingDelay;
  external set pingDelay(num v);
  external factory PingDelayOptions(
      {num minPingDelay, num maxPingDelay, num pingDelay});
}

/* WARNING: export assignment not yet supported. */
