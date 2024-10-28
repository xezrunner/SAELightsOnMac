//
//  SAEMacTestApp.swift
//  SAEMacTest
//
//  Created by Sebastian Kassai on 25/10/2024.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

@main
struct SAEMacTestApp: App {
    var isWindowed = true
    
    public static var globalState = GlobalState()
    
    init() {
        loadDependencies()
        doSwizzles()
        
        _ = ControllerWindow.createControllerWindow()
        _ = EdgeLightWindow.createEdgeLightWindow(isWindowed: false)
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
        }
    }
}
