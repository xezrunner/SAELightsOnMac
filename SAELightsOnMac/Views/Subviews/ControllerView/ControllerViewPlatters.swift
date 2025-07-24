// SAELightsOnMac::ControllerViewPlatters.swift - 24/07/2025
import SwiftUI

extension ControllerView {
    var settingsPlatters: some View {
        Group {
            let binding_meshSettingsPlatter = Binding(get: { globalState.useIntelligenceLightView ? 0.0 : 1.0 }, set: { _ in })
            IntelligenceUIPlatterView(exteriorLightFraction: binding_meshSettingsPlatter,
                                      interiorLightFraction: binding_meshSettingsPlatter) {
                ControllerMeshGradientSettingsView()
            }
            
            let binding_lightSettingsPlatters  = Binding(
                get: { edgeLightActiveStatus == 0.0 ? 0.0 : Double(max(0.0, (edgeLightWindowSettingsTarget.volumeLevel + 80)) / 130.0) },
                set: { _ in })
            IntelligenceUIPlatterView(exteriorLightFraction: binding_lightSettingsPlatters,
                                      interiorLightFraction: binding_lightSettingsPlatters) {
                ControllerEdgeLightSettingsView(settings: $edgeLightWindowSettingsTarget)
            }
            
            let binding_windowSettingsPlatters = Binding(get: { 0.0 }, set: { _ in })
            IntelligenceUIPlatterView(exteriorLightFraction: binding_windowSettingsPlatters,
                                      interiorLightFraction: binding_windowSettingsPlatters) {
                ControllerEdgeLightWindowSettingsView(settings: $edgeLightWindowSettingsTarget)
            }
        }
    }
    
    var controlsPlatter: some View {
        VStack(spacing: 12) {
            Button("Set mode") {
                if (edgeLightWindow == nil) { createEdgeLightWindow() }
                
                edgeLightWindow?.setBurstStartPosition(value: Int(edgeLightWindowSettingsTarget.burstStartPosition))
                edgeLightWindow?.setMode              (value: Int(edgeLightWindowSettingsTarget.mode))
                edgeLightActiveStatus = edgeLightWindowSettingsTarget.mode
            }
            .buttonStyle(FullWidthButtonStyle(backgroundColor: .accentColor, foregroundColor: .white))
            
            Button("Destroy") {
                guard let instance = EdgeLightWindow.instance else { return }
                
                instance.setMode(value: 0)
                Task {
                    try! await Task.sleep(for: .seconds(1))
                    instance.destroy_immediate()
                    edgeLightWindow = nil
                }
            }
            .buttonStyle(FullWidthButtonStyle(backgroundColor: .red, foregroundColor: .white))
            
            Button("Destroy & recreate") {
                guard let instance = EdgeLightWindow.instance else { return }
                
                instance.setMode(value: 0)
                Task {
                    try! await Task.sleep(for: .seconds(1))
                    edgeLightWindow = EdgeLightWindow(settings: edgeLightWindowSettingsTarget)
                }
            }
            .buttonStyle(FullWidthButtonStyle())
        }.padding()
    }    
}
