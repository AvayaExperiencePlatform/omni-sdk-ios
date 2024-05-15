//
//  SettingsView.swift
//  CallingSample
//
//

import SwiftUI

struct SettingsView: View {
  //Custmer can hardcode as default value
  @AppStorage(UserDefaultConstants.appBackendServerURL)
  private var appBackendServerURL: String = "http://127.0.0.1:3000/token"
  
  @AppStorage(UserDefaultConstants.yourEmail)
  private var yourEmail = "testuser@avaya.com"
  
  let emailTitle = "Email"
  let appServerURLTitle = "Server URL"
  
  var body: some View {
    List {
      Section(header: Text("General").textCase(.none)) {
        VStack() {
          HStack(alignment: .center) {
            Text(emailTitle).foregroundColor(.primary)
            Spacer()
            NavigationLink(destination: SettingTextView(title: emailTitle, text: $yourEmail, keyboardType: .emailAddress)) {
              Spacer()
              Text(yourEmail).foregroundColor(.secondary)
            }
          }
        }
      }
      Section(header: Text("Servers").textCase(.none)) {
        VStack() {
          HStack(alignment: .center) {
            Text(appServerURLTitle).foregroundColor(.primary)
            Spacer()
            NavigationLink(destination: SettingTextView(title: appServerURLTitle, text: $appBackendServerURL, keyboardType: .URL)) {
              Spacer()
              Text(appBackendServerURL).foregroundColor(.secondary)
            }
          }
        }
      }
    }.listStyle(.insetGrouped)
  }
}

struct UserDefaultConstants {
  static let appBackendServerURL = "appBackendServerURL"
  static let yourEmail = "yourEmail"
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}






