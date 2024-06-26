# Avaya Experience Platform™ iOS Omni SDK

> **:warning: Disclaimer**
>
> Installing, downloading, copying or using this SDK is subject to terms and conditions available in the LICENSE file.

## Prerequisites

Before you start integrating your iOS application with the Avaya Experience Platform™ (AXP) iOS Omni SDK, you need to make sure that you have the required information, like the `integrationId`, `appKey`, and `region`. The Avaya Experience Platform™ account administrator should be able to provide you with these details.

Your backend application server additionally needs changes to be able to acquire JWT tokens for your iOS application. Refer to [this guide](https://developers.avayacloud.com/avaya-experience-platform/docs/omni-sdk-introduction) for a detailed description about this.

## Getting Started

The Avaya Experience Platform™ iOS Omni SDK consist of four modules:

- [AXPCore](https://avayaexperienceplatform.github.io/omni-sdk-ios/documentation/axpcore/)
- [AXPCalling](https://avayaexperienceplatform.github.io/omni-sdk-ios/documentation/axpcalling/)
- [AXPMessaging](https://avayaexperienceplatform.github.io/omni-sdk-ios/documentation/axpmessaging/)
- [AXPMessagingUI](https://avayaexperienceplatform.github.io/omni-sdk-ios/documentation/axpmessagingui/)

Start with the [AXPCore](https://avayaexperienceplatform.github.io/omni-sdk-ios/documentation/axpcore/) module to initialize the SDK and establish a session with AXP. The easiest and fastest way to enable your application with AXP Messaging capabilities is to use the built-in [AXPMessagingUI](https://avayaexperienceplatform.github.io/omni-sdk-ios/documentation/axpmessagingui/). In case your application needs to handle messaging events or you want to create your own Messaging UI, use the [AXPMessaging](https://avayaexperienceplatform.github.io/omni-sdk-ios/documentation/axpmessaging/) module.

## License

View [LICENSE](./LICENSE)
