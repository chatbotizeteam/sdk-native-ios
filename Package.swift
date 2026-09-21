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
            url: "https://github.com/chatbotizeteam/sdk-native-ios/releases/download/1.0.9/ZowieSDK.xcframework.zip",
            checksum: "3625f2332942fbe8e817b7c615fd86c4ffcf6b04c25175dd12ba8d6762dd00a1"
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
