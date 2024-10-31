import SwiftUI
import AVFoundation

struct ControllerView: View {
    @EnvironmentObject var globalState: GlobalState
    
    let whiteOrBlackColor: some View = Color(NSColor.textColor).colorInvert()
    
    @State private var borderFraction        = 1.0
    @State private var exteriorLightFraction = 1.0
    @State private var interiorLightFraction = 1.0
    
    @State private var meshSettings_fraction = 1.0
    
    @State var edgeLightWindow: EdgeLightWindow? = nil
    @State var edgeLightWindowSettingsTarget: EdgeLightWindowSettings = EdgeLightWindowSettings()
    
    // TODO: This is temporary/hacky, to make the platters respond with light effects only when the effect is active
    @State var edgeLightActiveStatus = 0.0
    
    init() {
        _edgeLightWindow = State(wrappedValue: EdgeLightWindow())
    }
    
    var body: some View {
        ZStack {
            Color.primary.colorInvert().opacity(0.45)
                .background(.regularMaterial)
            
            VStack(alignment: .leading, spacing: 20) {
                Spacer().frame(height: 30) // 15?
                    .background(.red)
                
                if edgeLightWindow == nil {
                    
                } else {
                    let edgeLightWindowInstance = edgeLightWindow! // Safe to unwrap here because of the condition block
                    
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
                    
                    VStack(spacing: 12) {
                        Button("Set mode") {
                            edgeLightWindowInstance.setBurstStartPosition(value: Int(edgeLightWindowSettingsTarget.burstStartPosition))
                            edgeLightWindowInstance.setMode              (value: Int(edgeLightWindowSettingsTarget.mode))
                            edgeLightActiveStatus = edgeLightWindowSettingsTarget.mode
                        }
                        .buttonStyle(FullWidthButtonStyle(backgroundColor: .accentColor, foregroundColor: .white))
                        
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
            .padding(32)
        }
        .onAppear {
            //edgeLightWindow = EdgeLightWindow()
            
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil { return }
            let _ = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: keyDownEvent)
            let window = NSApplication.shared.windows.first!
            print(window)
        }
        .ignoresSafeArea(.all)
    }
    
    func keyDownEvent(event: NSEvent) -> NSEvent? {
        if event.keyCode == 1 {
            EdgeLightWindow.instance?.setBurstStartPosition(value: Int(globalState.burstStartPosition))
            EdgeLightWindow.instance?.setMode(value: Int(globalState.modeValue))
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
