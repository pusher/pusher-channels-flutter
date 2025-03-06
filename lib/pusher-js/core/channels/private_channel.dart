// export default class PrivateChannel extends Channel {
//     authorize(socketId: string, callback: ChannelAuthorizationCallback): void;
// }

import '../auth/options.dart';
import 'channel.dart';

extension type PrivateChannel._(Channel _) implements Channel {
  external void authorize(
    String socketId,
    ChannelAuthorizationCallback callback,
  );
}
