import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import OSLog

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

  private let logger = Logger()
  
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//    FirebaseApp.configure()
//
//    // Register for remote notifications
//    UNUserNotificationCenter.current().delegate = self
//    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//      self.logger.debug("Permission granted: \(granted)")
//      
//      if granted {
//        DispatchQueue.main.async {
//          self.logger.debug("application.registerForRemoteNotifications");
//          UIApplication.shared.registerForRemoteNotifications()
//        }
//      }
//    }
//    application.registerForRemoteNotifications()
//    Messaging.messaging().delegate = self
//
//    return true
//  }

  // MARK: - UNUserNotificationCenterDelegate

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([.banner, .sound])
    
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }

  // MARK: - MessagingDelegate
  
//  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//    logger.debug("Firebase registration token: \(String(describing: fcmToken))")
//    
//    let keychainService = KeychainService(service: keychainServiceName,
//                                          accessGroup: groupName)
//    
//    if let fcmToken = fcmToken, let tokenData = fcmToken.data(using: .utf8) {
//      do {
//        try keychainService.setData(tokenData,
//                                    accessibility: .whenUnlocked,
//                                    forService: keychainServiceName,
//                                    account: "FCMToken")
//      } catch {
//        logger.debug("Failed to set FCM token in keychain: \(error)")
//      }
//    }
//  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    logger.debug("didRegisterForRemoteNotificationsWithDeviceToken")
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    logger.debug("APNS Device Token: \(token)")
    Messaging.messaging().apnsToken = deviceToken
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    logger.debug("Failed to register for remote notifications: \(error)")
  }
}

