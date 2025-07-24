//
//  XZSlider.swift
//  SAELightsOnMac
//
//  Created by Sebastian Kassai on 29/10/2024.
//

import SwiftUI

struct XZSlider<T>: View where T : BinaryFloatingPoint, T.Stride : BinaryFloatingPoint {
    @State   var precision: Int = 3
    @State   var valueName: String
    @Binding var value: T
    
    @State var range: ClosedRange<T>
    @State var step:  T.Stride? = nil
    
    @State var haptics = true
    @State var hapticPattern = NSHapticFeedbackManager.FeedbackPattern.generic
    
    @State var format = FloatingPointFormatStyle<T>()
    
    var callback: (() -> Void)? = nil
    
    func handleSliderValueChange() {
        if !haptics    { return }
        if step == nil { return } // Don't do haptics with very tiny floating-point steps
        NSHapticFeedbackManager.defaultPerformer.perform(hapticPattern, performanceTime: .now)
    }
    
    func onChange() {
        handleSliderValueChange()
        callback?()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if !valueName.isEmpty {
                Text("\(valueName): \(String(value.formatted(format)))")
                    .fixedSize(horizontal: true, vertical: false)
                    .onAppear() {
                        format = format.precision(.fractionLength(precision))
                    }
            }
            
            if step == nil {
                Slider(value: $value, in: range)
                    .onChange(of: value) { onChange() }
            } else {
                Slider(value: $value, in: range, step: step!)
                    .onChange(of: value) { onChange() }
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    @Previewable @State var test: Double = 3
    XZSlider(valueName: "Test", value: $test, range: 1...3)
}
