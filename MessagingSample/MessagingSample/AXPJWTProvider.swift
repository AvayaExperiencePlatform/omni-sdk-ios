import AXPCore
import Foundation
import OSLog

public class AXPJWTProvider: AXPTokenProvider {
  
  private var logger = Logger.messagingSampleApp
  private let userDefaults = UserDefaults.appGroup
  
  public func fetchToken(completion: @escaping (Result<String, any Error>) -> Void) {
    Task {
      let tokenResponse = await fetchTokenFromAppServerAsync()
      switch tokenResponse {
      case .success(let token):
        completion(.success(token.jwtToken))
      case .failure(let failure):
        completion(.failure(failure))
      }
    }
  }
  
  
  func fetchTokenFromAppServerAsync() async -> (Result<TokenResponse, AXPError>) {
      guard let backendServer = URL(string: AXPMessagingConfiguration().backendServerUrl)
      else {
        return .failure(.badRequest)
      }
      var request = URLRequest(url: backendServer)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      let userIdentifiersObject: [String: [String]] = ["emailAdresses": [AXPMessagingConfiguration().emailID]]
    
    let body: [String: Any] = ["userId": AXPMessagingConfiguration().emailID,
                               "verified": true,
                               "userIdentifiers": userIdentifiersObject]
    
    let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
    request.httpBody = jsonData
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      if let response = response as? HTTPURLResponse, response.statusCode != 200 {
        self.logger.error("\(#function) Failed with status code: - \(response.statusCode)")
        return .failure(.notAuthorized)
      }
      let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
      return .success(tokenResponse)
    } catch {
      return .failure(.notAuthorized)
    }
  }
  
  func fetchTokenFromAppServer(completion: @escaping (Result<TokenResponse, AXPError>) -> Void) {
    let emailId = AXPMessagingConfiguration().emailID
    let backendServerURL = URL(string: AXPMessagingConfiguration().backendServerUrl)
    var request = URLRequest(url: backendServerURL!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = ["userId": emailId]
    let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        self.logger.error("\(#function) Failed: with error: -\(error)")
        completion(.failure(.notAuthorized))
        return
      }
      if let response = response as? HTTPURLResponse, response.statusCode != 200 {
        self.logger.error("\(#function) Failed with status code: - \(response.statusCode)")
        completion(.failure(.notAuthorized))
        return
      }
      do {
        guard let data = data else {
          completion(.failure(.badRequest))
          return
        }
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        completion(.success(tokenResponse))
      } catch {
        completion(.failure(.notAuthorized))
      }
    }
    task.resume()
  }
}

public struct TokenResponse: Codable {
  let axpIntegrationId: String
  let axpHostName: String
  let jwtToken: String
  let appKey: String
  let configId: String?
}

