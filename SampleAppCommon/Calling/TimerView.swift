//
//  TimerView.swift
//
//

import Foundation
import SwiftUI

struct TimerView: View {
  @ObservedObject var viewModel: CallModel
  
  var body: some View {
    Text(timerString)
      .font(.headline)
      .foregroundColor(.white)
  }
  
  var timerString: String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    
    return formatter.string(from: viewModel.elapsedTime) ?? "00:00:00"
  }
}
