import 'dart:js_interop';

import '../events/dispatcher.dart';

extension type Connection._(Dispatcher _) implements Dispatcher {
  external Connection(
    String id,
    // TransportConnection transport,
  );

  external String id;

  // external TransportConnection transport;

  external num activityTimeout;

  external bool handlesActivityChecks();

  external bool send(JSAny? data);

  @JS('send_event')
  external bool sendEvent(
    String name,
    JSAny? data, [
    String? channel,
  ]);

  external void ping();

  external void close();
}
