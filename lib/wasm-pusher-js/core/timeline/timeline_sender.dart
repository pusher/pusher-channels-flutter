import 'dart:js_interop';

import 'timeline.dart';

extension type TimelineSenderOptions._(JSObject _) implements JSObject {
  external TimelineSenderOptions({
    String? host,
    num? port,
    String? path,
  });

  external String? host;

  external num? port;

  external String? path;
}

extension type TimelineSender._(JSObject _) implements JSObject {
  external TimelineSender({
    Timeline timeline,
    TimelineSenderOptions options,
  });

  external Timeline timeline;

  external TimelineSenderOptions options;

  external String host;

  external void send(bool useTls, [JSFunction? callback]);
}
