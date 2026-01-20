// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DemoAlexSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DemoAlexSDK",
            targets: ["DemoAlexSDK"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DemoAlexSDK",
            dependencies: [],
            path: "DemoAlexSDK/Classes"
        ),
    ]
)

