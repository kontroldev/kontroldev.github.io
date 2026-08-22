// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "RaulGallegoPortfolio",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/twostraws/Ignite.git", from: "0.6.0")
    ],
    targets: [
        .executableTarget(
            name: "RaulGallegoPortfolio",
            dependencies: [.product(name: "Ignite", package: "Ignite")]
        )
    ]
)
