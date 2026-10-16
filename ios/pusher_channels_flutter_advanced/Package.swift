// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "pusher_channels_flutter_advanced",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "pusher-channels-flutter-advanced", targets: ["pusher_channels_flutter_advanced"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/pusher/pusher-websocket-swift.git", from: "10.1.9"),
    ],
    targets: [
        .target(
            name: "pusher_channels_flutter_advanced",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                "PusherSwift",
            ],
            resources: []
        )
    ]
)
