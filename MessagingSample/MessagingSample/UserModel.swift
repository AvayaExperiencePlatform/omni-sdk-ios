

import Foundation

struct User: Hashable {
  static func == (lhs: User, rhs: User) -> Bool {
    lhs.name == rhs.name || lhs.email == rhs.email
  }
  var name: String
  var email: String
  var avatar: String
  var phone: String = ""
  var isCurrentUser: Bool = false
  
  public func isMe(name: String) -> Bool {
    return name == self.name
  }
}
