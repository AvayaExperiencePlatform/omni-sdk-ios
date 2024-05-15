//
//  KeypadView.swift
//  CallingSample
//
//

import AXPCalling
import Foundation
import SwiftUI

struct KeypadView: View {
  @Binding var isShowingKeypadView: Bool
  @ObservedObject var viewModel: CallModel
  @State private var orientation = UIDevice.current.orientation
  
  private let paddingPortrait: CGFloat = 30
  private let paddingLandscape: CGFloat = 10
  private let phoneIcon = "phone.down.fill"
  private let hideKeypadIcon = "Hide Keypad"
  private let endCallAccessibilityIdentifier = "EndCall"
  private let hideKeypadAccessibilityIdentifier = "HideKeypad"
  private let buttonRows: [[[String]]] = [
    [["1", ""], ["2", "ABC"], ["3", "DEF"]],
    [["4", "GHI"], ["5", "JKL"], ["6", "MNO"]],
    [["7", "PQRS"], ["8", "TUV"], ["9", "WXYZ"]],
    [["*", ""], ["0", "+"], ["#", ""]],
  ]
  
  var body: some View {
    if isShowingKeypadView && viewModel.isCalling {
      Color.black.edgesIgnoringSafeArea(.all)
      if UIDevice.current.userInterfaceIdiom == .phone && orientation.isLandscape {
        //Landscape layout
        HStack {
          VStack {
            Spacer()
            HStack {
              KeypadButton(title: nil, subTitle: nil, imageName: phoneIcon) {
                viewModel.endCall()
              }.buttonStyle(KeypadButtonStyle())
                .accessibilityIdentifier(endCallAccessibilityIdentifier)
              Spacer()
              Button(action: {
                isShowingKeypadView.toggle()
              }) {
                Text(hideKeypadIcon).font(.subheadline)
              }.buttonStyle(KeypadButtonStyle())
                .foregroundColor(.white)
                .accessibilityIdentifier(hideKeypadAccessibilityIdentifier)
              Spacer()
            }
          }
          Spacer()
          VStack(alignment: .trailing, spacing: paddingLandscape) {
            Spacer()
            ForEach(buttonRows, id: \.self) { row in
              HStack(spacing: paddingLandscape) {
                ForEach(row, id: \.self) { digits in
                  VStack{
                    KeypadButton(title: digits[0], subTitle: digits[1], imageName: nil) {
                      viewModel.call?.sendDTMFTones(digits[0])
                    }.accessibilityIdentifier("digit\(digits[0])")
                  }
                }
              }
            }
          }.padding(0)
        }.padding()
         .detectOrientation($orientation)
      } else {
        //Portrait layout
        VStack(alignment: .trailing, spacing: paddingPortrait) {
          Spacer()
          ForEach(buttonRows, id: \.self) { row in
            HStack(spacing: paddingPortrait) {
              ForEach(row, id: \.self) { digits in
                VStack{
                  KeypadButton(title: digits[0], subTitle: digits[1], imageName: nil) {
                    viewModel.call?.sendDTMFTones(digits[0])
                  }.accessibilityIdentifier("digit\(digits[0])")
                }
              }
            }
          }
          Spacer()
          HStack(alignment: .center, spacing: 10){
            KeypadButton(title: nil, subTitle: nil, imageName: phoneIcon) {
              viewModel.endCall()
            }.buttonStyle(KeypadButtonStyle())
              .accessibilityIdentifier(endCallAccessibilityIdentifier)
            Button(action: {
              isShowingKeypadView.toggle()
            }) {
              Text(hideKeypadIcon).font(.subheadline)
            }.buttonStyle(KeypadButtonStyle())
              .foregroundColor(.white)
              .accessibilityIdentifier(hideKeypadAccessibilityIdentifier)
          }
        }
        .padding()
        .detectOrientation($orientation)
      }
    }
  }
}

struct KeypadButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.all, 0)
      .scaleEffect(configuration.isPressed ? 1.2 : 1)
      .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
  }
}

struct KeypadView_Previews: PreviewProvider {
  static var previews: some View {
    KeypadView(isShowingKeypadView: .constant(true), viewModel: CallModel())
  }
}

struct KeypadButton: View {
  let title: String?
  let subTitle: String?
  let imageName: String? //Image name
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      VStack(alignment: .center, spacing: 0) {
        if let title = title {
          Text(title)
            .font(.title)
            .foregroundColor(.white)
        }
        if let subtitle = subTitle {
          Text(subtitle)
            .font(.caption)
            .foregroundColor(.white)
        }
        if let image = imageName {
          Image(systemName: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .padding(30)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .overlay(
              Circle()
                .stroke(Color.white, lineWidth: 0)
            )
        }
      }
      .padding()
      .frame(width: 80, height: 80)
      .background(Circle().foregroundColor(.gray))
    }
  }
}

struct DetectOrientation: ViewModifier {
  @Binding var orientation: UIDeviceOrientation
  func body(content: Content) -> some View {
    content
      .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
        orientation = UIDevice.current.orientation
      }
  }
}

extension View {
  func detectOrientation(_ orientation: Binding<UIDeviceOrientation>) -> some View {
    modifier(DetectOrientation(orientation: orientation))
  }
}
