#import "PusherChannelsFlutterPlugin.h"
#if __has_include(<pusher_websocket_flutter/pusher_websocket_flutter-Swift.h>)
#import <pusher_websocket_flutter/pusher_websocket_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "pusher_websocket_flutter-Swift.h"
#endif

@implementation PusherChannelsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPusherChannelsFlutterPlugin registerWithRegistrar:registrar];
}
@end
