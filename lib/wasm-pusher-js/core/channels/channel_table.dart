import 'dart:js_interop';

import 'channel.dart';

extension type ChannelTable._(JSObject _) implements JSObject {
  external Channel? operator [](String index);

  external void operator []=(String index, Channel value);
}
