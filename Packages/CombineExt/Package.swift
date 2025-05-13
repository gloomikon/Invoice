// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CombineExt",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "CombineExt",
            targets: ["CombineExt"]),
    ],
    targets: [
        .target(name: "CombineExt")
    ]
)
