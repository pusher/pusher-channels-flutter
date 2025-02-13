# Changelog

## 2.5.0

* [CHANGED] bump js version
* [CHANGED] readme pusher-js version in example

## 2.4.0

* [FIXED] `auth` options https://github.com/pusher/pusher-channels-flutter/pull/140

## 2.3.0

* [CHANGED] Upgraded Flutter 3.24.3 https://github.com/pusher/pusher-channels-flutter/pull/176 Big thanks to @hamzamirai
* [CHANGED] Upgraded GH action/checkout@v3 to allow the release workflow to checkout PRs from forks

## 2.2.1

* [CHANGED] Update PusherSwift SDK to 10.1.5

## 2.2.0

* [CHANGED] Bump PusherSwift version to 10.1.4, which solves a reconnection issue when WebSocketConnectionDelegate triggers webSocketDidReceiveError event due to any POSIX error, except for ENOTCONN

## 2.1.3

* [CHANGED] Bump PusherSwift version to 10.1.3

## 2.1.2

* [FIXED] Handle only  type on  callback function.

## 2.1.1

* [CHANGED] Change call of activity.runOnUiThread to invoke methodChannel

## 2.1.0

* [CHANGED] Allow reinitialization of the pusher singleton
* [CHANGED] Add subscription count event handling ios/android
* [CHANGED] Update flutter dependencies to the latest versions.

## 2.0.2

* [FIXED] Fix private-encrypted channels subscriptions

## 2.0.1
* [FIXED] Change `getSocketId` function to return a `Future<String>`
* [FIXED] Replace `FlutterActivity` with general Activity
* [FIXED] Compilation errors on Example App

## 2.0.0

* [BREAKING CHANGE] Convert channel member to Map (instead of Set)
* [FIXED] Add internal member before calling onMemberAdded callback on channel
* [FIXED] onAuthorizer() doesn't work in Flutter web profile/release mode

## 1.0.5

* [FIXED] Android: Subscribing to private channels
* [FIXED] Android: Receiving events

## 1.0.4

* [FIXED] Dependency issue on android
* [FIXED] Compile issue on newer Kotlin versions
* [IMPROVEMENT] Updated dependencies

## 1.0.3

* [FIXED] release build issues on android
* [IMPROVEMENT] Always send connectionstate in uppercase
* [FIXED] release mode issue with js backend

## 1.0.2

* [FIXED] Android release configuration on example app

## 1.0.1

* [FIXED] Duplicated events on iOS

## 1.0.0

* Initial release
