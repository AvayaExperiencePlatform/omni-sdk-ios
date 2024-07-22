import UserNotifications
import AXPMessaging
import OSLog
import Foundation
import AXPCore

class NotificationService: UNNotificationServiceExtension {
  private let logger = Logger()
  var contentHandler: ((UNNotificationContent) -> Void)?
  var bestAttemptContent: UNMutableNotificationContent?
  private var dataModel = DataModel()
  private let userDefaults = UserDefaults.appGroup
  private let defaultNotificationMessage = "You have an unread message"
  
  static let dateFormatter: ISO8601DateFormatter = {
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      return formatter
  }()
  
  override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    
    guard let localBestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
      contentHandler(request.content)
      return
    }
    
    guard let eventId = request.content.userInfo["eventId"] as? String,
          let sessionId = request.content.userInfo["sessionId"] as? String,
          let conversationId = request.content.userInfo["conversationId"] as? String,
          let eventDateAny = request.content.userInfo["eventDate"],
          let eventDateString = eventDateAny as? String,
          let eventDate = Self.dateFormatter.date(from: eventDateString),
          let tokenData = try? KeychainService(service: "com.avaya.messaging").retrieveData(forAccount: "com.avaya.messaging", accessGroup: "group.com.avaya.messaging"),
          let tokenResponse = try? JSONDecoder().decode(TokenResponse.self, from: tokenData)
    else {
      localBestAttemptContent.body = defaultNotificationMessage
      contentHandler(localBestAttemptContent)
      return
    }
    
    let payloadData = NotificationPayload(eventDate: eventDate,
                                          eventId: eventId,
                                          conversationId: conversationId,
                                          sessionId: sessionId)
    
    let tokenProvider = AXPJWTProvider()
    
    let configuration = AXPOmniSDKConfig(
      applicationKey: tokenResponse.appKey,
      integrationID: tokenResponse.axpIntegrationId,
      tokenProvider: tokenProvider,
      host: "https://\(tokenResponse.axpHostName)",
      displayName: dataModel.me.name,
      sessionParameters: dataModel.sessionParameters,
      pushNotificationConfigID: tokenResponse.configId
    )

    localBestAttemptContent.title = "Messaging"
    
    Task {
      let message = try? await AXPMessagingSDK.messageForPushNotificationPayload(
        notificationPayload: payloadData,
        configuration: configuration)
      
      localBestAttemptContent.body = message ?? defaultNotificationMessage
      contentHandler(localBestAttemptContent)
    }
  }
  
  
  override func serviceExtensionTimeWillExpire() {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
      bestAttemptContent.body = defaultNotificationMessage
      contentHandler(bestAttemptContent)
    }
  }
  
}
