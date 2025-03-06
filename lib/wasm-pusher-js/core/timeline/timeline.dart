import 'dart:js_interop';

extension type TimelineOptions._(JSObject _) implements JSObject {
  external TimelineOptions({
    num? level,
    num? limit,
    String? version,
    String? cluster,
    JSArray<JSString>? features,
    JSAny? params,
  });

  external num? level;

  external num? limit;

  external String? version;

  external String? cluster;

  external JSArray<JSString>? features;

  external JSAny? params;
}

extension type Timeline._(JSObject _) implements JSObject {
  external Timeline(
    String key,
    num session,
    TimelineOptions options,
  );

  external String key;

  external num session;

  external JSArray<JSAny?> events;

  external TimelineOptions options;

  external num sent;

  @JS('uniqueID')
  external num uniqueId;

  external void log(JSAny? level, JSAny? event);

  external void error(JSAny? event);

  external void info(JSAny? event);

  external void debug(JSAny? event);

  external bool isEmpty();

  external bool send(JSAny? sendfn, JSAny? callback);

  @JS('generateUniqueID')
  external num generationUniqueId();
}
