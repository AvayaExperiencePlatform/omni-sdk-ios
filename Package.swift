// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "AXPOmniSDK",
  defaultLocalization: "en",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "AXPCore",
      targets: ["AXPCoreWrapper"]
    ),
    .library(
      name: "AXPCalling",
      targets: ["AXPCallingWrapper"]
    ),
    .library(
      name: "AXPMessaging",
      targets: ["AXPMessagingWrapper"]
    ),
    .library(
      name: "AXPMessagingUI",
      targets: ["AXPMessagingUI"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-openapi-runtime", .upToNextMinor(from: "1.4.0")),
    .package(url: "https://github.com/apple/swift-openapi-urlsession", .upToNextMinor(from: "1.0.0")),
    .package(url: "https://github.com/CoreOffice/XMLCoder", .upToNextMajor(from: "0.17.0")),
    .package(url: "https://github.com/daltoniam/Starscream", exact: "4.0.4"),
    .package(url: "https://github.com/elegantchaos/DictionaryCoding", .upToNextMajor(from: "1.0.9")),
    .package(url: "https://github.com/stasel/WebRTC", .upToNextMajor(from: "120.0.0")),
    .package(url: "https://github.com/Thomvis/BrightFutures", .upToNextMajor(from: "8.0.0")),
    .package(url: "https://github.com/yahoojapan/SwiftyXMLParser", .upToNextMajor(from: "5.0.0")),
  ],
  targets: [
    .target(
      name: "AXPCoreWrapper",
      dependencies: [
        "AXPCore",
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
      ]
    ),
    .target(
      name: "AXPCallingWrapper",
      dependencies: [
        "AXPCalling",
        "AXPCore",
        "BrightFutures",
        "DictionaryCoding",
        "SwiftyXMLParser",
        "WebRTC",
        "XMLCoder",
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
      ]
    ),
    .target(
      name: "AXPMessagingWrapper",
      dependencies: [
        "AXPMessaging",
        "AXPCore",
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
      ]
    ),
    .binaryTarget(
      name: "AXPCore",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v1.1.1/AXPCore.zip",
      checksum: "68f3ead4696012bef5a43125c8aa5cd7d4fcf460d512f0453f85e8880aba715a"
    ),
    .binaryTarget(
      name: "AXPCalling",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v1.1.1/AXPCalling.zip",
      checksum: "5ff6ab690daf97a6a7c722ed9e17cdae5eb0b856718f2ca6a27173785506a784"
    ),
    .binaryTarget(
      name: "AXPMessaging",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v1.1.1/AXPMessaging.zip",
      checksum: "6921731a764255525d56e7ba68e28cbf00f7780b4ba54c3d4132e0b4d157d273"
    ),
    .binaryTarget(
      name: "AXPMessagingUI",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v1.1.1/AXPMessagingUI.zip",
      checksum: "20bf839fc5c2c02553f26887b13624b64e517eb9fdbe4c5c6fc68d398a974466"
    )
  ]
)
