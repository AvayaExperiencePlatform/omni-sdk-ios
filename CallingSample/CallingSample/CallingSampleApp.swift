//
//  CallingSampleApp.swift
//  CallingSample
//
//

import AXPCalling
import SwiftUI

@main
struct CallingSampleApp: App {
  init() {
    AXPCallingSDK.configureCallKit(
      iconTemplateImageData: UIImage(resource: .callKitIcon).pngData()
    )
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
