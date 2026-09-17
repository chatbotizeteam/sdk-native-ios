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
        // Pinned exactly, and it has to stay that way until the follow-up below lands.
        // ZowieSDK.xcframework is compiled against 2.12.1 and reaches LiveKit's classes through
        // vtable slots fixed at that build. Slots carry no symbol, so another version still
        // links and only diverges once running. Measured, not theorised: with 2.17.0 the same
        // binary and app crash on entering voice chat (EXC_BAD_ACCESS, a jump to an address in
        // no loaded image), while on 2.12.1 a voice conversation connects and runs normally.
        //
        // A range would be worse than this pin, not better: apps that do not carry LiveKit today
        // — which is all of them, since it lived inside the binary — have no pin to preserve, so
        // SPM hands them the newest release and voice chat dies on first use. A mismatched pin
        // instead fails loudly at dependency resolution.
        //
        // The fix that removes the constraint is shipping the LiveKit-facing file as source, so
        // it compiles against whatever version the app resolves; planned as a follow-up.
        .package(url: "https://github.com/livekit/client-sdk-swift.git", exact: "2.12.1"),
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
