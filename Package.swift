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
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v0.1.2/AXPCore.zip",
      checksum: "67349e956f9a6e55fde3d6e23e2bb0985677cd7e52a2feb9d7751f30d0b4b6d3"
    ),
    .binaryTarget(
      name: "AXPCalling",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v0.1.2/AXPCalling.zip",
      checksum: "444a33bd123d7978acfa7e8b9fe95ed4919db6cae9cc16e9e410d8840bd27df8"
    ),
    .binaryTarget(
      name: "AXPMessaging",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v0.1.2/AXPMessaging.zip",
      checksum: "1f1798a6ebeedcae40e04da8c22406264cb6d785b74332337187075e9a9b351d"
    ),
    .binaryTarget(
      name: "AXPMessagingUI",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v0.1.2/AXPMessagingUI.zip",
      checksum: "c18512312f97d9bcfdd2d8e56382644a95f3a16009510d391f453dfabf98b265"
    )
  ]
)
