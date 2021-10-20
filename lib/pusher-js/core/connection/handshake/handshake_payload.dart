@JS()
library core.connection.handshake.handshake_payload;

import "package:js/js.dart";
import "../protocol/action.dart" show Action;
import "../../transports/transport_connection.dart" show TransportConnection;
import "../connection.dart" show Connection;

@anonymous
@JS()
abstract class HandshakePayload implements Action {
  external TransportConnection get transport;
  external set transport(TransportConnection v);
  external Connection get connection;
  external set connection(Connection v);
  external factory HandshakePayload(
      {TransportConnection transport,
      Connection connection,
      String action,
      String id,
      num activityTimeout,
      dynamic error});
}

/* WARNING: export assignment not yet supported. */
