@JS()
library core.errors;

import "package:js/js.dart";

/// Error classes used throughout the library.
/// https://github.com/Microsoft/TypeScript-wiki/blob/master/Breaking-Changes.md#extending-built-ins-like-error-array-and-map-may-no-longer-work
@JS()
class BadEventName extends Error {
  external factory BadEventName([String msg]);
}

@JS()
class RequestTimedOut extends Error {
  external factory RequestTimedOut([String msg]);
}

@JS()
class TransportPriorityTooLow extends Error {
  external factory TransportPriorityTooLow([String msg]);
}

@JS()
class TransportClosed extends Error {
  external factory TransportClosed([String msg]);
}

@JS()
class UnsupportedFeature extends Error {
  external factory UnsupportedFeature([String msg]);
}

@JS()
class UnsupportedTransport extends Error {
  external factory UnsupportedTransport([String msg]);
}

@JS()
class UnsupportedStrategy extends Error {
  external factory UnsupportedStrategy([String msg]);
}

@JS()
class HTTPAuthError extends Error {
  external num get status;
  external set status(num v);
  external factory HTTPAuthError(num status, [String msg]);
}
