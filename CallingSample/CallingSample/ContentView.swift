//
//  ContentView.swift
//  CallingSample
//
//
import SwiftUI
import AVFoundation

let textFieldBackgroundColor = Color.white

struct ContentView: View {
  //Setting
  @State private var isShowingSettingView = false
  //Active Call
  @StateObject var callModel = CallModel()
  //Access Permision
  @State private var isShowingPermissionAlert = false

  var body: some View {
    makeView()
  }
  
  init() {
    UITableView.appearance().separatorStyle = .none
    UITableView.appearance().tableFooterView = UIView()
  }
  
  private func makeView() -> some View {
    NavigationView {
      ZStack {
        if callModel.isCalling {
          ActiveCallView(viewModel: callModel)
        } else {
          VStack {
            VStack {
              Spacer()
              Text("Calling Sample App").font(.largeTitle).accessibilityIdentifier("CallingSampleApp")
              Image("Avaya-Logo").resizable()
                .frame(width: 300, height: 200)
              Spacer()
              
              Button("Call Us") {
                Task {
                  if await AVCaptureDevice.requestAccess(for: .audio) {
                    await callModel.startCall()
                  } else {
                    self.isShowingPermissionAlert = true
                  }
                }
              }.accessibilityIdentifier("Call")
              .buttonStyle(GrowingButtonStyle())
                .alert(isPresented: $isShowingPermissionAlert) {
                  Alert(
                    title: Text("Permission Required"),
                    message: Text("Microphone access is needed to start a call, you can grant this permission in the Settings app."),
                    primaryButton: .default(Text("Settings")) {
                      openSettings()
                    },
                    secondaryButton: .cancel()
                  )
                }
                .alert(isPresented: callModel.hasError) {
                  Alert(
                    title: Text("Call Failed"),
                    message: Text(callModel.errorMessage),
                    dismissButton: .default(Text("OK")) {
                      callModel.errorMessage = ""
                    }
                  )
                }
              Spacer()
            }
          }
          .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
            Image(systemName: "gear")
              .imageScale(.large)
              .padding()
          }
          )
        }
      }
    }.navigationViewStyle(StackNavigationViewStyle())
  }
}

extension ContentView {
  private func openSettings() {
    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
      UIApplication.shared.open(settingsURL)
    }
  }
}

struct GrowingButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.all, 10)
      .background(Color.blue)
      .foregroundColor(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
      .scaleEffect(configuration.isPressed ? 1.2 : 1)
      .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
  }
}

#Preview {
  ContentView()
}
