# Changelog

## 2.8.0

- [ADDED] `init()` accepts `host`, `wsPort` and `wssPort`, so the client can connect to a self-hosted server (Soketi, laravel-websockets) instead of Pusher Channels cloud. Wired natively on Android (`PusherOptions.setHost/setWsPort/setWssPort`) and web (`wsHost`/`wsPort`/`wssPort`); iOS already honoured these once the Dart layer forwarded them. Omitting them keeps the endpoint the cluster resolves to, so cluster-based setups are unaffected.
- [CHANGED] `cluster` is now optional, since a self-hosted `host` replaces it. Supplying neither trips an assert in debug builds.
- [ADDED] `authParams['headers']` is now applied to `authEndpoint` requests on Android (`HttpChannelAuthorizer.setHeaders`) and iOS (via an `AuthRequestBuilderProtocol` implementation); previously these headers were silently dropped on both, so private/presence channels behind a token- or session-authenticated endpoint could not authorize outside the web platform. `authEndpoint` and `authParams` are no longer documented as pusher-js only.

## 2.7.1

- [CHANGED] Android: migrated to built-in Kotlin (AGP 9.0+), with an automatic fallback that applies the Kotlin Gradle Plugin when built-in Kotlin isn't active (AGP <9, or `android.builtInKotlin=false` — currently required on Flutter <3.47). No consumer-facing changes; either configuration builds correctly.
- [CHANGED] Example app: removed the `shared_preferences` dependency (it only pre-filled form fields for convenience) to keep the example free of plugins that haven't migrated to built-in Kotlin.

## 2.7.0

- [CHANGED] Migrated Android build to the latest Flutter plugin template: Kotlin DSL (`build.gradle.kts`), AGP 9.0.1, Kotlin 2.3.20, Gradle 9.1.0, compileSdk 36, Java 17. Example app build files migrated the same way.
- [ADDED] iOS: Swift Package Manager support alongside the existing CocoaPods podspec (`ios/pusher_channels_flutter/Package.swift`), following Flutter's current plugin folder layout (`ios/pusher_channels_flutter/Sources/pusher_channels_flutter`). Bumped PusherSwift to 10.1.10.
- [FIXED] iOS: `trigger()` never called back to Dart, so `PusherChannel.trigger()`/`PusherChannelsFlutter.trigger()` would hang forever instead of completing or throwing.
- [FIXED] Android/iOS: calling `connect`/`disconnect`/`subscribe`/`unsubscribe`/`trigger`/`getSocketId` before `init()` crashed the host app; now returns a `PlatformException`/`FlutterError` instead.
- [FIXED] Android: an unsupported `trigger()` call (e.g. private-encrypted channel, or a non-private/presence channel) threw an uncaught exception instead of surfacing a `PlatformException` to Dart.
- [ADDED] `PusherConnectionState` enum and `PusherChannelsFlutter.connectionStateEnum` as a typed, non-breaking alternative to the existing String-based `connectionState`.
- [CHANGED] Web: migrated off the discontinued `package:js` to `dart:js_interop`, dropping the `js` dependency entirely. Web now compiles to both dart2js and WebAssembly (`flutter build web --wasm`).
- [CHANGED] Web: removed ~65 unreachable files from the vendored `lib/pusher-js` interop bindings (Node.js/React Native/Web Worker runtime variants, JSONP/XHR-polling fallback transports, encryption support, and other pusher-js surface this plugin never used) — cut from 95 files to 30. No public API changes; these were internal, unused plumbing.

## 2.6.0

- [CHANGED] Upgrade Swift SDK to version 10.1.9.
- [CHANGED] Upgrade flutter version in Github Actions.
- [CHANGED] Fix release action.

## 2.5.0

- [CHANGED] bump js version
- [CHANGED] readme pusher-js version in example

## 2.4.0

- [FIXED] `auth` options https://github.com/pusher/pusher-channels-flutter/pull/140

## 2.3.0

- [CHANGED] Upgraded Flutter 3.24.3 https://github.com/pusher/pusher-channels-flutter/pull/176 Big thanks to @hamzamirai
- [CHANGED] Upgraded GH action/checkout@v3 to allow the release workflow to checkout PRs from forks

## 2.2.1

- [CHANGED] Update PusherSwift SDK to 10.1.5

## 2.2.0

- [CHANGED] Bump PusherSwift version to 10.1.4, which solves a reconnection issue when WebSocketConnectionDelegate triggers webSocketDidReceiveError event due to any POSIX error, except for ENOTCONN

## 2.1.3

- [CHANGED] Bump PusherSwift version to 10.1.3

## 2.1.2

- [FIXED] Handle only type on callback function.

## 2.1.1

- [CHANGED] Change call of activity.runOnUiThread to invoke methodChannel

## 2.1.0

- [CHANGED] Allow reinitialization of the pusher singleton
- [CHANGED] Add subscription count event handling ios/android
- [CHANGED] Update flutter dependencies to the latest versions.

## 2.0.2

- [FIXED] Fix private-encrypted channels subscriptions

## 2.0.1

- [FIXED] Change `getSocketId` function to return a `Future<String>`
- [FIXED] Replace `FlutterActivity` with general Activity
- [FIXED] Compilation errors on Example App

## 2.0.0

- [BREAKING CHANGE] Convert channel member to Map (instead of Set)
- [FIXED] Add internal member before calling onMemberAdded callback on channel
- [FIXED] onAuthorizer() doesn't work in Flutter web profile/release mode

## 1.0.5

- [FIXED] Android: Subscribing to private channels
- [FIXED] Android: Receiving events

## 1.0.4

- [FIXED] Dependency issue on android
- [FIXED] Compile issue on newer Kotlin versions
- [IMPROVEMENT] Updated dependencies

## 1.0.3

- [FIXED] release build issues on android
- [IMPROVEMENT] Always send connectionstate in uppercase
- [FIXED] release mode issue with js backend

## 1.0.2

- [FIXED] Android release configuration on example app

## 1.0.1

- [FIXED] Duplicated events on iOS

## 1.0.0

- Initial release
