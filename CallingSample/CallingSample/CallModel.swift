import AXPCore
import AXPCalling
import Foundation
import OSLog
import SwiftUI

class CallModel: ObservableObject, CallDelegate {
  func callDidEstablish(_ call: Call) {
    isConnected = true
    startTimer()
  }

  func call(_ call: Call, didFail error: Error) {
    stopTimer()
    errorMessage = error.localizedDescription
    self.call = nil
    isCalling = false
  }

  func callDidEnd(_ call: Call) {
    stopTimer()
    self.call = nil
    isCalling = false
    isConnected = false
  }

  func callDidUpdate(_ call: Call) {
    isMicrophoneMuted = call.isMicrophoneMuted
    remoteDisplayName = call.remoteDisplayName
  }

  let logger = Logger()
  var sdkConfig = SDKConfiguration()
  var setupTask: Task<(SDKConfiguration, String), Error>?
  var tokenProvider: TokenProvider?

  @Published private(set) var isCalling = false
  @Published private(set) var call: Call?
  @Published private(set) var isMicrophoneMuted = false
  @Published private(set) var isConnected = false
  @Published private(set) var remoteDisplayName = "Customer Support"
  @Published private(set) var elapsedTime: TimeInterval = 0

  var errorMessage = "" {
    didSet {
      if !errorMessage.isEmpty {
        logger.error("\(self.errorMessage)")
      }
    }
  }

  var hasError: Binding<Bool> {
    Binding {
      !self.errorMessage.isEmpty
    } set: { _ in
      self.errorMessage = ""
    }
  }

  private var elapsedTimer : Timer? = nil

  @MainActor func startCall() async {
    let baseURLString = UserDefaults.standard.string(forKey: UserDefaultConstants.appBackendServerURL) ?? "http://127.0.0.1:3000/token"
    guard let baseURL = URL(string: baseURLString) else {
      errorMessage = "Invalid app backend URL: \(baseURLString)"
      return
    }
    let api = AppBackendAPI(baseURL: baseURL)

    logger.info("Fetching SDK configuration from \(baseURLString)")

    let fetchConfigurationTask = Task {
      try await api.fetchConfiguration()
    }
    setupTask = fetchConfigurationTask
    isCalling = true

    do {
      let (config, token) = try await fetchConfigurationTask.value
      if fetchConfigurationTask.isCancelled { return }
      if config != sdkConfig {
        logger.info("Applying new SDK configuration")
        sdkConfig = config
        let tokenProvider = TokenProvider(api: api)
        self.tokenProvider = tokenProvider

        AXPClientSDK.configureSDK(
          applicationKey: sdkConfig.appKey,
          integrationID: sdkConfig.axpIntegrationId,
          tokenProvider: tokenProvider,
          host: "https://\(sdkConfig.axpHostName)",
          displayName: "Calling Sample App User"
        )
      }
      tokenProvider?.nextToken = token
    } catch {
      if fetchConfigurationTask.isCancelled { return }
      errorMessage = "Failed to fetch SDK configuration: \(error.localizedDescription)"
      isCalling = false
      return
    }

    logger.info("Starting call")

    let callOptions = CallOptions(
      remoteDisplayName: remoteDisplayName,
      remoteAddress: sdkConfig.callingRemoteAddress
    )
    let call = AXPCallingSDK.createCall(options: callOptions, delegate: self)
    self.call = call
    isConnected = false
    isMicrophoneMuted = call.isMicrophoneMuted
    elapsedTime = 0
    call.start()
  }

  public func endCall() {
    stopTimer()
    setupTask?.cancel()
    setupTask = nil
    call?.delegate = nil
    call?.end()
    call = nil
    isCalling = false
    isConnected = false
  }
  
  private func startTimer() {
    elapsedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      guard let establishedDate = call?.establishedDate else { return }
      self.elapsedTime = Date().timeIntervalSince(establishedDate)
    }
  }
  
  private func stopTimer() {
    self.elapsedTimer?.invalidate()
    self.elapsedTimer = nil
  }
}
