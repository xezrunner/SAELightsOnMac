import SwiftUI
import MetalKit
import QuartzCore
import Foundation

import Foundation

func dumpObjCObject(_ object: AnyObject) {
    // Get Mirror of the object
    let mirror = Mirror(reflecting: object)
    
    // Get the class name
    let cls = object_getClass(object)
    let className = type(of: object)
    print("\(className) {")
    
    // Reflect over all children (properties)
    for child in mirror.children {
        if let label = child.label {
            // Clean up the label by removing any internal markers
            let cleanLabel = label.replacingOccurrences(of: "_", with: "")
            print("\(cleanLabel): \(child.value)")
        }
    }
    
    // If it's an Objective-C object, we can also use the Objective-C runtime to get properties
    var count: UInt32 = 0
    if let properties = class_copyPropertyList(object_getClass(object), &count) {
        for i in 0..<Int(count) {
            let property = properties[i]
            let propName = String(cString: property_getName(property))
            if let value = object.value(forKey: propName) {
                print("\(propName): \(value)")
            }
        }
        free(properties)
    }
    
    var ivarCount: UInt32 = 0
    if let ivars = class_copyIvarList(cls, &ivarCount) {
        defer { free(ivars) }
        if ivarCount > 0 {
            print("instance variables:")
            for i in 0..<Int(ivarCount) {
                let ivar = ivars[i]
                let ivarName = String(cString: ivar_getName(ivar)!)
                let ivarValue = object.value(forKey: ivarName)
                print("    \(ivarName): \(ivarValue ?? "<?>")")
            }
        }
    }
}

// Extension to make it easier to call on any object
extension NSObject {
    func dumpProperties() {
        dumpObjCObject(self)
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            #if true
            MetalView()
                //.ignoresSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure full size
            #endif
            
            Button("Test") {
                //GLOBAL_SUICLayer!.setValue(true, forKey: "_shouldBurst")
                GLOBAL_SUICLayer?.perform(NSSelectorFromString("setBurstStartPosition:"), with: CGPoint(x: 20, y: 20))
                GLOBAL_SUICLayer?.perform(NSSelectorFromString("setBurstOpacity:"), with: 1.0)
                GLOBAL_SUICLayer?.perform(NSSelectorFromString("setFlameScale:"), with: 5.0)
                GLOBAL_SUICLayer?.perform(NSSelectorFromString("animateOn"))
                Task {
                    try! await Task.sleep(for: .seconds(1))
                    GLOBAL_SUICLayer?.perform(NSSelectorFromString("setPaused:"), with: false)
                }
                GLOBAL_SUICLayer?.perform(NSSelectorFromString("updateVolumeInputdB:"), with: CGFloat(-60.0))
                //GLOBAL_SUICLayer?.perform(NSSelectorFromString("setBounds:"), with: NSRect(x: 0, y: 0, width: 130, height: 130))
                GLOBAL_SUICLayer?.dumpProperties()
            }.buttonStyle(.borderedProminent)
        }
    }
}

var GLOBAL_SUICLayer: CAMetalLayer? = nil

class MetalLayerView: NSView {
    var metalLayer: CAMetalLayer
    
    init(device: MTLDevice) {
        self.metalLayer = CAMetalLayer()
        self.metalLayer.device = device
        self.metalLayer.pixelFormat = .bgra8Unorm
        self.metalLayer.framebufferOnly = true
        super.init(frame: .zero)
        self.layer = metalLayer
        self.wantsLayer = true
    }
    
    init(device: MTLDevice, layer: CAMetalLayer) {
        self.metalLayer = layer
        self.metalLayer.device = device
        self.metalLayer.pixelFormat = .rg16Float
        self.metalLayer.framebufferOnly = true
        super.init(frame: .zero)
        self.layer = metalLayer
        self.wantsLayer = true
        self.autoresizingMask = [.width, .height]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        //self.metalLayer.bounds = bounds
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.commit()
        updateLayerSize()
    }
    
