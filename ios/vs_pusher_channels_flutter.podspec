#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint vs_pusher_channels_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'vs_pusher_channels_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Pusher Channels Flutter integration.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/VividSoda/pusher-channels-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Pusher' => 'info@pusher.com' }
  s.source           = { :path => '.' }
  s.source_files = 'vs_pusher_channels_flutter/Sources/vs_pusher_channels_flutter/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'PusherSwift', '~> 10.1.10'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # This plugin ships a privacy manifest (see Sources/vs_pusher_channels_flutter/PrivacyInfo.xcprivacy).
  s.resource_bundles = { 'vs_pusher_channels_flutter_privacy' => ['vs_pusher_channels_flutter/Sources/vs_pusher_channels_flutter/PrivacyInfo.xcprivacy'] }
end
