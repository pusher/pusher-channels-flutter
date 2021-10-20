@JS()
library core.http.ajax;

import "package:js/js.dart";

@anonymous
@JS()
abstract class Ajax {
  external void open(String method, String url,
      [bool async, String user, String password]);
  external void send([dynamic payload]);
  external void setRequestHeader(String key, String value);
  external Function get onreadystatechange;
  external set onreadystatechange(Function v);
  external num get readyState;
  external set readyState(num v);
  external String get responseText;
  external set responseText(String v);
  external num get status;
  external set status(num v);
  external bool get withCredentials;
  external set withCredentials(bool v);
  external Function get ontimeout;
  external set ontimeout(Function v);
  external Function get onerror;
  external set onerror(Function v);
  external Function get onprogress;
  external set onprogress(Function v);
  external Function get onload;
  external set onload(Function v);
  external Function get abort;
  external set abort(Function v);
}

/* WARNING: export assignment not yet supported. */
