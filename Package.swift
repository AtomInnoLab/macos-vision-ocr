// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "macos-vision-ocr",
     platforms: [
       .macOS(.v10_15)
     ],
    dependencies: [
      .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.2.3")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "macos-vision-ocr",
            dependencies: [
               .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
    ]
)
