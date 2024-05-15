import AVKit
import Foundation

enum AudioPortType {
  case receiver
  case speaker
  case headset
}

/// Monitors the current audio route such as receiver, speaker, headset, etc.
///
/// This supports the audio route selection button in the user interface to
/// provide a visual indication of what the current type of audio route is.
class AudioRouteMonitor: ObservableObject {
  @Published private(set) var outputType = AudioPortType.receiver
  var routeChangeObserver: NSObjectProtocol?

  init() {
    routeChangeObserver = NotificationCenter.default.addObserver(forName: AVAudioSession.routeChangeNotification, object: nil, queue: .main) { [weak self] notification in
      self?.updateAudioRoute()
    }

    updateAudioRoute()
  }

  deinit {
    if let routeChangeObserver {
      NotificationCenter.default.removeObserver(routeChangeObserver)
    }
  }

  func updateAudioRoute() {
    let currentRoute = AVAudioSession.sharedInstance().currentRoute
    guard let output = currentRoute.outputs.first else {
      return
    }

    switch output.portType {
    case .builtInReceiver:
      outputType = .receiver
    case .builtInSpeaker:
      outputType = .speaker
    default:
      outputType = .headset
    }
  }
}
