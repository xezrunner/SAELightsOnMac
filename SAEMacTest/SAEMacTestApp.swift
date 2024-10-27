//
//  SAEMacTestApp.swift
//  SAEMacTest
//
//  Created by Sebastian Kassai on 25/10/2024.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

var GLOBAL_EdgeLightWindow: NSWindow? = nil

@main
struct SAEMacTestApp: App {
    init() {
        loadDependencies()
        doSwizzles()
        
        SAEMacTestApp.test()
    }
    
    static func test() {
        guard let c: AnyClass = NSClassFromString("SiriUIEdgeLightWindow") else { return }
        print("c: \(c)")
        
        guard let inst = c.alloc() as? NSWindow else { print("Could not allocate inst"); return }
        print("inst: \(inst)")
        
        inst.perform(NSSelectorFromString("init"))
        
        GLOBAL_EdgeLightWindow = inst
        
#if false
        guard let a: NSObject.Type = NSClassFromString("NSIntelligentLightRoot") as? NSObject.Type else { return }
        guard let b: AnyClass = NSClassFromString("NSIntelligentLightRootConfiguration") else { return }
        //guard let inst_a = a.alloc() as? NSObject else { print("Could not allocate inst"); return }
        guard let inst_b = b.alloc() as? NSObject else { print("Could not allocate inst"); return }
        
        let palette: [SwiftUI.Color] = [.red,.blue,.green,.yellow]
        inst_b.perform(NSSelectorFromString("initWithColorPalette:"), with: palette)
        let result = a.perform(NSSelectorFromString("rootForWindow:configuration:"), with: inst, with: inst_b).takeUnretainedValue()
        
        let lightLayer = result.value(forKey: "_lightLayer") as! NSObject
        
        let mainScreen = NSScreen.main!
        lightLayer.setValue(mainScreen, forKey: "_screen")
        lightLayer.perform(NSSelectorFromString("setScreen:"), with: mainScreen)
        lightLayer.perform(NSSelectorFromString("setPaused:"), with: false)
#endif
        
#if true
        // Restore mouse events:
        inst.acceptsMouseMovedEvents = true
        inst.ignoresMouseEvents      = false
        
        // Restore titlebar/window behaviors:
        inst.styleMask = [.titled, .resizable, .closable, .miniaturizable]
        inst.level = .normal
        
        // Set window visuals:
        inst.setFrame(NSRect(x: (1920-1280)/2, y: (1080-720)/2, width: 1280, height: 720), display: true)
        inst.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.8)
#else
        //inst.styleMask = [.hudWindow]
        inst.setFrame(NSRect(x: 0, y: 0, width: 1920, height: 1080), display: true)
        inst.level = .popUpMenu                                       // Above menubar (swizzled!)
#endif
        
        inst.collectionBehavior = NSWindow.CollectionBehavior.managed // Restore spaces / mission ctrl
        
