import Foundation
import UserNotifications
import UIKit
import OSLog

struct NotificationRegistrationRequest: Codable {
  let configId: String
  let sessionId: String
  let type: String
}

struct NotificationRegistrationResponse: Codable {
  var configId: String?
  var sessionId: String?
  var deviceToken: String?
}

protocol NotificationRegistrationService {

  func saveDeviceRegistration(registrationRequest: NotificationRegistrationRequest) async throws -> NotificationRegistrationResponse

  func deleteDeviceRegistration() async throws -> Bool
}

protocol NotificationRegistrationRepository {
  func saveDeviceRegistration(deviceToken: String, configId: String, sessionId: String) async -> Bool
  func deleteDeviceRegistration(deviceToken: String) async -> Bool
}

class NotificationRegistrationServiceImpl: NotificationRegistrationService {
  
  private let deviceRegistrationURL: URL
  
  init(baseURL: String, deviceToken: String) {
      guard let url = URL(string: "\(baseURL)custom-notification-connector/device-registrations/\(deviceToken)") else {
        fatalError("Invalid URL")
      }
      self.deviceRegistrationURL = url
    }
  
  func saveDeviceRegistration(registrationRequest: NotificationRegistrationRequest) async throws -> NotificationRegistrationResponse {
    var request = URLRequest(url: self.deviceRegistrationURL)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(registrationRequest)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
      throw URLError(.badServerResponse)
    }
    
    return try JSONDecoder().decode(NotificationRegistrationResponse.self, from: data)
  }
  
  func deleteDeviceRegistration() async throws -> Bool {
      var request = URLRequest(url: self.deviceRegistrationURL)
      request.httpMethod = "DELETE"
      
      let (_, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
        throw URLError(.badServerResponse)
      }
      
      return true
    }

}

class NotificationRegistrationRepositoryImpl: NotificationRegistrationRepository {
  private let service: NotificationRegistrationService
  private let logger = Logger() // Replace with your logging utility

  init(service: NotificationRegistrationService) {
    self.service = service
  }

  func saveDeviceRegistration(deviceToken: String, configId: String, sessionId: String) async -> Bool {
    do {
      let request = NotificationRegistrationRequest(configId: configId,
                                                    sessionId: sessionId,
                                                    type: "iOS")

      _ = try await service.saveDeviceRegistration(registrationRequest: request)
      return true
    } catch {
      logger.log("Failed to save device registration: \(error)")
      return false
    }
  }

  func deleteDeviceRegistration(deviceToken: String) async -> Bool {
    do {
      return try await service.deleteDeviceRegistration()
    } catch {
      logger.log("Failed to delete device registration: \(error)")
      return false
    }
  }
}

extension UIApplication {
  func removeAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
  }
}

extension UserDefaults {
   public static let appGroup = UserDefaults(suiteName: "group.com.avaya.messaging")!
}

func processFcmUrl(_ urlString: String) -> String? {
  guard let url = URL(string: urlString),
        let scheme = url.scheme, (scheme == "http" || scheme == "https"),
        url.host != nil else {
    return nil
  }

  var finalUrl = url.absoluteString
  if !finalUrl.hasSuffix("/") {
    finalUrl.append("/")
  }
  return finalUrl
}

func saveDeviceRegistration(sessionId: String,
                            deviceToken: String,
                            configId: String) async {
  guard let fcmUrl = processFcmUrl("https://digital-custom-fcm-connector.azurewebsites.net/") else { return }
  let service = NotificationRegistrationServiceImpl(baseURL: fcmUrl,
                                                    deviceToken: deviceToken)
  
  let repository = NotificationRegistrationRepositoryImpl(service: service)
  
  let deviceToken = deviceToken
  let configId = configId

  let success = await repository.saveDeviceRegistration(deviceToken: deviceToken,
                                                        configId: configId,
                                                        sessionId: sessionId)

  print("Device registration was \(success ? "successful" : "unsuccessful")")
}

func deleteDeviceRegistration(deviceToken: String) async {
  guard let fcmUrl = processFcmUrl("https://digital-custom-fcm-connector.azurewebsites.net") else { return }

  let service = NotificationRegistrationServiceImpl(baseURL: fcmUrl,
                                                    deviceToken: deviceToken)
  let repository = NotificationRegistrationRepositoryImpl(service: service)

  let deviceToken = deviceToken

  let success = await repository.deleteDeviceRegistration(deviceToken: deviceToken)
  print("Device registration delete was \(success ? "successful" : "unsuccessful")")
}
