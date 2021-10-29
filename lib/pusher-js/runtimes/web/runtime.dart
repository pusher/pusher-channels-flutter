@JS()
library runtimes.web.runtime;

import "package:js/js.dart";
import "browser.dart" show Browser;

@JS()
external Browser get Runtime;
@JS()
external set Runtime(
    Browser v); /* WARNING: export assignment not yet supported. */