        Task {
            let layer = inst.value(forKey: "_edgeLightLayer") as! CALayer
            
            print("Preparing layer...")
            
            print("Setting screen...")
            let mainScreen = NSScreen.main!
            layer.setValue(mainScreen, forKey: "_screen")
            layer.perform(NSSelectorFromString("setScreen:"), with: mainScreen)
            
            let screen = layer.perform(NSSelectorFromString("_getScreen"))
            print("  - _getScreen result: \(screen.debugDescription)")
            
            layer.compositingFilter = CIFilter.multiplyBlendMode()
            //layer.compositingFilter = CIFilter.linearDodgeBlendMode()
            //layer.backgroundColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
            
            // MARK: add test subview:
            let view = inst.value(forKey: "_edgeLightView") as! NSView
            let btn = NSButton(title: "Test", target: nil, action: nil)
            inst.contentView?.addSubview(btn, positioned: .below, relativeTo: view)
            
            // MARK: init the light layer
            
//            let lightViewC: AnyClass = NSClassFromString("_UIIntelligenceSystemLightView")!
//            let lightViewInst = lightViewC.alloc() as! NSView
            
            
            
            //            let lightLayerC: AnyClass = NSClassFromString("SUICIntelligentLightLayer")!
            //            let lightLayerInst = lightLayerC.alloc() as? NSObject
            //
            //            lightLayerInst?.perform(NSSelectorFromString("init"))
            
            //            lightLayerInst?.perform(NSSelectorFromString("initWithScreen:commandQueue:"), with: mainScreen, with: layer.value(forKey: "_commandQueue")!)
            //
            //            //lightLayerInst?.perform(NSSelectorFromString("setPaused:"), with: false)
            //            lightLayerInst?.setValue(mainScreen, forKey: "_screen")
            //            lightLayerInst?.perform(NSSelectorFromString("setScreen:"), with: mainScreen)
            //
            //            let displayLink = layer.value(forKey: "_displayLink")
            //            lightLayerInst?.perform(NSSelectorFromString("setDisplayLink:"), with: displayLink)
            //
            //            lightLayerInst?.setValue(mainScreen.frame, forKey: "_bounds")
            //            lightLayerInst?.perform(NSSelectorFromString("setBounds:"), with: mainScreen.frame)
            //
            //            lightLayerInst?.perform(NSSelectorFromString("_loadMetalState"))
            //
            //            let lightLayerCT = NSClassFromString("SUICIntelligentLightLayer") as! NSObject.Type
            //            lightLayerCT.perform(NSSelectorFromString("prewarm"))
            
            //var palette: [NSColor] = [.red, .yellow]
            //lightLayerInst?.setValue(UnsafeRawPointer(&palette), forKey: "_colorPalette")
            //lightLayerInst?.perform(NSSelectorFromString("setColorPalette:"), with: 0x1f4)
            //lightLayerInst?.perform(NSSelectorFromString("_drawFrame"))
            
            //lightLayerInst?.setValue(, forKey: "_kCAFilterInputColorMatrix")
            
            //            layer.addSublayer(lightLayerInst! as! CALayer)
            //
            //            lightLayerInst?.perform(NSSelectorFromString("setPaused:"), with: false)
            
            
            // MARK: end
            
            //try! await Task.sleep(for: .seconds(1))
            
            layer.perform(NSSelectorFromString("setBurstStartPosition:"), with: CGPoint(x: 0, y: 0))
            layer.perform(NSSelectorFromString("setBurstOpacity:"), with: 1.0)
            layer.perform(NSSelectorFromString("setFlameScale:"), with: 1.0)
            
            inst.perform(NSSelectorFromString("setMode:"), with: 1)
            //layer.perform(NSSelectorFromString("animateOn"))
            //layer.perform(NSSelectorFromString("setPaused:"), with: false)
            
            try! await Task.sleep(for: .seconds(1))
            
            print("[+1s] Setting power level...")
            layer.perform(NSSelectorFromString("updateVolumeInputdB:"), with: -130.0) // borken
        }
    }
    
    func loadDependencies() {
        func load(_ path: String) {
            let       binaryName = String(path.components(separatedBy: "/").last ?? "")
            guard let handle     = dlopen(path, RTLD_NOW) else { fatalError("Could not get handle to \(binaryName))!")}
            print("Loaded handle to \(binaryName): \(handle.debugDescription)")
        }
        
        load("/System/Library/PrivateFrameworks/SiriUICore.framework/SiriUICore")
        load("/System/Library/PrivateFrameworks/SiriUI.framework/SiriUI")
    }
    
    func doSwizzles() {
        Swizzles.swizzle(targetClassName: "NSWindow", isTargetClassMethod: false, targetSelector: "canBecomeKeyWindow", isOverrideClassMethod: true)
        Swizzles.swizzle(targetClassName: "NSWindow", isTargetClassMethod: false, targetSelector: "constrainFrameRect:toScreen:", overrideSelector: #selector(Swizzles.constrainFrameRect))
    }
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            //ContentView2()
        }
    }
}
