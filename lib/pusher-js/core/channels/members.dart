@JS()
library core.channels.members;

import "package:js/js.dart";

/// Represents a collection of members of a presence channel.
@JS()
class Members {
  external dynamic get members;
  external set members(dynamic v);
  external num get count;
  external set count(num v);
  external dynamic get myID;
  external set myID(dynamic v);
  external dynamic get me;
  external set me(dynamic v);
  external factory Members();

  /// Returns member's info for given id.
  /// Resulting object containts two fields - id and info.
  external dynamic get(String id);

  /// Calls back for each member in unspecified order.
  external each(Function callback);

  /// Updates the id for connected member. For internal use only.
  external setMyID(String id);

  /// Handles subscription data. For internal use only.
  external onSubscription(dynamic subscriptionData);

  /// Adds a new member to the collection. For internal use only.
  external addMember(dynamic memberData);

  /// Adds a member from the collection. For internal use only.
  external removeMember(dynamic memberData);

  /// Resets the collection to the initial state. For internal use only.
  external reset();
}
