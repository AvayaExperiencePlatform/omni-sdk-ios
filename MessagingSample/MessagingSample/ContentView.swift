

import SwiftUI
import AXPMessagingUI

struct ContentView: View {
  var config = AXPMessagingSampleViewModel()
  @State private var isMessagingDisabled = true
  @State private var isConnecting = false
  @State private var showError = false
  @StateObject var dataModel = DataModel()
  
  init() {
    self.config.setupAvayaUISdkConfig()
  }
  var body: some View {
    NavigationView{
      ZStack {
        VStack {
          !isMessagingDisabled ? AXPMessagingUIView(configuration: config.configUI ?? AXPMessagingUIViewConfig(), conversation: dataModel.converstion!) {
          } : nil
        }
        if isConnecting {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            .padding(.bottom, 100)
            .scaleEffect(2)
        }
        
      }
      .alert(isPresented: $showError) {
        Alert(
          title: Text("Settings Error"),
          message: Text("Failed to connect to the server. Please check your settings and try again."),
          primaryButton: .default(Text("Retry"), action: {
            ConnectToMessagingSDK(dataModel: dataModel)
          }),
          secondaryButton: .cancel()
        )
      }
    }
    .onAppear(){
      ConnectToMessagingSDK(dataModel: dataModel)
    }
    
    
  }
  func ConnectToMessagingSDK(dataModel: DataModel){
    Task {
      do {
        isConnecting = true
        isMessagingDisabled = try await config.connectToMessagingChat(dataModel:dataModel)
        isConnecting = false
      } catch {
        isConnecting = false
        showError = true
      }
    }
  }
}
