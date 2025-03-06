import 'dart:js_interop';

import 'channels/channel.dart';
import 'channels/channel_table.dart';
import 'pusher.dart';

extension type Channels._(JSObject _) implements JSObject {
  external Channels();

  external ChannelTable channels;

  external Channel add(String name, Pusher pusher);

  external JSArray<Channel> all();

  external Channel find(String name);

  external Channel remove(String name);

  external void disconnect();
}
