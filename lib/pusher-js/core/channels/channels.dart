@JS()
library core.channels.channels;

import "package:js/js.dart";
import "channel_table.dart" show ChannelTable;
import "../pusher.dart" show Pusher;
import "channel.dart" show Channel;

/// Handles a channel map.
@JS()
class Channels {
  // @Ignore
  // Channels.fakeConstructor$();
  external ChannelTable get channels;
  external set channels(ChannelTable v);
  external factory Channels();

  /// Creates or retrieves an existing channel by its name.
  external add(String name, Pusher pusher);

  /// Returns a list of all channels
  external List<Channel> all();

  /// Finds a channel by its name.
  external find(String name);

  /// Removes a channel from the map.
  external remove(String name);

  /// Proxies disconnection signal to all channels.
  external disconnect();
}

@JS()
external Channel createChannel(String name, Pusher pusher);
