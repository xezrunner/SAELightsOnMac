import SwiftUI

struct BackingView: View {
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        ZStack {
            if !globalState.useIntelligenceLightView {
                MeshGradient(width: 2, height: 2,
                             points: [
                                [0, 0], [1, 0],
                                [0, 1], [1, 1]
                             ],
                             colors: globalState.meshColors)
            } else {
                IntelligenceLightView()
                    .ignoresSafeArea(.all)
                    .brightness(0.3)
                    .contrast(2)
            }
            
            
            
            //Text("MainView").monospaced()
        }
        .ignoresSafeArea(.all)
        .background(.clear)
    }
}

#Preview {
    BackingView()
        .environmentObject(GlobalState())
}

struct IntelligenceLightView: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        let window: NSWindow = NSApplication.shared.windows.first!
        
        let c: AnyClass = NSClassFromString("NSIntelligenceUILightView")!
        let inst = c.alloc() as! NSView
        callToObjC(inst, "initWithFrame:", window.frame)
        
        let layer = inst.value(forKey: "_layer") as! CALayer
        layer.wantsExtendedDynamicRangeContent = true
        
        
        
        return inst
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}