    override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            updateLayerSize()
        }
    
    override func setFrameSize(_ newSize: NSSize) {
            super.setFrameSize(newSize)
            updateLayerSize()
        }
    
    func updateLayerSize() {
        return;
        
        if window == nil { return }
        
        //let s = NSScreen.main!
        
        //s2.setValue(window?.frame, forKey: "visibleFrame")
        //s2.setValue("window", forKey: "name")
        //s2.setValue(2.0, forKey: "backingScaleFactor")
        
        
        
            guard let window = window else { return }
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            // Update layer frame to match view bounds
//            metalLayer.frame = bounds
        //metalLayer.borderColor = CGColor.white
        metalLayer.wantsExtendedDynamicRangeContent = true
        //metalLayer.backgroundColor = CGColor.black
        metalLayer.isOpaque = false
        
        let s2 = NSScreen()
        s2.setValue(window.frame, forKey: "frame")
        GLOBAL_SUICLayer!.perform(NSSelectorFromString("setScreen:"), with: s2)
        GLOBAL_SUICLayer!.setValue(s2, forKey: "_screen")
            
            // Calculate drawable size based on screen scale factor
        //let scale = 1.0
//            metalLayer.drawableSize = CGSize(
//                width: bounds.width * scale,
//                height: bounds.height * scale
//            )
            
            // Ensure content scale is set correctly
            //metalLayer.contentsScale = scale
            
            CATransaction.commit()
        }
}

struct MetalView: NSViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func getSUICLayer(_ coordinator: Coordinator) -> CAMetalLayer? {
        guard let c: AnyClass = NSClassFromString("SUICEdgeLightMaskMetalLayer") else { return nil }
        print("c: \(c)")
        
        guard let inst = c.alloc() as? CAMetalLayer else { print("Could not allocate inst"); return nil }
        print("inst: \(inst)")
        
        inst.perform(NSSelectorFromString("initWithScreen:commandQueue:"), with: NSScreen.main!, with: coordinator.commandQueue)
        //inst.perform(NSSelectorFromString("setScreen:"), with: NSScreen.main!)
        //inst.setValue(NSScreen.main!, forKey: "_screen")
        
        GLOBAL_SUICLayer = inst
        
        return inst
    }
    
    func makeNSView(context: NSViewRepresentableContext<MetalView>) -> MetalLayerView {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }
        
        var layer = getSUICLayer(context.coordinator)
        print("layer: \(layer.debugDescription)")
        
        let view: MetalLayerView
        if layer == nil { view = MetalLayerView(device: device) }
        else { view = MetalLayerView(device: device, layer: layer!) }
        
        // Set initial frame to match screen size
        //if let screen = NSScreen.main {
        //    view.frame = screen.frame
        //}
        
        
        context.coordinator.metalView = view
        context.coordinator.startRenderLoop()
        
        return view
    }
    
    func updateNSView(_ nsView: MetalLayerView, context: NSViewRepresentableContext<MetalView>) {
        nsView.updateLayerSize()
    }
    
    class Coordinator: NSObject {
        var parent: MetalView
        var device: MTLDevice
        var commandQueue: MTLCommandQueue
        weak var metalView: MetalLayerView?
        var displayLink: CADisplayLink?
        
        init(_ parent: MetalView) {
            self.parent = parent
            guard let device = MTLCreateSystemDefaultDevice(),
                  let commandQueue = device.makeCommandQueue() else {
                fatalError("Failed to create Metal device or command queue")
            }
            self.device = device
            self.commandQueue = commandQueue
            super.init()
        }
        
        func startRenderLoop() {
            // Create a DisplayLink targeting the main RunLoop
            let displayLink = metalView?.displayLink(target: self, selector: #selector(displayLinkDidFire))
            displayLink!.add(to: .main, forMode: .common)
            self.displayLink = displayLink
        }
        
        @objc func displayLinkDidFire(_ displayLink: CADisplayLink) {
            render(displayLink)
        }
        
        func render(_ displayLink: CADisplayLink) {
            guard let metalView = metalView else { return }
            
            //metalView.metalLayer.perform(NSSelectorFromString("_drawFrame:"), with: displayLink)
            
            guard let drawable = metalView.metalLayer.nextDrawable() else {
                return
            }
            
            let renderPassDescriptor = MTLRenderPassDescriptor()
            renderPassDescriptor.colorAttachments[0].texture = drawable.texture
            renderPassDescriptor.colorAttachments[0].loadAction = .dontCare
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 1, alpha: 1)
            renderPassDescriptor.colorAttachments[0].storeAction = .store
            
            guard let commandBuffer = commandQueue.makeCommandBuffer(),
                  let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
                return
            }
            
            encoder.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
        
        deinit {
            displayLink?.invalidate()
        }
    }
}
