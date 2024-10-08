//
//  AppBackendAPI.swift
//
//
//

import Foundation

class AppBackendAPI {
  let urlSession: URLSession
  let baseURL: URL
  
  init(baseURL: URL) {
    self.baseURL = baseURL
    
    // Use a configuration that waits for connectivity to handle the local
    // network permission prompt when testing on a real device connecting to
    // another system on the local network.
    let configuration = URLSessionConfiguration.default
    configuration.waitsForConnectivity = true
    configuration.timeoutIntervalForResource = 10
    urlSession = URLSession(configuration: configuration)
  }
  
  func fetchConfiguration() async throws -> (SDKConfiguration, String) {
    let data = try await fetchTokenData()
    let config = try JSONDecoder().decode(SDKConfiguration.self, from: data)
    let token = try JSONDecoder().decode(TokenResponse.self, from: data)
    return (config, token.jwtToken)
  }
  
  func fetchToken() async throws -> String {
    let data = try await fetchTokenData()
    let response = try JSONDecoder().decode(TokenResponse.self, from: data)
    return response.jwtToken
  }
  
  private func fetchTokenData() async throws -> Data {
    let settingsData = SettingsData()
    var request = URLRequest(url: baseURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //Note: userId is mandatory field
    request.httpBody = try JSONSerialization.data(withJSONObject: [
      "userName": settingsData.yourDisplayName,
      "userId": settingsData.yourUserName,
      "verified": settingsData.verifiedUser,
      "userIdentifiers": ["emailAddresses" : [settingsData.yourEmailAddress]]
    ])
    
    let (data, _) = try await urlSession.data(for: request)
    return data
  }
}

struct SDKConfiguration: Codable, Equatable {
  let axpIntegrationId: String
  let axpHostName: String
  let appKey: String
  let callingRemoteAddress: String
  let configId: String?
  
  init(axpIntegrationId: String = "", axpHostName: String = "", appKey: String = "", callingRemoteAddress: String = "", configId: String = "") {
    self.axpIntegrationId = axpIntegrationId
    self.axpHostName = axpHostName
    self.appKey = appKey
    self.callingRemoteAddress = callingRemoteAddress
    self.configId = configId
  }
}

struct TokenResponse: Decodable {
  let jwtToken: String
}

enum APIError: Error {
  case invalidURLString
}
