//
//  FullWidthButtonStyle.swift
//  SAELightsOnMac
//
//  Created by Sebastian Kassai on 28/10/2024.
//


import SwiftUI

struct FullWidthToggleStyle: ToggleStyle {
    let size: CGFloat = 24
    @State var tapped = false
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                ZStack {
                    Rectangle()
                        .fill(configuration.isOn ? Color.accentColor : Color(NSColor.tertiarySystemFill))
                        .frame(width: size, height: size)
                        .clipShape(.rect(cornerRadius: 8, style: .circular))
                        .opacity(tapped ? 0.75 : 1)
                    
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color(NSColor.controlBackgroundColor))
                        .opacity(configuration.isOn ? 1 : 0)
                }
                .animation(.easeOut.speed(2), value: configuration.isOn)
                
                configuration.label
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(perform: { }, onPressingChanged: { change in tapped = change })
    }
}

#Preview {
    @Previewable @State var isOn = true
    
    Toggle("Test toggle", isOn: $isOn)
        .toggleStyle(FullWidthToggleStyle())
        .padding()
}
