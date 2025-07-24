//
//  BasicColorPicker.swift
//  SAELightsOnMac
//
//  Created by Sebastian Kassai on 28/10/2024.
//

import SwiftUI

struct XZColorPicker: View {
    @Binding var color: Color
    
    @State private var tapped = false
    
    @State private var colorPickerSize: CGSize = .zero
           private let customOverlaySizeAdd    = 3.0
    
    var body: some View {
        ZStack {
            ColorPicker("", selection: $color)
                .onLongPressGesture(perform: { }, onPressingChanged: { change in tapped = change; })
                .onGeometryChange(for: CGSize.self) { geo in geo.size } action: { newSize in
                    colorPickerSize = newSize
                }
            
            ZStack {
                Rectangle().fill(color)
                    
                Rectangle().fill(.black)
                    .opacity(tapped ? 0.15 : 0)
            }
            .frame(width: colorPickerSize.width + customOverlaySizeAdd, height: colorPickerSize.height + customOverlaySizeAdd)
            .clipShape(.rect(cornerRadius: 4))
            .allowsHitTesting(false)
        }
    }
}

#Preview {
    VStack {
        XZColorPicker(color: .constant(.blue))
            .padding()
    }
}
