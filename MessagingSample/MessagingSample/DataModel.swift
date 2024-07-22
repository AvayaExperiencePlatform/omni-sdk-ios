

import Foundation
import AXPCore

class DataModel : ObservableObject {
  
  var converstion: Conversation?
  var particiants: [Participant] = []
  var axpSdkConfig: AXPOmniSDKConfig?
  var jwtProvider: AXPJWTProvider = AXPJWTProvider()
  // TODO: Shall be replace by Participant
  var me = User(name: "anyName", email: "anyName@example.com", avatar: "")
  
  //Should these two be moved to somewhere else?
  let sessionParameters = ["language": "english",
                           "device": "mobile",
                           "app": "iOS"
  ]

  let engagementParameters = ["availableBalance" : "9500"]
}
