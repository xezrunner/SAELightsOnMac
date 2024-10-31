//
//  ControllerEdgeLightSettingsView.swift
//  SAEMacTest
//
//  Created by Sebastian Kassai on 30/10/2024.
//
import SwiftUI

struct ControllerEdgeLightSettingsView: View {
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Edge light properties").font(.title2)
                Spacer()
            }
            .padding(.vertical, 4)
            
            VStack(alignment: .leading) {
                XZSlider(valueName: "Volume level", value: $globalState.volumeLevel, range: -130...130)
                    .onChange(of: globalState.volumeLevel) { EdgeLightWindow.setVolumeLevel(value: globalState.volumeLevel) }
                
                XZSlider(precision: 0, valueName: "Burst start position index",
                         value: $globalState.burstStartPosition, range: 0...7, step: 1)
                
                XZSlider(precision: 0, valueName: "Mode",
                         value: $globalState.modeValue, range: 0...5, step: 1)
            }
        }
        .padding(24)
    }
}
