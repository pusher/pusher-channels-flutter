@JS()
library core.channels.encrypted_channel;

import "package:js/js.dart";
import "dart:typed_data";
import "private_channel.dart" show PrivateChannel;
import "../pusher.dart" show Pusher;
import "../auth/options.dart" show AuthorizerCallback;
import "../connection/protocol/message-types.dart" show PusherEvent;

/// Extends private channels to provide encrypted channel interface.
@JS()
class EncryptedChannel extends PrivateChannel {
  external Uint8List get key;
  external set key(Uint8List v);
  external dynamic get nacl;
  external set nacl(dynamic v);
  external factory EncryptedChannel(String name, Pusher pusher, dynamic nacl);

  /// Authorizes the connection to use the channel.
  @override
  external authorize(String socketId, AuthorizerCallback callback);
  @override
  external bool trigger(String event, dynamic data);

  /// Handles an event. For internal use only.
  @override
  external handleEvent(PusherEvent event);
  external void handleEncryptedEvent(String event, dynamic data);

  /// Try and parse the decrypted bytes as JSON. If we can't parse it, just
  /// return the utf-8 string
  external String getDataToEmit(Uint8List bytes);
}
