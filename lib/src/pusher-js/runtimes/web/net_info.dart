// ignore_for_file: non_constant_identifier_names

@JS()
library runtimes.web.net_info;

import "package:js/js.dart";
import "../../core/events/dispatcher.dart" show Dispatcher;
import "../../core/reachability.dart" show Reachability;

/// Really basic interface providing network availability info.
/// Emits:
/// - online - when browser goes online
/// - offline - when browser goes offline
@JS()
class NetInfo extends Dispatcher implements Reachability {
  external factory NetInfo();

  /// Returns whether browser is online or not
  /// Offline means definitely offline (no connection to router).
  /// Inverse does NOT mean definitely online (only currently supported in Safari
  /// and even there only means the device has a connection to the router).
  @override
  external bool isOnline();
}

@JS()
external get Network;
@JS()
external set Network(v);
