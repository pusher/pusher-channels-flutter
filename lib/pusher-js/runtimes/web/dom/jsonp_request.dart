@JS()
library runtimes.web.dom.jsonp_request;

import "package:js/js.dart";
import "script_request.dart" show ScriptRequest;
import "script_receiver.dart" show ScriptReceiver;

/// Sends data via JSONP.
/// Data is a key-value map. Its values are JSON-encoded and then passed
/// through base64. Finally, keys and encoded values are appended to the query
/// string.
/// The class itself does not guarantee raising errors on failures, as it's not
/// possible to support such feature on all browsers. Instead, JSONP endpoint
/// should call back in a way that's easy to distinguish from browser calls,
/// for example by passing a second argument to the receiver.
@JS()
class JSONPRequest {
  external String get url;
  external set url(String v);
  external dynamic get data;
  external set data(dynamic v);
  external ScriptRequest get request;
  external set request(ScriptRequest v);
  external factory JSONPRequest(String url, dynamic data);

  /// Sends the actual JSONP request.
  external send(ScriptReceiver receiver);

  /// Cleans up the DOM remains of the JSONP request.
  external cleanup();
}
