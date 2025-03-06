import 'dart:js_interop';

import 'callback.dart';

extension type CallbackTable._(JSObject _) implements JSObject {
  external Callback? operator [](String index);

  external void operator []=(String index, Callback value);
}
