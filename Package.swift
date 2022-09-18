// swift-tools-version:5.1
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
        .target(
            name: "SYBanner",
            path: "SYBanner"
        )
    ],
    swiftLanguageVersions: [ .v5 ]
)
