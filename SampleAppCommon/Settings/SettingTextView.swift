//
//  SettingTextView.swift
//  
//
//
import SwiftUI

struct SettingTextView: View {
  let title: String
  @Binding var text: String
  let keyboardType: UIKeyboardType
  
  var body: some View {
    List {
      Section(header: Text(title).textCase(.none)) {
        VStack {
          ClearableTextField(text: $text).keyboardType(keyboardType)
            .listStyle(GroupedListStyle())
            .autocapitalization(.none)
        }
      }
    }.listStyle(.insetGrouped)
  }
}

struct ClearableTextField: View {
  @Binding var text: String
  var body: some View {
    HStack {
      if #available(iOS 16.0, *) {
        TextField("", text: $text)
          .textFieldStyle(PlainTextFieldStyle())
          .tint(.primary)
      } else {
        // Fallback on earlier versions
        TextField("", text: $text)
          .textFieldStyle(PlainTextFieldStyle())
      }
      Button(action: {
        self.text = ""
      }) {
        Image(systemName: "xmark")
          .foregroundColor(.primary)
      }
    }
  }
}

struct SettingTextView_Previews: PreviewProvider {
  struct ABCView: View {
    @State private var text = "abc@avaya.com"
    var body: some View {
      SettingTextView(title: "Email", text: $text, keyboardType: .emailAddress)
    }
  }
  static var previews: some View {
    ABCView()
  }
}




