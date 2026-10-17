@JS()
library core.utils.url_store;

import "package:js/js.dart";

/// A place to store help URLs for error messages etc
@JS()
external get urlStore;

/// Builds a consistent string with links to pusher documentation
@JS()
external get buildLogSuffix; /* WARNING: export assignment not yet supported. */
