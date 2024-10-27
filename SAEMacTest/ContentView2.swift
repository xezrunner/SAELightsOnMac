//
//  TestView.swift
//  SAEMacTest
//
//  Created by Sebastian Kassai on 27/10/2024.
//

import SwiftUI

struct ContentView2: View {
    var body: some View {
        ZStack {
            TestView()
                .padding()
        }
        .onAppear() {
            let window = NSApplication.shared.windows.first
            
            window?.isOpaque = false
            window?.hasShadow = false
            window?.backgroundColor = .black.withAlphaComponent(0.8)
        }
    }
}

struct TestViewController: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> some NSViewController {
        let window: NSWindow = NSApplication.shared.windows.first!
        
        let c: AnyClass = NSClassFromString("AFUISiriViewController")!
        let inst = c.alloc() as! NSViewController
        //inst.addTrackingArea(NSTrackingArea(rect: window.frame, options: [.activeAlways, .cursorUpdate], owner: self, userInfo: nil))
        inst.perform(NSSelectorFromString("init"))
        inst.perform(NSSelectorFromString("loadView"))
        //inst.perform(NSSelectorFromString("viewDidLoad"))
        inst.perform(NSSelectorFromString("preheat"))
        
        let c2: AnyClass = NSClassFromString("SiriUISiriView")!
        let inst2 = c2.alloc() as! NSView
        //inst.addTrackingArea(NSTrackingArea(rect: window.frame, options: [.activeAlways, .cursorUpdate], owner: self, userInfo: nil))
        inst2.perform(NSSelectorFromString("initWithFrame:"), with: window.frame)
        
        let isVisible = inst.perform(NSSelectorFromString("isVisible"))
        print(isVisible)
        
        //r.perform(NSSelectorFromString("updateInputPowerLevel:"), with: 40.0)
        
        return inst
    }
    
    func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {
        
    }
}

struct TestView: NSViewRepresentable {
    func test() {
        
    }
    
    func makeNSView(context: Context) -> some NSView {
        let window: NSWindow = NSApplication.shared.windows.first!
        
        let c: AnyClass = NSClassFromString("SiriUISiriStatusView")!
        let inst = c.alloc() as! NSView
        inst.perform(NSSelectorFromString("init"), with: window.frame)
        
        // orb:
        
        let c2: AnyClass = NSClassFromString("SiriUIOrbView")!
        let inst2 = c2.alloc() as! NSView
        inst2.perform(NSSelectorFromString("init"))
        
        inst.perform(NSSelectorFromString("setOrbView:"), with: inst2)
        
        // edge light window:
        
        let c3: AnyClass = NSClassFromString("SiriUIEdgeLightWindow")!
        let inst3 = c3.alloc() as! NSWindow
        inst3.perform(NSSelectorFromString("init"))
        inst3.setFrame(NSRect(x: 0, y: 0, width: 1920, height: 1080), display: true)
        inst3.level = .popUpMenu // Above menubar (swizzled!)
        
        let layer = inst3.value(forKey: "_edgeLightLayer") as! NSObject
        
        print("Preparing layer...")
        
        print("Setting screen...")
        let mainScreen = NSScreen.main!
        layer.setValue(mainScreen, forKey: "_screen")
        layer.perform(NSSelectorFromString("setScreen:"), with: mainScreen)
        
        let screen = layer.perform(NSSelectorFromString("_getScreen"))
        print("  - _getScreen result: \(screen.debugDescription)")
        
        //try! await Task.sleep(for: .seconds(1))
        
        layer.perform(NSSelectorFromString("setBurstStartPosition:"), with: CGPoint(x: 0, y: 0))
        layer.perform(NSSelectorFromString("setBurstOpacity:"), with: 1.0)
        layer.perform(NSSelectorFromString("setFlameScale:"), with: 1.0)
        
        inst.perform(NSSelectorFromString("setEdgeLightWindow:"), with: inst3)
        
        //inst.setValue(0x4, forKey: "mode")
        inst.perform(NSSelectorFromString("setMode:"), with: NSNumber(integerLiteral: 0x2))
        var r = inst.perform(NSSelectorFromString("mode")).takeUnretainedValue()
        print(r)
        
        inst3.perform(NSSelectorFromString("setMode:"), with: 1)
        inst3.perform(NSSelectorFromString("setMode:"), with: 20)
        
        inst.perform(NSSelectorFromString("setMode:withAnimationCompletion:"), with: NSNumber(integerLiteral: 0x1), with: nil)
        inst.perform(NSSelectorFromString("_refreshInputModeIndicationUI"))
        
        return inst
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}
