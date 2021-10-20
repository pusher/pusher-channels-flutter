@JS()
library core.pusher_with_encryption;

import "package:js/js.dart";
import "pusher.dart" show Pusher;
import "options.dart" show Options;

@JS()
class PusherWithEncryption extends Pusher {
  // @Ignore
  //PusherWithEncryption.fakeConstructor$() : super.fakeConstructor$();
  external factory PusherWithEncryption(String app_key, [Options options]);
}
