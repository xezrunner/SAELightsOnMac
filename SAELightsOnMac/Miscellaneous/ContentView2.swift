//
//  TestView.swift
//  SAELightsOnMac
//
//  Created by Sebastian Kassai on 27/10/2024.
//

import SwiftUI

struct ContentView2: View {
    var body: some View {
        ZStack {
//            TestViewController()
//                .padding()
        }
        .onAppear() {
            let window = NSApplication.shared.windows.first
            
            window?.isOpaque = false
            window?.hasShadow = false
            window?.backgroundColor = .black.withAlphaComponent(0.8)
        }
    }
}

//struct TestViewController: NSViewControllerRepresentable {
//    func makeNSViewController(context: Context) -> some NSViewController {
//        let window: NSWindow = NSApplication.shared.windows.first!
//        
//        let c: AnyClass = NSClassFromString("AFUISiriViewController")!
//        let inst = c.alloc() as! NSViewController
//        //inst.addTrackingArea(NSTrackingArea(rect: window.frame, options: [.activeAlways, .cursorUpdate], owner: self, userInfo: nil))
//        inst.perform(NSSelectorFromString("init"))
//        inst.perform(NSSelectorFromString("loadView"))
//        //inst.perform(NSSelectorFromString("viewDidLoad"))
//        inst.perform(NSSelectorFromString("preheat"))
//        
//        let c2: AnyClass = NSClassFromString("SiriUISiriView")!
//        let inst2 = c2.alloc() as! NSView
//        //inst.addTrackingArea(NSTrackingArea(rect: window.frame, options: [.activeAlways, .cursorUpdate], owner: self, userInfo: nil))
//        inst2.perform(NSSelectorFromString("initWithFrame:"), with: window.frame)
//        
//        let isVisible = inst.perform(NSSelectorFromString("isVisible"))
//        print(isVisible)
//        
//        //r.perform(NSSelectorFromString("updateInputPowerLevel:"), with: 40.0)
//        
//        return inst
//    }
//    
//    func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {
//        
//    }
//}

//struct TestView: NSViewRepresentable {
//    func test() {
//        
//    }
//    
//    func makeNSView(context: Context) -> some NSView {
//        let window: NSWindow = NSApplication.shared.windows.first!
//        
//        let c: AnyClass = NSClassFromString("SiriSharedUIPlatterGlowView")!
//        let inst = c.alloc() as! NSView
//        callToObjC(inst, "initWithFrame:", window.frame)
//        
//        return inst
//    }
//    
//    func updateNSView(_ nsView: NSViewType, context: Context) {
//        
//    }
//}
