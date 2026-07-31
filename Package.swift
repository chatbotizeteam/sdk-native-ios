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
            url: "https://github.com/chatbotizeteam/sdk-native-ios/releases/download/1.0.4/ZowieSDK.xcframework.zip",
            checksum: "9bebcada9f38c856aeb2e00d43bd130dfc9f7c1d0bba18c36235d60513d46afc"
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
