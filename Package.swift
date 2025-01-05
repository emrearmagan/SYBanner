// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SYBanner",
    platforms: [
    .iOS(.v13)
    ],
    products: [
        .library(name: "SYBanner", targets: ["SYBanner"])
    ],
    targets: [
        .target(name: "SYBanner", dependencies: [], path: "Sources")
    ],
    swiftLanguageVersions: [.v5]
)
