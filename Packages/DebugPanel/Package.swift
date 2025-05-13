// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DebugPanel",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DebugPanel",
            targets: ["DebugPanel"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/nkristek/Highlight.git", from: "0.4.0")
    ],
    targets: [
        .target(
            name: "DebugPanel",
            dependencies: [
                "Highlight"
            ]
        )
    ]
)
