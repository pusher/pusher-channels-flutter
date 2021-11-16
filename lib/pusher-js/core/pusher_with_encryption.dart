// ignore_for_file: non_constant_identifier_names

@JS()
library core.pusher_with_encryption;

import "package:js/js.dart";
import "pusher.dart" show Pusher;
import "options.dart" show Options;

@JS()
class PusherWithEncryption extends Pusher {
  external factory PusherWithEncryption(String app_key, [Options options]);
}
