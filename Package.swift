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
        // Voice chat runs on LiveKit. Earlier releases compiled it into ZowieSDK.xcframework,
        // which collided ("Class ... is implemented in both ...") with any app that already
        // depends on LiveKit itself; it is a normal shared dependency now, so SPM keeps one
        // copy. LiveKit brings WebRTC, SwiftProtobuf and swift-collections along — the binary
        // references none of those directly, so they are deliberately not pinned here: an
        // `exact` pin on WebRTC would make LiveKit 2.13+ unresolvable.
        //
        // The range is wider than this binary can strictly guarantee. ZowieSDK.xcframework was
        // compiled against 2.12.1 and reaches LiveKit's classes through vtable slot numbers
        // fixed at that build — `Room.connect` is slot 31 in 2.12.1 and 33 in 2.17.0,
        // `Participant.isMicrophoneEnabled` 26 vs 27. Slots carry no symbol, so a newer LiveKit
        // still links and then runs whatever now sits in the slot: voice chat can misbehave or
        // crash at runtime away from 2.12.1. Text chat is unaffected.
        //
        // Accepted knowingly: `exact` would instead break dependency resolution outright for
        // every app on a different LiveKit. The real fix — shipping the LiveKit-facing file as
        // source so it compiles against the app's own version — is a planned follow-up.
        .package(url: "https://github.com/livekit/client-sdk-swift.git", from: "2.12.1"),
    ],
    targets: [
        // ⛔️ MUST be bumped to the 1.0.7 release before this branch is merged. 1.0.6's binary
        // still has LiveKit compiled into it — pairing it with the LiveKit dependency above
        // gives every integrator the duplicate-symbol clash this change exists to remove.
        // Cut the release from the matching build.sh change first, then put its URL and
        // `swift package compute-checksum` output here.
        .binaryTarget(
            name: "ZowieSDK",
            url: "https://github.com/chatbotizeteam/sdk-native-ios/releases/download/1.0.6/ZowieSDK.xcframework.zip",
            checksum: "a6db79292dcb3190c0d35d8e711e1c2adaf2c66142752361ee38d8097899f3c8"
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
