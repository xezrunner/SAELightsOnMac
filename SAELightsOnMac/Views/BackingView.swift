import SwiftUI

struct BackingView: View {
    @EnvironmentObject var globalState: GlobalState
    
    @State private var viewSize: NSSize = .zero
    @State private var meshGradientImage: NSImage?
    
    @State private var timer: Timer?
    @State private var time: Double = 0
    
    var body: some View {
        ZStack {
            if let image = generateMeshGradientNSImage() {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFill()
                    .allowedDynamicRange(.high)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            if globalState.useIntelligenceLightView {
                IntelligenceLightView()
                    .ignoresSafeArea(.all)
                    .brightness(0.3)
                    .contrast(2)
            }
            
            //Text(viewSize.debugDescription)
        }
        .ignoresSafeArea(.all)
        .background(.clear)
        .onGeometryChange(for: NSSize.self) { geo in geo.size } action: { newSize in
            viewSize = newSize
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in time += 0.02 }
        }
    }
    
    func meshGradientView(size: CGSize) -> some View {
        return ZStack {
            MeshGradient(width: 2, height: 2,
                         points: [
                            [0, 0], [1, 0],
                            [0, 1], [1, 1]
                         ],
                         colors: globalState.meshColors, smoothsColors: true, colorSpace: .perceptual)
        }
        .frame(width: size.width, height: size.height)
        .rotationEffect(Angle(degrees: time * 15))
        .contrast(globalState.meshContrast)
        .brightness(globalState.meshBrightness)
        .scaleEffect(1.2)
        .allowedDynamicRange(.high)
    }
    
    func generateMeshGradientNSImage() -> NSImage? {
        let renderer = ImageRenderer(content: meshGradientView(size: viewSize))
        renderer.colorMode = .extendedLinear
        return renderer.nsImage
    }
}

#Preview {
    let globalState = GlobalState()
    
    BackingView()
        .frame(width: 1280/2, height: 720/2)
        .environmentObject(globalState)
        .onAppear() {
            globalState.useIntelligenceLightView = false
        }
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
