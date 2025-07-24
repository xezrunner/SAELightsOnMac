//
//  ControllerEdgeLightSettingsView.swift
//  SAELightsOnMac
//
//  Created by Sebastian Kassai on 30/10/2024.
//
import SwiftUI

struct ControllerEdgeLightSettingsView: View {
    @EnvironmentObject var globalState: GlobalState
    
    @Binding var settings: EdgeLightWindowSettings
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Edge light properties").font(.title2)
                Spacer()
            }
            .padding(.vertical, 4)
            
            VStack(alignment: .leading) {
                XZSlider(valueName: "Volume level", value: $settings.volumeLevel, range: -130...130)
                    .onChange(of: settings.volumeLevel) { EdgeLightWindow.instance?.setVolumeLevel(value: settings.volumeLevel) }
                
                XZSlider(precision: 0, valueName: "Burst start position index", value: $settings.burstStartPosition, range: 0...7, step: 1)
                .onChange(of: settings.burstStartPosition) {
                    if settings.mode == 0 { return }
                    _ = EdgeLightWindow(settings: settings)
                }
                
                XZSlider(precision: 0, valueName: "Mode", value: $settings.mode, range: 0...5, step: 1)
            }
        }
    }
}
