@JS()
library runtimes.web.browser;

import 'dart:html';

import "package:js/js.dart";
import "../interface.dart" show Runtime;
import "dom/script_receiver_factory.dart" show ScriptReceiverFactory;
import "dom/jsonp_request.dart" show JSONPRequest;
import "dom/script_request.dart" show ScriptRequest;
import "../../core/http/ajax.dart" show Ajax;

@anonymous
@JS()
abstract class Browser implements Runtime {
  /// for jsonp auth
  external num get nextAuthCallbackID;
  external set nextAuthCallbackID(num v);
  external dynamic get auth_callbacks;
  external set auth_callbacks(dynamic v);
  external ScriptReceiverFactory get ScriptReceivers;
  external set ScriptReceivers(ScriptReceiverFactory v);
  external ScriptReceiverFactory get DependenciesReceivers;
  external set DependenciesReceivers(ScriptReceiverFactory v);
  external onDocumentBody(Function callback);
  external Document getDocument();
  external JSONPRequest createJSONPRequest(String url, dynamic data);
  external ScriptRequest createScriptRequest(String src);
  external bool isXDRSupported([bool useTLS]);
  external Ajax createXMLHttpRequest();
  external Ajax createMicrosoftXHR();
}

/* WARNING: export assignment not yet supported. */
