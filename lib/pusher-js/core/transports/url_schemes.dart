@JS()
library core.transports.url_schemes;

import "package:js/js.dart";
import "url_scheme.dart" show URLSchemeParams, URLScheme;

@JS()
external String getGenericURL(
    String baseScheme, URLSchemeParams params, String path);
@JS()
external String getGenericPath(String key, [String queryString]);
@JS()
external URLScheme get ws;
@JS()
external set ws(URLScheme v);
@JS()
external URLScheme get http;
@JS()
external set http(URLScheme v);
@JS()
external URLScheme get sockjs;
@JS()
external set sockjs(URLScheme v);
