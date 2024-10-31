//
//  Test.swift
//  SAEMacTest
//
//  Created by Sebastian Kassai on 30/10/2024.
//
import SwiftUI

struct Test: View {
    @Binding var border: Double
    
    init(border: Binding<Double> = .constant(1.0)) {
        self._border = border
    }
    
    var body: some View {
        VStack {
            XZSlider(valueName: "Border width (control)", value: $border, range: 0...10)
            
            Text("Border: \(border)")
                .border(.red, width: border)
                .padding()
        }
    }
}

#Preview {
    @Previewable @State var border: Double = 1.0
    
    VStack {
        XZSlider(valueName: "Border width (Preview)", value: $border, range: 0...10)
        
        Test()
    }
}
