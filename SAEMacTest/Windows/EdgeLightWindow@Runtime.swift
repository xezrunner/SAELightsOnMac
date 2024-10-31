import SwiftUI
import AVFAudio

// TODO: static not ideal!
struct EdgeLightWindow {
    static var window: NSWindow? = nil
    static var layer:  CALayer?  = nil
    
    static var audioPlayer = try! AVAudioPlayer(data: NSDataAsset(name: "jbl_begin_sae")!.data)
    
    @MainActor static func createEdgeLightWindow(isWindowed: Bool = false) -> NSWindow? {
        // MARK: Initialize window class/instance
        guard let windowClass: AnyClass = NSClassFromString("SiriUIEdgeLightWindow") else { return nil }
        print("SiriUIEdgeLightWindow class: \(windowClass.debugDescription())")
        
        guard let windowInstance = windowClass.alloc() as? NSWindow else { print("Could not allocate inst"); return nil }
        print("  - SiriUIEdgeLightWindow instance: \(windowInstance.debugDescription)")
        
        callToObjC(windowInstance, "init")
        self.window = windowInstance
        
        // MARK: Set up window
        windowInstance.title = "Edge light window"
        windowInstance.titleVisibility = .hidden
        windowInstance.collectionBehavior = NSWindow.CollectionBehavior.managed // Restore spaces / mission ctrl
        _ = setWindowed(value: isWindowed)
        
        windowInstance.colorSpace = NSColorSpace.displayP3
        windowInstance.setDynamicDepthLimit(true)
        
        // MARK: Set up layer
        let layer = windowInstance.value(forKey: "_edgeLightLayer") as! CALayer
        self.layer = layer
        
        setMultiplyCompositing(value: true)
        
        // MARK: Invoke effects
        //setBurstStartPosition(value: 1)
    #if false
        callToObjC(windowInstance, "setMode:", 1)
        //layer.perform(NSSelectorFromString("animateOn"))
        //layer.perform(NSSelectorFromString("setPaused:"), with: false)
        
        callToObjC(layer, "updateVolumeInputdB:", Float(50.0))
    #endif
        
        // MARK: Set up custom content
        
        let edgeLightView = windowInstance.value(forKey: "_edgeLightView") as! NSView
        
        // Reorder and create:
        // We want the effect to stay on top:
        withExtendedLifetime(edgeLightView) {
            edgeLightView.removeFromSuperview()
            edgeLightView.autoresizingMask = NSView.AutoresizingMask([NSView.AutoresizingMask.width, NSView.AutoresizingMask.height])
            
            windowInstance.contentView = NSView()
            
            // Create our custom view:
            let backingView = BackingView().environmentObject(GLOBAL_globalState)
            let backingViewHost = HostingView(rootView: backingView, frame: edgeLightView.frame)
            windowInstance.contentView!.addSubview(backingViewHost)
            
            windowInstance.contentView!.addSubview(edgeLightView)
        }
        
        
        
        return windowInstance
    }
    
    static func setWindowed(value: Bool) -> Bool {
        guard let window = window else {
            print("\(#function): no window!")
            return false
        }
        
        if value {
            // Restore mouse events:
            window.acceptsMouseMovedEvents = true
            window.ignoresMouseEvents      = false
            
            // Restore titlebar/window behaviors:
            window.styleMask = [.titled, .resizable, .closable, .miniaturizable, .fullSizeContentView]
            window.level = .normal
            window.hasShadow = true
            
            // Hide window controls:
            window.titlebarAppearsTransparent = true
            window.standardWindowButton(.closeButton)?.isHidden = true
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            
            // Set window visuals:
            window.setFrame(NSRect(x: (window.screen!.frame.width-1280)/2, y: (window.screen!.frame.height-720)/2, width: 1280, height: 720), display: true)
            window.backgroundColor = .black //NSColor.windowBackgroundColor
            
            print("Set edge light window to windowed!")
        } else {
            window.acceptsMouseMovedEvents = false
            window.ignoresMouseEvents      = true
            
            //inst.styleMask = [.hudWindow]
            window.setFrame(NSRect(x: 0, y: 0, width: window.screen!.frame.width, height: window.screen!.frame.height), display: true)
            
            window.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
            window.level = .popUpMenu // Above menubar (swizzled!)
            
            print("Set edge light window to fullscreen!")
        }
        
        return value
    }
    
    static func mode() -> Int {
        guard let window = window else {
            return -1
        }
        return window.value(forKey: "_mode") as! Int
    }
    
    static func setMode(value: Int) {
        guard let window = window else {
            print("\(#function) no window!")
            return
        }
        
        if value == 1 {
            if mode() != 1 {
                audioPlayer.play()
            }
        }
        
        callToObjC(window, "setMode:", value)
    }
    
    static func setVolumeLevel(value: Float) {
        guard let layer = layer else {
            print("\(#function) no layer!")
            return
        }
        
        callToObjC(layer, "updateVolumeInputdB:", value)
    }
    
    static func setMultiplyCompositing(value: Bool) {
        layer?.compositingFilter = value ? CIFilter.multiplyCompositing() : nil
    }
    
    static func setBurstStartPosition(value: Int) {
        guard let layer = layer else {
            print("\(#function) no layer!")
            return
        }
        
        callToObjC(layer, "setBurstStartPosition:", value)
    }
}
