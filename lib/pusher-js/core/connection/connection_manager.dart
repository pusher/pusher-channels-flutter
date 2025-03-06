import 'dart:js_interop';

import '../events/dispatcher.dart';
import '../strategies/strategy.dart';
import '../strategies/strategy_runner.dart';
import '../timeline/timeline.dart';
import 'connection.dart';
import 'connection_manager_options.dart';

extension type ConnectionManager._(Dispatcher _) implements Dispatcher {
  external ConnectionManager({
    String key,
    ConnectionManagerOptions options,
  });

  external String key;

  external ConnectionManagerOptions options;

  external String state;

  external Connection connection;

  @JS('usingTLS')
  external bool usingTls;

  external Timeline timeline;

  @JS('socket_id')
  external String socketId;

  // external Timer unavailableTimer;

  // external Timer activityTimer;

  // external Timer retryTimer;

  external num activityTimeout;

  external Strategy strategy;

  external StrategyRunner runner;

  // external ErrorCallbacks errorCallbacks;

  // external HandshakeCallbacks handshakeCallbacks;

  // external ConnectionCallbacks connectionCallbacks;

  external void connect();

  external bool send(JSAny? data);

  @JS('send_event')
  external bool sendEvent(
    String name,
    JSAny? data, [
    String? channel,
  ]);

  external void disconnect();

  @JS('isUsingTLS')
  external bool isUsingTls();
}
