// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "vs_pusher_channels_flutter",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "vs-pusher-channels-flutter", targets: ["vs_pusher_channels_flutter"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/pusher/pusher-websocket-swift.git", from: "10.1.10")
    ],
    targets: [
        .target(
            name: "vs_pusher_channels_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "PusherSwift", package: "pusher-websocket-swift")
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
