import 'dart:js_interop';

extension type Members._(JSObject _) implements JSObject {
  external Members();

  external JSAny members;

  external num count;

  @JS('myID')
  external JSAny myId;

  external JSAny get(String id);

  external void each(JSFunction callback);

  external void onSubscription(JSAny subscriptionData);

  external JSAny addMember(JSAny memberData);

  external JSAny removeMember(JSAny memberData);

  external void reset();
}
