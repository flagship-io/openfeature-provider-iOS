// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ABTastyOpenfeature-iOS",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)

    ],
    products: [
        .library(
            name: "ABTastyOpenfeature-iOS",
            targets: ["ABTastyOpenfeature-iOS"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/open-feature/swift-sdk.git", from: "0.4.0"),
        .package(url: "https://github.com/flagship-io/flagship-ios.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "ABTastyOpenfeature-iOS",
            dependencies: [
                .product(name: "OpenFeature", package: "swift-sdk"),
                .product(name: "Flagship", package: "flagship-ios")
            ],
            path: "ABTastyOpenfeature-iOS/Classes"
        ),
        .testTarget(
            name: "ABTastyOpenfeature-iOSTests",
            dependencies: ["ABTastyOpenfeature-iOS"]
        )
    ]
)
