//
//  ControllerEdgeLightWindowSettingsView.swift
//  SAEMacTest
//
//  Created by Sebastian Kassai on 30/10/2024.
//
import SwiftUI

struct ControllerEdgeLightWindowSettingsView: View {
    @EnvironmentObject var globalState: GlobalState
    
    @State var multiplyCompositionState: Bool? = nil
    @State var windowedModeState: Bool? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            //Toggle("Enable intelligence light view (macOS SAE)", isOn: $globalState.useIntelligenceLightView)
//            Text("\(globalState.useIntelligenceLightView ? "The system intelligence light view will be used." : "A custom mesh gradient view will be used.")"
//            ).padding(6)
            
            Toggle("\(multiplyCompositionState ?? false ? "" : "")Enable multiply blending composition", isOn:
                    Binding(
                        get: { EdgeLightWindow.layer?.compositingFilter != nil },
                        set: { value in
                            EdgeLightWindow.layer?.compositingFilter = (value ? CIFilter.multiplyCompositing() : nil)
                            multiplyCompositionState = EdgeLightWindow.layer?.compositingFilter != nil
                        }
                    )
            )
            
            Toggle("\(windowedModeState ?? false ? "" : "")Enable windowed mode", isOn:
                    Binding(
                        get: { windowedModeState == nil ? EdgeLightWindow.window?.hasShadow ?? false : windowedModeState! },
                        set: { value in
                            windowedModeState = EdgeLightWindow.setWindowed(value: value)
                        }
                    )
            )
        }
        .padding(24)
        .toggleStyle(FullWidthToggleStyle())
    }
}
