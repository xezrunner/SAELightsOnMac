import SwiftUI
import AVFoundation

struct ControllerView: View {
    @EnvironmentObject var globalState: GlobalState
    
    let whiteOrBlackColor: some View = Color(NSColor.textColor).colorInvert()
    
    @State var borderFraction        = 1.0
    @State var exteriorLightFraction = 1.0
    @State var interiorLightFraction = 1.0
    
    @State var meshSettings_fraction = 1.0
    
    var body: some View {
        ZStack {
            Color.primary.colorInvert().opacity(0.45)
                .background(.regularMaterial)
            
            VStack(alignment: .leading, spacing: 20) {
                Spacer().frame(height: 30) // 15?
                    .background(.red)
                
                let binding_meshSettingsPlatter = Binding(get: { globalState.useIntelligenceLightView ? 0.0 : 1.0 }, set: { _ in })
                IntelligenceUIPlatterView(exteriorLightFraction: binding_meshSettingsPlatter,
                                          interiorLightFraction: binding_meshSettingsPlatter) {
                    ControllerMeshGradientSettingsView()
                }
                
                let binding_generalSettingsPlatters = Binding(get: { 0.0 }, set: { _ in })
                IntelligenceUIPlatterView(exteriorLightFraction: binding_generalSettingsPlatters,
                                          interiorLightFraction: binding_generalSettingsPlatters) {
                    ControllerEdgeLightSettingsView()
                }
                
                IntelligenceUIPlatterView(exteriorLightFraction: binding_generalSettingsPlatters,
                                          interiorLightFraction: binding_generalSettingsPlatters) {
                    ControllerEdgeLightWindowSettingsView()
                }
                
              Button("Set mode") {
                    EdgeLightWindow.setBurstStartPosition(value: Int(globalState.burstStartPosition))
                    EdgeLightWindow.setMode(value: Int(globalState.modeValue))
                }
                .padding()
                .buttonStyle(FullWidthButtonStyle(backgroundColor: .accentColor, foregroundColor: .white))
            }
            .padding(32)
        }
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil { return }
            let _ = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: keyDownEvent)
            let window = NSApplication.shared.windows.first!
            print(window)
        }
        .ignoresSafeArea(.all)
    }
    
    func keyDownEvent(event: NSEvent) -> NSEvent? {
        if event.keyCode == 1 {
            EdgeLightWindow.setBurstStartPosition(value: Int(globalState.burstStartPosition))
            EdgeLightWindow.setMode(value: Int(globalState.modeValue))
            return nil
        }
        
        return event
    }
}

#Preview {
    @Previewable @State var globalState = GlobalState()
    
    ControllerView()
        .environmentObject(globalState)
        .frame(width: 450)
}
