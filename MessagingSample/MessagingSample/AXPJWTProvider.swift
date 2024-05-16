import AXPCore
import AXPMessaging
import Foundation
import OSLog


class AXPJWTProvider : AXPTokenProvider {
  
  private var logger = Logger.messagingSampleApp
  
  func fetchToken(completion: @escaping (Result<String, Error>) -> Void) {
    fetchTokenFromAppServer { result in
      switch result {
      case .success(let tokenResponse):
        completion(.success( tokenResponse.jwtToken ))
        break
      case .failure(let error):
        completion(.failure(error))
        break
      }
    }
  }
  
  
  func fetchTokenFromAppServerAsync() async -> (Result<TokenResponse, AXPError>) {
    guard let backendServerURL = URL(string: AXPMessagingConfiguration().backendServerUrl)
    else {
      return .failure(.badRequest)
    }
    var request = URLRequest(url: backendServerURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let userIdentifiersObject: [String: [String]] = ["emailAddresses": [AXPMessagingConfiguration().emailID]]
    
    let body = ["userId" : AXPMessagingConfiguration().emailID, "verified" : true, "userIdentifiers" : userIdentifiersObject] as [String : Any]
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
    }
    catch {
      return .failure(.notAuthorized)
    }
    
  }
  
  
  func fetchTokenFromAppServer(completion: @escaping (Result<TokenResponse, AXPError>) -> Void) {
    guard let backendServer = URL(string: AXPMessagingConfiguration().backendServerUrl)
    else {
      return completion(.failure(.badRequest))
    }
    var request = URLRequest(url: backendServer)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let userIdentifiersObject: [String: [String]] = ["emailAdresses": [AXPMessagingConfiguration().emailID]]
    
    let body = ["userId" : AXPMessagingConfiguration().emailID, "verified" : true, "userIdentifiers" : userIdentifiersObject] as [String : Any]
    
    let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        self.logger.error("\(#function) Failed: with error: -\(error)")
        completion(.failure(.notAuthorized))
        return
      }
      if let response = response as? HTTPURLResponse, response.statusCode != 200 {
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

public struct TokenResponse : Decodable {
  let appKey: String
  let axpIntegrationId: String
  let axpHostName: String
  let jwtToken: String
}

extension Logger {
  static let messagingSampleApp = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "messagingSample")
}

