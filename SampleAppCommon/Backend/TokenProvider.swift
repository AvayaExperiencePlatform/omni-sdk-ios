//
//  TokenProvider.swift
//
//
//
import AXPCore
import Foundation

class TokenProvider: AXPTokenProvider {
  let api: AppBackendAPI
  
  /// A static token to use for the next token fetch request.
  ///
  /// This is used in a case where both the configuration and token are being
  /// returned in a single request to avoid a redundant request for the token.
  var nextToken: String?
  
  init(api: AppBackendAPI) {
    self.api = api
  }
  
  func fetchToken(completion: @escaping (Result<String, Error>) -> Void) {
    Task {
      do {
        if let nextToken {
          self.nextToken = nil
          completion(.success(nextToken))
        } else {
          completion(.success(try await api.fetchToken()))
        }
      } catch {
        completion(.failure(error))
      }
    }
  }
}

enum TokenError: Error {
  case invalidURLString
}
