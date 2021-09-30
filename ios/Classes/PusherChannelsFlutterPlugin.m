#import "PusherChannelsFlutterPlugin.h"
#if __has_include(<pusher_channels/pusher_channels-Swift.h>)
#import <pusher_channels/pusher_channels-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "pusher_channels-Swift.h"
#endif

@implementation PusherChannelsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPusherChannelsFLutterPlugin registerWithRegistrar:registrar];
}
@end
