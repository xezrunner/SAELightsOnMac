//
//  IntelligenceUIPlatterView.swift
//  SAEMacTest
//
//  Created by Sebastian Kassai on 30/10/2024.
//
import SwiftUI

struct IntelligenceUIPlatterView<Content: View>: NSViewRepresentable {
    @EnvironmentObject var globalState: GlobalState
    
    @State var cornerRadius: Double = 26.0
    
    @Binding var borderFraction:        Double
    @Binding var exteriorLightFraction: Double
    @Binding var interiorLightFraction: Double
    
    var content: () -> Content = { EmptyView() as! Content } // This is whatever goes into IntelligenceUIPlatterView() { --> content <--  }
    
    @State private var platterInstance: NSView
    
    init(cornerRadius: Double = 26.0,
         borderFraction: Binding<Double> = .constant(1),
         exteriorLightFraction: Binding<Double> = .constant(1),
         interiorLightFraction: Binding<Double> = .constant(1),
         content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self._borderFraction = borderFraction
        self._exteriorLightFraction = exteriorLightFraction
        self._interiorLightFraction = interiorLightFraction
        self.content = content
        
        let c: AnyClass = NSClassFromString("_NSIntelligenceUIPlatterView")!
        let inst = c.alloc() as? NSView
        
        guard let inst = inst else { fatalError("Could not create platter instance!") }
        self._platterInstance = State(wrappedValue: inst)
        callToObjC(inst, "initWithFrame:", NSRect.zero)
    }
    
    func updateProperties() {
        callToObjC(platterInstance, "setCornerRadius:",           cornerRadius)
        callToObjC(platterInstance, "set_borderFraction:",        borderFraction)
        callToObjC(platterInstance, "set_exteriorLightFraction:", exteriorLightFraction)
        callToObjC(platterInstance, "set_interiorLightFraction:", interiorLightFraction)
    }
    
    func makeNSView(context: Context) -> some NSView {
        // Set content from above:
        let hostingContent = content()
            .padding(24)
            .frame(maxWidth: .infinity)
            //.onChange(of: borderFraction) { updateProperties() }
        
        let hostingView = NSHostingView(rootView: hostingContent)
        hostingView.layer?.cornerRadius = cornerRadius
        hostingView.clipsToBounds = true
        hostingView.translatesAutoresizingMaskIntoConstraints = false
//        hostingView.autoresizingMask = NSView.AutoresizingMask([NSView.AutoresizingMask.width, NSView.AutoresizingMask.height])
        
        platterInstance.addSubview(hostingView, positioned: .above, relativeTo: nil)
        
        // Ensure the platter resizes to fit its content by pinning hostingView to all edges of platterInstance:
        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: platterInstance.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: platterInstance.trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: platterInstance.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: platterInstance.bottomAnchor)
        ])
        
        updateProperties()
        
        //callToObjC(inst, "setIndicatesIndeterminateProgress:", true)
        //callToObjC(inst, "setUsesAudioLevels:", true)
        //_ = callToObjC_dynamic(inst, "setAudioLevel:", Float(40.0))
        
        return platterInstance
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        //print("updateNSView()... \(borderFraction)")
        updateProperties()
    }
}

