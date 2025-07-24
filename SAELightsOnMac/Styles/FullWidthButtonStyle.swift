//
//  FullWidthButtonStyle.swift
//  SAELightsOnMac
//
//  Created by Sebastian Kassai on 28/10/2024.
//


import SwiftUI

struct FullWidthButtonStyle: ButtonStyle {
    @State var backgroundColor: Color = Color(NSColor.secondarySystemFill)
    @State var foregroundColor: Color = .primary
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .medium))
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(
                backgroundColor.opacity(configuration.isPressed ? 0.70 : 1)
            )
            .foregroundStyle(
                foregroundColor.opacity(configuration.isPressed ? 0.70 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    Button("Test button") { }
        .buttonStyle(FullWidthButtonStyle())
        .padding()
}
