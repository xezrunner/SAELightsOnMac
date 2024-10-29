import SwiftUI

struct TestView: View{
    var body: some View {
        ZStack {
            Color(NSColor.windowBackgroundColor)
//            IntelligenceLightView()
//                .overlay {
//                    Color.clear.overlay(.ultraThickMaterial)
//                }
//                .opacity(0.1)
            
            VStack {
                IntelligenceUIPlatterView {
                    VStack(alignment: .leading) {
                        Text("Here's some information: ").font(.title2)
                        Text("The information goes here...")
                        Text("There could be a bunch of other information here...")
                    }
                    .padding(24)
//                    .background {
//                        ZStack {
//                            Image(.example)
//                                .resizable()
//                                .scaledToFill()
//                            Color.black.opacity(0.35)
//                        }
//                    }
                    .clipShape(.rect(cornerRadius: 26.0))
                }
                IntelligenceUITextFieldView()
                    .frame(maxWidth: 350)
                    .padding()
            }
            .padding()
            
        }
    }
}

#Preview {
    TestView()
}

struct IntelligenceUITextFieldView: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
//        let window: NSWindow = NSApplication.shared.windows.first!
        
        let c: AnyClass = NSClassFromString("_TtCO6AppKit14IntelligenceUI15PromptEntryView")!
        let inst = c.alloc() as! NSView
        callToObjC(inst, "initWithFrame:", NSRect.zero)
        
        return inst
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {}
}


struct IntelligenceUIPlatterView<Content: View>: NSViewRepresentable {
    @ViewBuilder let content: Content // This is whatever goes into IntelligenceUIPlatterView { --> content <--  }
    
    func makeNSView(context: Context) -> some NSView {
//        let window: NSWindow = NSApplication.shared.windows.first!
        
        let c: AnyClass = NSClassFromString("_NSIntelligenceUIPlatterView")!
        let inst = c.alloc() as! NSView
        callToObjC(inst, "initWithFrame:", NSRect.zero)
        
        // Set content from above:
        let hostingView = NSHostingView(rootView: content)
        _ = callToObjC_dynamic(inst, "setContentView:", hostingView)
        
        callToObjC(inst, "setCornerRadius:", 26.0)
        callToObjC(inst, "set_borderFraction:", 1.0)
        callToObjC(inst, "set_exteriorLightFraction:", 1.0)
        callToObjC(inst, "set_interiorLightFraction:", 1.0)
        
        //callToObjC(inst, "setIndicatesIndeterminateProgress:", true)
        //callToObjC(inst, "setUsesAudioLevels:", true)
        //_ = callToObjC_dynamic(inst, "setAudioLevel:", Float(40.0))
            
        return inst
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {}
}
