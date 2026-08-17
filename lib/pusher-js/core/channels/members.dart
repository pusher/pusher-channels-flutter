import 'dart:js_interop';

/// Represents a collection of members of a presence channel.
@JS()
extension type Members._(JSObject _) implements JSObject {
  external factory Members();

  external JSAny? get members;
  external set members(JSAny? v);
  external num get count;
  external set count(num v);
  external JSAny? get myID;
  external set myID(JSAny? v);
  external JSAny? get me;
  external set me(JSAny? v);

  /// Returns member's info for given id.
  /// Resulting object containts two fields - id and info.
  external JSAny? get(String id);

  /// Calls back for each member in unspecified order.
  external void each(JSFunction callback);

  /// Updates the id for connected member. For internal use only.
  external void setMyID(String id);

  /// Handles subscription data. For internal use only.
  external void onSubscription(JSAny? subscriptionData);

  /// Adds a new member to the collection. For internal use only.
  external void addMember(JSAny? memberData);

  /// Adds a member from the collection. For internal use only.
  external void removeMember(JSAny? memberData);

  /// Resets the collection to the initial state. For internal use only.
  external void reset();
}
