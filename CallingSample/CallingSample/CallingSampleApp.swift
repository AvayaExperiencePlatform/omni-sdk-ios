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
    AXPCalling.configureCallKit(
      iconTemplateImageData: UIImage(resource: .callKitIcon).pngData()
    )
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
