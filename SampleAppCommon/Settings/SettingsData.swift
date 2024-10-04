import Foundation
import SwiftUI
import OSLog

class SettingsData: ObservableObject {
  @AppStorage(UserDefaultConstants.yourEmailAddress, store: .appGroup)
  var yourEmailAddress: String = "test@example.com"
  @AppStorage(UserDefaultConstants.yourUserName, store: .appGroup)
  var yourUserName: String = "demouser"
  @AppStorage(UserDefaultConstants.yourDisplayName, store: .appGroup)
  var yourDisplayName: String = "Demo User"
  @AppStorage(UserDefaultConstants.verifiedUser, store: .appGroup)
  var verifiedUser: Bool = false
  @AppStorage(UserDefaultConstants.appBackendServerURL, store: .appGroup)
  var appBackendServerURL: String = defaultBackendServerURL
  @AppStorage(UserDefaultConstants.showTypingIndicator, store: .appGroup)
  var showTypingIndicator: Bool = true
  @AppStorage(UserDefaultConstants.showTypingParticipantAvatar, store: .appGroup)
  var showTypingParticipantAvatar: Bool = true
  @AppStorage(UserDefaultConstants.showTypingParticipantName, store: .appGroup)
  var showTypingParticipantName: Bool = true
 
  var contextParameters: [String:String] {
    get {
      Dictionary(uniqueKeysWithValues: ContextParametersModel().keyValuePairs.map{($0.key, $0.value)})
    }
  }
}

struct KeyValue: Identifiable, Codable {
  let id: UUID
  var key: String
  var value: String
}

class ContextParametersModel: ObservableObject {
  @Published var keyValuePairs: [KeyValue] = [] {
    didSet {
      saveKeyValues()
    }
  }
  init() {
    loadKeyValues()
  }
  func addKeyValue() {
    keyValuePairs.append(KeyValue(id: UUID(), key: " ", value: " "))
  }
  
  func removeKeyValue(at id: UUID) {
    keyValuePairs.removeAll() { $0.id == id }
  }
  private func saveKeyValues() {
    do {
      let data = try JSONEncoder().encode(keyValuePairs)
      UserDefaults.appGroup.set(data, forKey: UserDefaultConstants.contextParameters)
    } catch {
      Logger().error("Failed to save contextParameters key values: \(error.localizedDescription)")
    }
  }
  private func loadKeyValues() {
    guard let data = UserDefaults.appGroup.data(forKey: UserDefaultConstants.contextParameters) else { return }
    do {
      keyValuePairs = try JSONDecoder().decode([KeyValue].self, from: data)
    } catch {
      print("Failed to load contextParameters key values: \(error.localizedDescription)")
    }
  }
}

struct UserDefaultConstants {
  static let appBackendServerURL = "Server URL"
  static let yourEmailAddress = "Email Address"
  static let yourUserName = "User Name"
  static let yourDisplayName = "Display Name"
  static let verifiedUser = "Verified User"
  static let yourFirstName = "yourFirstName"
  static let yourLastName = "yourLastName"
  static let contextParameters = "contextParameters"
  static let showTypingIndicator = "showTypingIndicator"
  static let showTypingParticipantAvatar = "showTypingParticipantAvatar"
  static let showTypingParticipantName = "showTypingParticipantName"
}

extension UserDefaults {
   public static let appGroup = UserDefaults(suiteName: groupName)!
}
