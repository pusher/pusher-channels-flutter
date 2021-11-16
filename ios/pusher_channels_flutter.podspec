#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint pusher_channels.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'pusher_channels_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Pusher Channels Flutter integration.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/pusher/pusher-channels-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Pusher' => 'info@pusher.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'PusherSwift', '~> 10.0.0'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
