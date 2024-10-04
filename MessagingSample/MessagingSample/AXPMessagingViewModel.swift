import Foundation
import AXPCore
import AXPMessagingUI
import OSLog

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
  
  var configUI: AXPMessagingUIViewConfig?
  var isAXPSDKConfigured = false
  
  var sdkConfig = SDKConfiguration()
  var setupTask: Task<(SDKConfiguration, String), Error>?
  var tokenProvider: TokenProvider?
  
  let logger = Logger()
  
  private let keychainService = KeychainService(service: keychainServiceName,
                                                accessGroup: groupName)
  
  func setupAvayaUISdkConfig() {
    configUI = AXPMessagingUIViewConfig(pageSize: AXPMessagingConfiguration().pageSize)
  }
  
  func connectToMessagingChat(dataModel: DataModel) async throws -> Bool {
    let result = await signIn(dataModel: dataModel)
    switch result {
    case .success(let configId):
      if isAXPSDKConfigured {
        do {
          let defaultConversation = try await AXPOmniSDK.getDefaultConversation()
          
          if !defaultConversation.sessionId.isEmpty {
            
            if let deviceTokenData = try? keychainService.retrieveData( forAccount: "FCMToken",
                                                                        accessGroup: groupName),
               
                let deviceToken = String(data: deviceTokenData, encoding: .utf8),
               let configId = configId {
              await saveDeviceRegistration(sessionId: defaultConversation.sessionId,
                                           deviceToken: deviceToken,
                                           configId: configId)
            }
          }
          
          defaultConversation.contextParameters = SettingsData().contextParameters
          
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
    let baseURLString = UserDefaults.appGroup.string(forKey: UserDefaultConstants.appBackendServerURL) ?? defaultBackendServerURL
    guard let baseURL = URL(string: baseURLString) else {
      // errorMessage = "Invalid app backend URL: \(baseURLString)"
      return .failure(AXPError.invalidData)
    }
    let api = AppBackendAPI(baseURL: baseURL)
    logger.info("Fetching SDK configuration from \(baseURLString)")
    
    let fetchConfigurationTask = Task {
      try await api.fetchConfiguration()
    }
    setupTask = fetchConfigurationTask
    isAXPSDKConfigured = false
    do {
      let (config, token) = try await fetchConfigurationTask.value
      if fetchConfigurationTask.isCancelled { return  .failure(AXPError.cancelled)}
      if config != sdkConfig {
        logger.info("Applying new SDK configuration")
        sdkConfig = config
        let tokenProvider = TokenProvider(api: api)
        self.tokenProvider = tokenProvider
        
        if let tokenData = try? JSONEncoder().encode(sdkConfig) {
          try? keychainService.setData(tokenData,
                                       label: keychainServiceName,
                                       accessibility: .whenUnlocked,
                                       forService: keychainServiceName,
                                       account: keychainServiceName)
        } else {
          return .failure(AXPError.internalError)}
      }
      
      AXPOmniSDK.configureSDK(
        applicationKey: sdkConfig.appKey,
        integrationID: sdkConfig.axpIntegrationId,
        tokenProvider: tokenProvider!,
        host: "https://\(sdkConfig.axpHostName)",
        displayName: SettingsData().yourDisplayName,
        sessionParameters: AXPMessagingConfiguration().sessionParameters,
        pushNotificationConfigID: sdkConfig.configId
      )
      isAXPSDKConfigured = true
      tokenProvider?.nextToken = token
      return .success(sdkConfig.configId)
    } catch {
      if fetchConfigurationTask.isCancelled { return .failure(AXPError.cancelled)}
      isAXPSDKConfigured = false
      return .failure(.notAuthorized)
    }
  }
}


