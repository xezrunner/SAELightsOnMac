import SwiftUI
import AVFAudio

struct EdgeLightWindowSettings {
    var isWindowed = false
    var isMultiplyCompositionEnabled = true
    
    // These are doubles/floats as they are used with Sliders in SwiftUI
    var mode = 1.0
    var volumeLevel: Float = -80.0
    var burstStartPosition: Double = 1.0
}

class EdgeLightWindow {
    static var instance: EdgeLightWindow? = nil
    
    var window: NSWindow? = nil
    var layer:  CALayer?  = nil
    
    // This is used to store the settings that the window *should* have, but doesn't necessarily have yet.
    // These settings are applied with setSettings(), normally from the controller view, or with the individual
    // setting functions (setMode(), setVolumeLevel(), etc)...
    @State var settingsTarget: EdgeLightWindowSettings = EdgeLightWindowSettings()
    
    static var audioPlayer = try! AVAudioPlayer(data: NSDataAsset(name: "jbl_begin_sae")?.data ?? Data())
    
    init() {
        // Destroy an existing instance:
        if let instance = EdgeLightWindow.instance {
            instance.destroy_immediate()
        }
        
        createEdgeLightWindow()
        EdgeLightWindow.instance = self
    }
    
    convenience init(settings: EdgeLightWindowSettings) {
        self.init()
        setSettings(settings)
    }
    
    private func createEdgeLightWindow(isWindowed: Bool = false) {
        // MARK: Initialize window class/instance
        guard let windowClass: AnyClass = NSClassFromString("SiriUIEdgeLightWindow") else { return }
        print("SiriUIEdgeLightWindow class: \(windowClass.debugDescription())")
        
        guard let windowInstance = windowClass.alloc() as? NSWindow else { print("Could not allocate inst"); return }
        print("  - SiriUIEdgeLightWindow instance: \(windowInstance.debugDescription)")
        
        callToObjC(windowInstance, "init")
        self.window = windowInstance
        
        // MARK: Set up window
        windowInstance.isReleasedWhenClosed = false // TODO: memory allocation, crashes when on
        windowInstance.title = "Edge light window"
        windowInstance.titleVisibility = .hidden
        windowInstance.collectionBehavior = NSWindow.CollectionBehavior.managed // Restore spaces / mission ctrl
        _ = setWindowed(value: isWindowed)
        
        windowInstance.colorSpace = NSColorSpace.displayP3
        windowInstance.setDynamicDepthLimit(true)
        
        
        // MARK: Set up layer
        let layer = windowInstance.value(forKey: "_edgeLightLayer") as! CALayer
        self.layer = layer
        
        // Set screen:
        // NOTE: This is explicitly required when SIP is on for some reason.
        callToObjC(layer, "setScreen:", windowInstance.screen!)
        layer.setValue(windowInstance.screen!, forKey: "_screen")
        
        setMultiplyCompositing(value: true)
        
        // MARK: Set up custom content
        let edgeLightView = windowInstance.value(forKey: "_edgeLightView") as! NSView
        
        // Reorder views and create:
        // We want the effect to stay on top, with the backing view behind it being masked:
        withExtendedLifetime(edgeLightView) {
            edgeLightView.removeFromSuperview()
            edgeLightView.autoresizingMask = NSView.AutoresizingMask([NSView.AutoresizingMask.width, NSView.AutoresizingMask.height])
            
            windowInstance.contentView = NSView()
            
            // Create our custom view:
            let backingView = BackingView().environmentObject(GlobalState.GLOBAL_instance)
            let backingViewHost = HostingView(rootView: backingView, frame: edgeLightView.frame)
            
            windowInstance.contentView!.addSubview(backingViewHost)
            windowInstance.contentView!.addSubview(edgeLightView)
        }
    }
    
    func setSettings(_ settings: EdgeLightWindowSettings? = nil) {
        let newSettings = settings ?? self.settingsTarget
        
        print("\(#function): \(newSettings)")
        
        _ = setWindowed(value: newSettings.isWindowed)
        setMultiplyCompositing(value: newSettings.isMultiplyCompositionEnabled)
        
        setVolumeLevel(value: newSettings.volumeLevel)
        setBurstStartPosition(value: Int(newSettings.burstStartPosition))
        
        if newSettings.mode != 0 { setMode(value: Int(newSettings.mode)) }
        
        self.settingsTarget = newSettings
    }
    
    func destroy() async {
        setMode(value: 0)
        try! await Task.sleep(for: .seconds(1))
        
        destroy_immediate()
    }
    
    func destroy_immediate() {
        guard let window = window else { return }
        //callToObjC(window, "_stopAndCleanup")
        window.orderOut(nil)
        window.close()
        //self.window = nil
        //self.layer = nil
    }
    
    func setWindowed(value: Bool) -> Bool {
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
        
        settingsTarget.isWindowed = value
        return value
    }
    
    var mode: Int {
        guard let window = window else {
            return -1
        }
        return window.value(forKey: "_mode") as! Int
    }
    
    func setMode(value: Int) {
        guard let window = window else {
            print("\(#function) no window!")
            return
        }
        
        if value == 1 {
            if mode != 1 {
                EdgeLightWindow.audioPlayer.play()
            }
        }
        
        callToObjC(window, "setMode:", value)
        settingsTarget.mode = Double(value)
    }
    
    func setVolumeLevel(value: Float) {
        guard let layer = layer else {
            print("\(#function) no layer!")
            return
        }
        
        callToObjC(layer, "updateVolumeInputdB:", value)
        settingsTarget.volumeLevel = value
    }
    
    func setMultiplyCompositing(value: Bool) {
        layer?.compositingFilter = value ? CIFilter.multiplyCompositing() : nil
        settingsTarget.isMultiplyCompositionEnabled = value
    }
    
    func setBurstStartPosition(value: Int) {
        guard let layer = layer else {
            print("\(#function) no layer!")
            return
        }
        
        callToObjC(layer, "setBurstStartPosition:", value)
        settingsTarget.burstStartPosition = Double(value)
    }
}
