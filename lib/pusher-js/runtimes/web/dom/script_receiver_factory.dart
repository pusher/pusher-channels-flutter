// ignore_for_file: non_constant_identifier_names

@JS()
library runtimes.web.dom.script_receiver_factory;

import "package:js/js.dart";
import "script_receiver.dart" show ScriptReceiver;

/// Builds receivers for JSONP and Script requests.
/// Each receiver is an object with following fields:
/// - number - unique (for the factory instance), numerical id of the receiver
/// - id - a string ID that can be used in DOM attributes
/// - name - name of the function triggering the receiver
/// - callback - callback function
/// Receivers are triggered only once, on the first callback call.
/// Receivers can be called by their name or by accessing factory object
/// by the number key.
@JS()
class ScriptReceiverFactory {
  external num get lastId;
  external set lastId(num v);
  external String get prefix;
  external set prefix(String v);
  external String get name;
  external set name(String v);
  external factory ScriptReceiverFactory(String prefix, String name);
  external ScriptReceiver create(Function callback);
  external remove(ScriptReceiver receiver);
}

@JS()
external get ScriptReceivers;
@JS()
external set ScriptReceivers(v);
