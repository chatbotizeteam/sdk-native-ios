// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ZowieSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ZowieSDK",
            targets: ["ZowieSDKTargets"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/livekit/webrtc-xcframework.git",
            exact: "137.7151.12"
        ),
    ],
    targets: [
        .binaryTarget(
            name: "ZowieSDK",
            url: "https://github.com/chatbotizeteam/sdk-native-ios/releases/download/1.0.5/ZowieSDK.xcframework.zip",
            checksum: "c3c1f70afde667429cf76c4fd4f7788677b61b5e9a27d5d2e1e2db5ca62d894d"
        ),
        .target(
            name: "ZowieSDKTargets",
            dependencies: [
                .target(name: "ZowieSDK"),
                .product(
                    name: "LiveKitWebRTC",
                    package: "webrtc-xcframework",
                    condition: .when(platforms: [.iOS])
                ),
            ],
            path: "Sources"
        )
    ]
)
