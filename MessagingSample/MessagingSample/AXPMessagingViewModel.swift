

import Foundation
import AXPCore
import AXPMessagingUI

class AXPMessagingSampleViewModel {
  
  var configUI: AXPMessagingUIConfig?
  var isAXPSDKConfigured = false
  
  func setupAvayaUISdkConfig() {
    configUI = AXPMessagingUIConfig(pageSize: AXPMessagingConfiguration().pageSize)
  }
  
  
  //var dataModel = DataModel()
  
  func connectToMessagingChat(dataModel: DataModel) async throws -> Bool {
    let result = await signIn(dataModel: dataModel)
    switch result {
    case .success(_):
      if isAXPSDKConfigured {
        do {
          let defaultConversation = try await AXPClientSDK.getDefaultConversation()
          
          defaultConversation.contextParameters = AXPMessagingConfiguration().engagementParameters
          
          dataModel.converstion = defaultConversation
          return false
        }
        catch {
          throw error
        }
      } else {
        return true
      }
    case .failure(let error):
      throw error
    }
    
  }
  
  private func signIn(dataModel: DataModel) async -> Result<String, AXPError> {
    let messagingProvider = dataModel.jwtProvider
    let result = await messagingProvider.fetchTokenFromAppServerAsync()
    switch result {
    case .success(let tokenResponse):
      guard let hostURL = URL(string: "https://\(tokenResponse.axpHostName)") else {
        return .failure(.badRequest)
      }
      AXPClientSDK.configureSDK(applicationKey: tokenResponse.appKey,
                                integrationID: tokenResponse.axpIntegrationId,
                                tokenProvider: messagingProvider,
                                host: hostURL.absoluteString,
                                displayName: dataModel.me.name,
                                sessionParameters: dataModel.sessionParameters)
      isAXPSDKConfigured = true
      return .success(tokenResponse.jwtToken)
      
    case .failure(_):
      isAXPSDKConfigured = false
      return .failure(.notAuthorized)
    }
  }
}


