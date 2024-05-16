

import Foundation
import AXPCore


struct AXPMessagingConfiguration {
  let backendServerUrl: String = "http://localhost:3000/token"
  let userName: String = "Customer"
  let emailID: String = "customer@example.com"
  let engagementParameters = ["availableBalance" : "9500"]
  let pageSize = 50
}
