import 'dart:js_interop';

import 'channels/channel.dart';
import 'events/dispatcher.dart';
import 'pusher.dart';

extension type UserFacade._(Dispatcher _) implements Dispatcher {
  external UserFacade({Pusher pusher});

  external Pusher pusher;

  @JS('signin_requested')
  external bool signinRequested;

  @JS('user_data')
  external JSAny? userData;

  external Channel serverToUserChannel;

  external JSPromise<JSAny?> signinDonePromise;

  // external WatchlistFacade watchlist;

  external void signin();
}
