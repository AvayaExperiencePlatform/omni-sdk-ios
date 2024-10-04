//
//  ActiveCallView.swift
//  CallingSample
//
//

import AVKit
import AXPCalling
import Foundation
import SwiftUI

fileprivate let iconSize: CGFloat = 20

struct ActiveCallView: View {
  @State private var isShowingKeypadView = false
  @ObservedObject var viewModel: CallModel

  var callConnectingString : String {
    return viewModel.isConnected ? "Connected" : "Connecting..."
  }

  var body: some View {
    if isShowingKeypadView, viewModel.isCalling {
      KeypadView(isShowingKeypadView: $isShowingKeypadView, viewModel: viewModel)
    } else {
      VStack {
        Spacer()
        Image(systemName: "person")
          .resizable()
          .frame(width: 50, height: 50)
          .foregroundColor(.white)

        Text(viewModel.remoteDisplayName)
          .font(.headline)
          .foregroundColor(.white)

        Text(callConnectingString)
          .font(.callout)
          .foregroundColor(.white)
          .padding()
          .accessibilityIdentifier(viewModel.isConnected ? "Connected" : "Connecting")

        if viewModel.isConnected {
          TimerView(viewModel: viewModel).frame(width: 100, height: 25)
        } else {
          Spacer().frame(height: 25)
        }

        Spacer()

        HStack {
          AudioRouteButton()
          Spacer()

          VStack {
            Button(action: {
              viewModel.call?.isMicrophoneMuted = !viewModel.isMicrophoneMuted
            }) {
              Image(systemName: viewModel.isMicrophoneMuted ? "mic.slash.fill" : "mic.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .padding(15)
                .background(Color.gray)
                .foregroundColor(.white)
                .clipShape(Circle())
                .overlay(
                  Circle()
                    .stroke(Color.white, lineWidth: 0)
                )
            }.buttonStyle(CallButtonStyle())
            Text("Mute").foregroundColor(.white).font(.subheadline)
          }

          Spacer()

          VStack {
            Button(action: {
              isShowingKeypadView.toggle()
            }) {
              Image("keypad")
                .resizable()
                .aspectRatio(CGSize(width: 10, height: 10), contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .padding(15)
                .background(Color.gray)
                .foregroundColor(.white)
                .clipShape(Circle())
                .overlay(
                  Circle()
                    .stroke(Color.white, lineWidth: 0)
                )
            }.accessibilityIdentifier("ShowKeypad")
            .buttonStyle(CallButtonStyle())
              .disabled(!viewModel.isConnected)
            Text("Keypad")
              .foregroundColor(.white)
              .font(.subheadline)
          }

          Spacer()

          VStack {
            Button(action: {
              viewModel.endCall()
            }) {
              Image(systemName: "phone.down.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .padding(15)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .overlay(
                  Circle()
                    .stroke(Color.white, lineWidth: 0)
                ).buttonStyle(CallButtonStyle())
            }.accessibilityIdentifier("EndCall")
            .buttonStyle(CallButtonStyle())
            Text("End").foregroundColor(.white).font(.subheadline)
          }
        }
        .padding(.trailing, 0)
      }
      .background(Color.black.edgesIgnoringSafeArea(.all))
    }
  }
}

struct CallButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.all, 10)
      .scaleEffect(configuration.isPressed ? 1.2 : 1)
      .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
  }
}

/// A button for selecting and indicating the current audio route, such as
/// receiver, speaker, headset, etc.
///
/// If no external devices are connected this button will toggle between the
/// built-in receiver or speaker if both are available, otherwise it will
/// display a system audio route selection dialog.
struct AudioRouteButton: View {
  @StateObject private var audioRouteMonitor = AudioRouteMonitor()

  let routePickerView = AVRoutePickerViewWrapper()

  var body: some View {
    ZStack {
      routePickerView.frame(width: 0, height: 0)
      VStack {
        Button(action: {
          let audioSession = AVAudioSession.sharedInstance()
          let hasExternalInput = audioSession.availableInputs?.contains(where: { $0.portType != .builtInMic }) ?? false
          if hasExternalInput {
            routePickerView.showRouteSelection()
          } else {
            // Toggle between receiver and speaker
            if audioSession.currentRoute.outputs.first?.portType == .builtInReceiver {
              try? audioSession.overrideOutputAudioPort(.speaker)
            } else {
              try? audioSession.overrideOutputAudioPort(.none)
            }
          }
        }) {
          let imageName = audioRouteMonitor.outputType == .headset ? "headphones" : "speaker.wave.3.fill"
          let isReceiver = audioRouteMonitor.outputType == .receiver
          Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: iconSize, height: iconSize)
            .padding(15)
            .background(isReceiver ? Color.gray : Color.white)
            .foregroundColor(isReceiver ? .white : .black)
            .clipShape(Circle())
            .overlay(
              Circle()
                .stroke(Color.white, lineWidth: 0)
            )
        }.buttonStyle(CallButtonStyle())
        Text("Audio").foregroundColor(.white).font(.subheadline)
      }
    }
  }
}

/// Wraps a hidden AVRoutePickerView.
///
/// iOS does not provide a way for an app to display a list of available audio
/// routes itself or an API to directly present a system route selection list.
/// The only way to do this is to use an AVRoutePickerView or MPVolumeView. You
/// can integrate one of these views into your UI directly, but their supported
/// styling options are limited. If you wish to use your own button that matches
/// your app's look and feel you can place a hidden AVRoutePickerView in your UI
/// and invoke it when your custom button is pressed as shown in this example.
struct AVRoutePickerViewWrapper: UIViewRepresentable {
  let routePickerView = AVRoutePickerView()

  func makeUIView(context: Context) -> some UIView {
    routePickerView.alpha = 0
    return routePickerView
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {}

  func showRouteSelection() {
    if let button = routePickerView.subviews.first(where: { $0 is UIButton }) as? UIButton {
      button.sendActions(for: .touchUpInside)
    }
  }
}

struct ActiveCallView_Previews: PreviewProvider {
  static var previews: some View {
    ActiveCallView(viewModel: CallModel())
  }
}
