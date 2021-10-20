@JS()
library core.channels.metadata;

import "package:js/js.dart";

@anonymous
@JS()
abstract class Metadata {
  external String get user_id;
  external set user_id(String v);
  external factory Metadata({String user_id});
}

/* WARNING: export assignment not yet supported. */
