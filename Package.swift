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
        // LiveKit used to be compiled into ZowieSDK.xcframework, which broke apps that also
        // depend on it ("Class ... is implemented in both ..."). It is a shared SPM dependency
        // now. It brings WebRTC/SwiftProtobuf/swift-collections along; the binary references
        // none of those directly, so they are not pinned here.
        //
        // The exact pin is required: the binary calls LiveKit through vtable slots fixed at our
        // build time, so another version links fine and then crashes — verified, 2.17.0 dies on
        // entering voice chat. Lifted by the follow-up that ships the LiveKit-facing file as
        // source, compiled against the app's own version.
        .package(url: "https://github.com/livekit/client-sdk-swift.git", exact: "2.12.1"),
    ],
    targets: [
        .binaryTarget(
            name: "ZowieSDK",
            url: "https://github.com/chatbotizeteam/sdk-native-ios/releases/download/1.0.8/ZowieSDK.xcframework.zip",
            checksum: "ad025ec18a4893f36d371a5d95b5f02a3ad360b57869f94492f2a6a34c9ad4ef"
        ),
        .target(
            name: "ZowieSDKTargets",
            dependencies: [
                .target(name: "ZowieSDK"),
                .product(name: "LiveKit", package: "client-sdk-swift"),
            ],
            path: "Sources"
        )
    ]
)
