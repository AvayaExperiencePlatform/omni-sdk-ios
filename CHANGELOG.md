## 1.1.0

Released October 4, 2024

- Added typing notification support
- Updated the appearance of the AXPMessagingUI chat view
- Added configuration options to customize the colors and fonts used by AXPMessagingUI chat view
- Display URLs using link previews when the message contains only a URL or a URL is at the end of a message
- Automatically dismiss keyboard when the use scrolls towards the bottom of the chat view
- Set up the messaging sample app for push notifications when supplied with Firebase configuration
- Fixed rendering and input of messages with newline characters
- Fixed grouping and display of date headers
- Fixed scroll-to-end behavior
- Fixed inconsistent appearance of the scroll-to-end floating action button
- Fixed building with Xcode 15.2

## 1.0.0

Released July 22, 2024

- Renamed some APIs for consistency with the Omni SDK name:
  - `AXPClientSDK` is renamed to `AXPOmniSDK`
  - `AXPSDKConfig` is renamed to `AXPOmniSDKConfig`
- Added AXPMessagingUI options to control whether agent and automation events are shown.

## 0.1.2

Released July 12, 2024

- Added support for push notifications in AXPMessaging.

## 0.1.1

Released June 17, 2024

- Package modules as static frameworks to bundle resources into apps automatically without needing to manually add a resource .bundle for AXPMessagingUI.

## 0.1.0

Released May 15, 2024

- Initial release
