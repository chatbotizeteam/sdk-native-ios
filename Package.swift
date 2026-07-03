// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ZowieSDK",
    platforms: [.iOS(.v13)],
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
            url: "https://github.com/chatbotizeteam/sdk-native-ios/releases/download/1.0.2/ZowieSDK.xcframework.zip",
            checksum: "ae340e58f7e9c0adada759fd26f103e26668f42f527ed456515097b35f2d92b0"
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
