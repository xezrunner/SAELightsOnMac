//
//  BasicColorPicker.swift
//  SAEMacTest
//
//  Created by Sebastian Kassai on 28/10/2024.
//

import SwiftUI

struct XZColorPicker: View {
    @State private var tapped = false
    
    @Binding var color: Color
    
    var body: some View {
        ColorPicker("", selection: $color)
            .overlay {
                ZStack {
                    Rectangle().fill(color)
                        
                    Rectangle().fill(.black)
                        .opacity(tapped ? 0.15 : 0)
                }
                .clipShape(.rect(cornerRadius: 4))
                .allowsHitTesting(false)
            }
            .onLongPressGesture(perform: { }, onPressingChanged: { change in tapped = change; })
    }
}

#Preview {
    XZColorPicker(color: .constant(.blue))
}
