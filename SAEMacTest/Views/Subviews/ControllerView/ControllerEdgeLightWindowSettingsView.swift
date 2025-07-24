//
//  ControllerEdgeLightWindowSettingsView.swift
//  SAEMacTest
//
//  Created by Sebastian Kassai on 30/10/2024.
//
import SwiftUI

struct ControllerEdgeLightWindowSettingsView: View {
    @EnvironmentObject var globalState: GlobalState
    
    @Binding var settings: EdgeLightWindowSettings
    
    var body: some View {
        VStack(alignment: .leading) {
            //Toggle("Enable intelligence light view (macOS SAE)", isOn: $globalState.useIntelligenceLightView)
//            Text("\(globalState.useIntelligenceLightView ? "The system intelligence light view will be used." : "A custom mesh gradient view will be used.")"
//            ).padding(6)
            
            Toggle("Enable multiply blending composition", isOn: $settings.isMultiplyCompositionEnabled)
                .onChange(of: settings.isMultiplyCompositionEnabled) {
                    EdgeLightWindow.instance?.setMultiplyCompositing(value: settings.isMultiplyCompositionEnabled)
                }
            
            Toggle("Enable windowed mode", isOn: $settings.isWindowed)
                .onChange(of: settings.isWindowed) {
                    _ = EdgeLightWindow.instance?.setWindowed(value: settings.isWindowed)
                    print(settings.isWindowed)
                }
        }
        .toggleStyle(FullWidthToggleStyle())
    }
}
