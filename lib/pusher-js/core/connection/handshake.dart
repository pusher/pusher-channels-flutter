// ignore_for_file: non_constant_identifier_names

@JS()
library core.connection.handshake;

import "package:js/js.dart";
import "../transports/transport_connection.dart" show TransportConnection;

/// Handles Pusher protocol handshakes for transports.
/// Calls back with a result object after handshake is completed. Results
/// always have two fields:
/// - action - string describing action to be taken after the handshake
/// - transport - the transport object passed to the constructor
/// Different actions can set different additional properties on the result.
/// In the case of 'connected' action, there will be a 'connection' property
/// containing a Connection object for the transport. Other actions should
/// carry an 'error' property.
@JS()
class Handshake {
  // @Ignore
  Handshake.fakeConstructor$();
  external TransportConnection get transport;
  external set transport(TransportConnection v);
  external void Function(dynamic) get callback;
  external set callback(void Function(dynamic) v);
  external Function get onMessage;
  external set onMessage(Function v);
  external Function get onClosed;
  external set onClosed(Function v);
  external factory Handshake(
      TransportConnection transport, void callback(HandshakePayload));
  external close();
  external bindListeners();
  external unbindListeners();
  external finish(String action, dynamic params);
}
