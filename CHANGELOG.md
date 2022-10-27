# Changelog

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
