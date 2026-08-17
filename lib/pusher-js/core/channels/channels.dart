import 'dart:js_interop';

import 'channel_table.dart' show ChannelTable;
import '../pusher.dart' show Pusher;
import 'channel.dart' show Channel;

/// Handles a channel map.
@JS()
extension type Channels._(JSObject _) implements JSObject {
  external factory Channels();

  external ChannelTable get channels;
  external set channels(ChannelTable v);

  /// Creates or retrieves an existing channel by its name.
  external JSAny? add(String name, Pusher pusher);

  /// Returns a list of all channels
  external JSArray<Channel> all();

  /// Finds a channel by its name.
  external JSAny? find(String name);

  /// Removes a channel from the map.
  external JSAny? remove(String name);

  /// Proxies disconnection signal to all channels.
  external void disconnect();
}

@JS()
external Channel createChannel(String name, Pusher pusher);
