@JS()
library runtimes.web.dom.script_request;

import "package:js/js.dart";
import "script_receiver.dart" show ScriptReceiver;

/// Sends a generic HTTP GET request using a script tag.
/// By constructing URL in a specific way, it can be used for loading
/// JavaScript resources or JSONP requests. It can notify about errors, but
/// only in certain environments. Please take care of monitoring the state of
/// the request yourself.
@JS()
class ScriptRequest {
  external String get src;
  external set src(String v);
  external dynamic get script;
  external set script(dynamic v);
  external dynamic get errorScript;
  external set errorScript(dynamic v);
  external factory ScriptRequest(String src);
  external send(ScriptReceiver receiver);

  /// Cleans up the DOM remains of the script request.
  external cleanup();
}
