// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ONXWatchTower",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ONXWatchTower",
            targets: ["ONXWatchTower"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-atomics", .exactItem("1.2.0")),
        .package(url: "https://github.com/onxmaps/ios-core-services", .exactItem("2.2.4"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ONXWatchTower",
            dependencies: [
                .product(name: "Atomics", package: "swift-atomics"),
                .product(name: "ONXNetworking", package: "ios-core-services")
            ]
        ),
        .testTarget(
            name: "ONXWatchTowerTests",
            dependencies: ["ONXWatchTower"]
        ),
    ]
)
