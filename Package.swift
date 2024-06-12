// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZowieChatSDK",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "ZowieChatSDK",
            targets: ["ZowieSDKTargets"]
        ),
    ],
    dependencies: [
        .package(
            name: "Kingfisher",
            url: "https://github.com/onevcat/Kingfisher.git",
            .upToNextMajor(from: "7.8.0")
        ),
        .package(
            name: "Apollo",
            url: "https://github.com/apollographql/apollo-ios",
            .exact("0.49.1")
        ),
        .package(
            name: "Lottie",
            url: "https://github.com/airbnb/lottie-ios",
            .exact("4.4.1")
        )
    ],
    targets: [
        .binaryTarget(
            name: "ZowieSDK",
            path: "ZowieSDK.xcframework"
        ),
        .target(
            name: "ZowieSDKTargets",
            dependencies: [
                .target(name: "ZowieSDK"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "Lottie", package: "Lottie"),
                .product(name: "Apollo", package: "Apollo"),
                .product(name: "ApolloWebSocket", package: "Apollo"),
            ],
            path: "Sources"
        )
    ]
)
