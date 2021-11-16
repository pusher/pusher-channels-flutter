// ignore_for_file: non_constant_identifier_names

@JS()
library runtimes.react_native.net_info;

import "package:js/js.dart";
import "../../core/events/dispatcher.dart" show Dispatcher;
import "../../core/reachability.dart" show Reachability;

@JS()
external bool hasOnlineConnectionState(connectionState);

@JS()
class NetInfo extends Dispatcher implements Reachability {
  external bool get online;
  external set online(bool v);
  external factory NetInfo();
  @override
  external bool isOnline();
}

@JS()
external get Network;
@JS()
external set Network(v);
