// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "AXPSDK",
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
    .package(url: "https://github.com/apple/swift-openapi-runtime", .upToNextMinor(from: "1.1.0")),
    .package(url: "https://github.com/apple/swift-openapi-urlsession", .upToNextMinor(from: "1.0.0")),
    .package(url: "https://github.com/elegantchaos/DictionaryCoding", .upToNextMajor(from: "1.0.9")),
    .package(url: "https://github.com/stasel/WebRTC", .upToNextMajor(from: "120.0.0")),
    .package(url: "https://github.com/Thomvis/BrightFutures", .upToNextMajor(from: "8.0.0")),
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
        "WebRTC",
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
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v0.0.1/AXPCore.zip",
      checksum: "896a6da44b3b5f848f5783f121fb2bf68442c49e99fd81f2c9cd21d9e5b4d204"
    ),
    .binaryTarget(
      name: "AXPCalling",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v0.0.1/AXPCalling.zip",
      checksum: "d9a29f2198221f5ce7605e55faff0c8edb0417545030abd9ccae9cd8c0a917a4"
    ),
    .binaryTarget(
      name: "AXPMessaging",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v0.0.1/AXPMessaging.zip",
      checksum: "fe024e47348f47a81cf70bfcdcaac70410d32fcdb020eee522850e0477e282bb"
    ),
    .binaryTarget(
      name: "AXPMessagingUI",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v0.0.1/AXPMessagingUI.zip",
      checksum: "73407f2365be06e39eac38661672f2710e7702330a04a08554162e80eafba03d"
    )
  ]
)
