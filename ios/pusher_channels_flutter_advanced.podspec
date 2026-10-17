#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint pusher_channels_flutter_advanced.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'pusher_channels_flutter_advanced'
  s.version          = '3.0.2'
  s.summary          = 'Pusher Channels Flutter integration.'
  s.description      = <<-DESC
A Flutter plugin for Pusher Channels.
                       DESC
  s.homepage         = 'https://github.com/nafiskabbo/pusher_channels_flutter_advanced'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Nafis Kabbo' => 'nafiskabbo30@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'pusher_channels_flutter_advanced/Sources/pusher_channels_flutter_advanced/**/*'
  s.dependency 'Flutter'
  s.dependency 'PusherSwift', '~> 10.1.9'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
