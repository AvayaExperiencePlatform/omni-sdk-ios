//
//  SettingsView.swift
//
//
//
import SwiftUI

struct SettingsView: View {
  @StateObject var settingsData = SettingsData()
  @StateObject private var viewModel = ContextParametersModel()
  var isMessaging: Bool = false
  
  var body: some View {
    Form {
      Section(header: Text("General").textCase(.none)) {
        VStack() {
          
          HStack(alignment: .center) {
            Text(UserDefaultConstants.yourDisplayName).foregroundColor(.primary)
            Spacer()
            NavigationLink(destination: SettingTextView(title: UserDefaultConstants.yourDisplayName, text: $settingsData.yourDisplayName, keyboardType: .default)) {
              Spacer()
              Text(settingsData.yourDisplayName).foregroundColor(.secondary)
            }
          }
        }.listRowBackground(textFieldBackgroundColor)
        
        HStack(alignment: .center) {
          Text(UserDefaultConstants.yourUserName).foregroundColor(.primary)
          Spacer()
          NavigationLink(destination: SettingTextView(title: UserDefaultConstants.yourUserName, text: $settingsData.yourUserName, keyboardType: .default)) {
            Spacer()
            Text(settingsData.yourUserName).foregroundColor(.secondary)
          }
        }.listRowBackground(textFieldBackgroundColor)
      }
      
      Section(header: Text("User Identifier").textCase(.none)) {
        VStack() {
          Toggle(isOn: $settingsData.verifiedUser, label: {
            Text("Verified User")
          })
        }.listRowBackground(textFieldBackgroundColor)
        
        VStack() {
          HStack(alignment: .center) {
            Text(UserDefaultConstants.yourEmailAddress).foregroundColor(.primary)
            Spacer()
            NavigationLink(destination: SettingTextView(title: UserDefaultConstants.yourEmailAddress, text: $settingsData.yourEmailAddress, keyboardType: .emailAddress)) {
              Spacer()
              Text(settingsData.yourEmailAddress).foregroundColor(.secondary)
            }
          }
        }.listRowBackground(textFieldBackgroundColor)
      }
      
      if isMessaging {
        Section(header: Text("Typing Indicator Settings").textCase(.none)) {
          VStack() {
            Toggle(isOn: $settingsData.showTypingIndicator, label: {
              Text("Show Typing Indicator")
            })
            
            Toggle(isOn: $settingsData.showTypingParticipantAvatar, label: {
              Text("Show Typing Participant Avatar")
            })
            
            Toggle(isOn: $settingsData.showTypingParticipantName, label: {
              Text("Show Typing Participant Name")
            })
          }.listRowBackground(textFieldBackgroundColor)
        }
      }      
      
      Section(header: Text("Servers").textCase(.none)) {
        VStack() {
          HStack(alignment: .center) {
            Text(UserDefaultConstants.appBackendServerURL).foregroundColor(.primary)
            Spacer()
            NavigationLink(destination: SettingTextView(title: UserDefaultConstants.appBackendServerURL, text: $settingsData.appBackendServerURL, keyboardType: .URL)) {
              Spacer()
              Text(settingsData.appBackendServerURL).foregroundColor(.secondary)
            }
          }
        }.listRowBackground(textFieldBackgroundColor)
      }
      
      Section(header: Text("ContextParameters").textCase(.none)) {
        ForEach(viewModel.keyValuePairs) { pair in
          HStack {
            TextField("Key", text: Binding(
              get: { pair.key },
              set: { newValue in
                if let index = viewModel.keyValuePairs.firstIndex(where: { $0.id == pair.id }) {
                  viewModel.keyValuePairs[index].key = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                }
              }
            )).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Value", text: Binding(
              get: { pair.value },
              set: { newValue in
                if let index = viewModel.keyValuePairs.firstIndex(where: { $0.id == pair.id }) {
                  viewModel.keyValuePairs[index].value = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                }
              }
            )).textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
            Button(action: {
              viewModel.removeKeyValue(at: pair.id)
            }) {
              Image(systemName: "minus.circle.fill")
                .foregroundColor(.red)
            }
          }
        }
        
        VStack {
          Button(action: {
            viewModel.addKeyValue()
          }) {
            HStack {
              Image(systemName: "plus.circle.fill")
              Text("Add Key/Value Pair")
            }
          }.padding()
        }
      }.listStyle(.insetGrouped)
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}


