import Security
import Foundation

class KeychainService {
    private let service: String
    public let defaultAccessGroup: String?
  
  public init(service: String, accessGroup: String? = nil) {
    self.service = service
    defaultAccessGroup = accessGroup
  }
  
  public enum ItemAccessibility {
    case whenPasscodeSetThisDeviceOnly
    case whenUnlockedThisDeviceOnly
    case whenUnlocked
    case afterFirstUnlockThisDeviceOnly
    case afterFirstUnlock

    var rawValue: CFString {
      switch self {
      case .whenPasscodeSetThisDeviceOnly: return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
      case .whenUnlockedThisDeviceOnly: return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
      case .whenUnlocked: return kSecAttrAccessibleWhenUnlocked
      case .afterFirstUnlockThisDeviceOnly: return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
      case .afterFirstUnlock: return kSecAttrAccessibleAfterFirstUnlock
      }
    }
  }
  
  private func query(service: String, account: String?, accessGroup: String?) -> [CFString: Any] {
    var query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service
    ]

    if let account = account {
      query[kSecAttrAccount] = account
    }

    if let accessGroup = accessGroup ?? defaultAccessGroup {
      query[kSecAttrAccessGroup] = accessGroup
    }

    return query
  }
  
  public func setData(_ data: Data, label: String? = nil, accessibility: ItemAccessibility, forService service: String, account: String? = nil, accessGroup: String? = nil) throws {
    let query = query(service: service, account: account, accessGroup: accessGroup)
    var update: [CFString: Any] = [
      kSecValueData: data,
      kSecAttrAccessible: accessibility.rawValue
    ]

    if let label = label {
      update[kSecAttrLabel] = label
    }

    var status = SecItemUpdate(query as CFDictionary, update as CFDictionary)
    if status == errSecItemNotFound {
      let attributes = query.merging(update) { $1 }
      status = SecItemAdd(attributes as CFDictionary, nil)
    }

    if status != errSecSuccess {
      throw KeychainError.unhandledError(status: status)
    }
  }

  func retrieveData(forAccount account: String, accessGroup: String?) throws -> Data? {
      var query = query(service: service, account: account, accessGroup: accessGroup)
      query[kSecMatchLimit] = kSecMatchLimitOne
      query[kSecReturnData] = kCFBooleanTrue

        var dataTypeRef: CFTypeRef?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        switch status {
        case errSecSuccess:
            return dataTypeRef as? Data
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.unhandledError(status: status)
        }
    }
}

enum KeychainError: Error {
    case unhandledError(status: OSStatus)
}
