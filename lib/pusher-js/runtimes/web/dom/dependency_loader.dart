@JS()
library runtimes.web.dom.dependency_loader;

import "package:js/js.dart";
import "script_receiver_factory.dart" show ScriptReceiverFactory;

/// Handles loading dependency files.
/// Dependency loaders don't remember whether a resource has been loaded or
/// not. It is caller's responsibility to make sure the resource is not loaded
/// twice. This is because it's impossible to detect resource loading status
/// without knowing its content.
/// Options:
/// - cdn_http - url to HTTP CND
/// - cdn_https - url to HTTPS CDN
/// - version - version of pusher-js
/// - suffix - suffix appended to all names of dependency files
@JS()
class DependencyLoader {
  external dynamic get options;
  external set options(dynamic v);
  external ScriptReceiverFactory get receivers;
  external set receivers(ScriptReceiverFactory v);
  external dynamic get loading;
  external set loading(dynamic v);
  external factory DependencyLoader(dynamic options);

  /// Loads the dependency from CDN.
  external load(String name, dynamic options, Function callback);

  /// Returns a root URL for pusher-js CDN.
  external String getRoot(dynamic options);

  /// Returns a full path to a dependency file.
  external String getPath(String name, dynamic options);
}
