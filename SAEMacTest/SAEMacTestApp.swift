//
//  SAEMacTestApp.swift
//  SAEMacTest
//
//  Created by Sebastian Kassai on 25/10/2024.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import AVKit

@main
struct SAEMacTestApp: App {
    var isWindowed = true
    
    var controllerWindow: NSWindow?
    
    init() {
        loadDependencies()
        doSwizzles()
        
#if true
        _ = EdgeLightWindow.createEdgeLightWindow(isWindowed: false)
        if !NSEvent.modifierFlags.contains(.shift) { controllerWindow = ControllerWindow.createControllerWindow() }
        else { let _ = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: keyDownEvent) }
#endif
    }
    
    func keyDownEvent(event: NSEvent) -> NSEvent {
        if event.keyCode == 1 {
            if controllerWindow == nil {
                EdgeLightWindow.setBurstStartPosition(value: Int(1))
                EdgeLightWindow.setVolumeLevel(value: Float(-25.0))
                EdgeLightWindow.setMode(value: Int(1))
            }
        }
        
        return event
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
            //BackingView()
            //TestView()
            
            //ControllerView()
            //    .environmentObject(GLOBAL_globalState)
        }
    }
}
