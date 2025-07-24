import SwiftUI

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
    
    func createEdgeLightWindow() {
        edgeLightWindow = EdgeLightWindow(settings: edgeLightWindowSettingsTarget)
    }
    
    var body: some View {
        ZStack {
            Color.primary.colorInvert().opacity(0.45)
                .background(.regularMaterial)
                .ignoresSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    settingsPlatters
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 48)
            }
            .safeAreaInset(edge: .bottom) {
                controlsPlatter
                    .padding(.horizontal, 24)
                    .background(.ultraThinMaterial, in: UnevenRoundedRectangle(cornerRadii: .init(topLeading: 24, bottomLeading: 0, bottomTrailing: 0, topTrailing: 24)))
            }
        }
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil { return }
            let _ = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: keyDownEvent)
        }
        .fixedSize(horizontal: true, vertical: false) // FIXME: this would let the window size be dynamic, but it also lags when it expands
        .navigationTitle("Edge light window controller")
        .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
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
