

import Foundation
import AXPCore
import AXPMessagingUI

public enum FCMError: Error, CustomStringConvertible {
    case tokenNotFound
  
  public var description: String {
    switch self {
    case .tokenNotFound:
      "Device token not found"
    }
  }
}

class AXPMessagingSampleViewModel {
  
  var configUI: AXPMessagingUIConfig?
  var isAXPSDKConfigured = false
  
  private let keychainService = KeychainService(service: "com.avaya.messaging",
                                                  accessGroup: "group.com.avaya.messaging")
  
  func setupAvayaUISdkConfig() {
    configUI = AXPMessagingUIConfig(pageSize: AXPMessagingConfiguration().pageSize)
  }
    
  func connectToMessagingChat(dataModel: DataModel) async throws -> Bool {
    let result = await signIn(dataModel: dataModel)
    switch result {
    case .success(let configId):
      if isAXPSDKConfigured {
        do {
            let defaultConversation = try await AXPClientSDK.getDefaultConversation()
              
            if !defaultConversation.sessionId.isEmpty {
              
              if let deviceTokenData = try? keychainService.retrieveData( forAccount: "FCMToken",
                                                                          accessGroup: "group.com.avaya.messaging"),
                 
                  let deviceToken = String(data: deviceTokenData, encoding: .utf8),
                 let configId = configId {
                await saveDeviceRegistration(sessionId: defaultConversation.sessionId,
                                             deviceToken: deviceToken,
                                             configId: configId)
              }
            }
            
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
  
  private func signIn(dataModel: DataModel) async -> Result<String?, AXPError> {
      let messagingProvider = dataModel.jwtProvider
      let result = await messagingProvider.fetchTokenFromAppServerAsync()
      switch result {
      case .success(let tokenResponse):
        let tokenData = try? JSONEncoder().encode(tokenResponse)
        guard let tokenData = tokenData else {
          return .failure(AXPError.invalidData)
        }
        
         try? keychainService.setData(tokenData,
                                      label: "com.avaya.messaging",
                                      accessibility: .whenUnlocked,
                                      forService: "com.avaya.messaging",
                                      account: "com.avaya.messaging")
        
        
        AXPClientSDK.configureSDK(applicationKey: tokenResponse.appKey,
                                  integrationID: tokenResponse.axpIntegrationId,
                                  tokenProvider: messagingProvider,
                                  host: "https://\(tokenResponse.axpHostName)",
                                  displayName: dataModel.me.name,
                                  sessionParameters: dataModel.sessionParameters,
                                  pushNotificationConfigID: tokenResponse.configId)
        
        isAXPSDKConfigured = true
        return .success(tokenResponse.configId)
        
      case .failure(_):
        return .failure(.notAuthorized)
      }
    }
}


