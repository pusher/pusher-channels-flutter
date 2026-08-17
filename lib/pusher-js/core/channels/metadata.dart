// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

@JS()
extension type Metadata._(JSObject _) implements JSObject {
  external factory Metadata({String user_id});

  external String get user_id;
  external set user_id(String v);
}
