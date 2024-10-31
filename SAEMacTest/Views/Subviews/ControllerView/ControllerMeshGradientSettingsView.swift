//
//  TempView.swift
//  SAEMacTest
//
//  Created by Sebastian Kassai on 30/10/2024.
//
import SwiftUI

struct ControllerMeshGradientSettingsView: View {
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Mesh gradient settings").font(.title2)
                Spacer()
                withAnimation {
                    Toggle("", isOn: !$globalState.useIntelligenceLightView
                        .animation(.spring(Spring(duration: 0.6, bounce: 0.2)))
                    ).toggleStyle(.switch)
                }
            }
            .padding(.vertical, 4)
            
            Text("⚠️ The system intelligence light view will be used.")
                .frame(height: globalState.useIntelligenceLightView ? nil : 0, alignment: !globalState.useIntelligenceLightView ? .bottom : .top)
                .allowsHitTesting(globalState.useIntelligenceLightView)
                .blur(radius: globalState.useIntelligenceLightView ? 0 : 60)
                .opacity(globalState.useIntelligenceLightView ? 1 : 0)
            
            VStack(alignment: .leading) {
                Text("Colors:")
                
                LazyHGrid(rows: [GridItem(), GridItem()]) {
                    ForEach(0..<globalState.meshColors.count, id: \.self) { index in
                        XZColorPicker(color: $globalState.meshColors[index])
                            .padding(.horizontal, 2)
                            .padding(.vertical, 32)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding()
                
                VStack(alignment: .leading) {
                    XZSlider(valueName: "Mesh gradient brightness", value: $globalState.meshBrightness, range: -3...10)
                    XZSlider(valueName: "Mesh gradient contrast",   value: $globalState.meshContrast,   range: -3...10)
                }
            }
            .frame(height: !globalState.useIntelligenceLightView ? nil : 0, alignment: globalState.useIntelligenceLightView ? .bottom : .top)
            .allowsHitTesting(!globalState.useIntelligenceLightView)
            .opacity(!globalState.useIntelligenceLightView ? 1 : 0)
            .blur(radius: !globalState.useIntelligenceLightView ? 0 : 40)
            //.clipped()
        }
        .padding(24)
    }
}
