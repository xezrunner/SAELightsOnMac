import SwiftUI
import AVFoundation

struct ControllerView: View {
    @EnvironmentObject var globalState: GlobalState
    
    @State var modeValue   = 1.0
    @State var volumeLevel: Float = -80.0
    @State var burstStartPosition: Float = 1
    
    @State var multiplyCompositionState: Bool? = nil
    @State var windowedModeState: Bool? = nil
    
    func keyDownEvent(event: NSEvent) -> NSEvent? {
        if event.keyCode == 1 {
            EdgeLightWindow.setBurstStartPosition(value: Int(burstStartPosition))
            EdgeLightWindow.setMode(value: Int(modeValue))
            return nil
        }
        
        return event
    }
    
    var body: some View {
        ZStack {
            Color.primary.colorInvert().opacity(0.45)
                .background(.regularMaterial)
            
            VStack {
                Spacer()
                    .frame(height: 15)
                
                VStack(alignment: .leading, spacing: 14) {
                    // MARK: Mesh settings
                    VStack {
                        let columns = [GridItem(.fixed(60)), GridItem(.fixed(60))]
                        LazyVGrid(columns: columns) {
                            ForEach(0..<globalState.meshColors.count, id: \.self) { index in
                                XZColorPicker(color: $globalState.meshColors[index])
                            }
                        }
                        .padding()
                        
                        VStack(alignment: .leading) {
                            Text("Mesh gradient brightness: \(globalState.meshBrightness)")
                            Slider(value: $globalState.meshBrightness, in: -3...10)
                                .onChange(of: globalState.meshBrightness) {
                                    //NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                                }
                            
                            Text("Mesh gradient contrast: \(globalState.meshContrast)")
                            Slider(value: $globalState.meshContrast, in: -3...10)
                                .onChange(of: globalState.meshContrast) {
                                    //NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                                }
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: Edge light window properties
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Volume level: \(Int(volumeLevel))")
                            Slider(value: $volumeLevel, in: -130...130)
                                .onChange(of: volumeLevel) {
                                    NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                                    EdgeLightWindow.setVolumeLevel(value: volumeLevel)
                                }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("Burst start position index: \(Int(burstStartPosition))")
                            Slider(value: $burstStartPosition, in: 0...7, step: 1)
                                .onChange(of: burstStartPosition) {
                                    NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                                }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("Mode: \(Int(modeValue))")
                            Slider(value: $modeValue, in: 0...5, step: 1)
                                .onChange(of: modeValue) {
                                    NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .now)
                                }
                        }
                        .padding()
                        
                        Button("Set mode") {
                            EdgeLightWindow.setBurstStartPosition(value: Int(burstStartPosition))
                            EdgeLightWindow.setMode(value: Int(modeValue))
                        }
                        .buttonStyle(
                            FullWidthButtonStyle(backgroundColor: .accentColor,
                                                 foregroundColor: .white))
                    }
                    
                    // MARK: Edge light window settings
                    VStack(alignment: .leading) {
                        Toggle("Enable intelligence light view (macOS SAE)", isOn: $globalState.useIntelligenceLightView)
                        
                        Toggle("\(multiplyCompositionState ?? false ? "" : "")Enable multiply blending composition", isOn:
                                Binding(
                                    get: { EdgeLightWindow.layer?.compositingFilter != nil },
                                    set: { value in
                                        EdgeLightWindow.layer?.compositingFilter = (value ? CIFilter.multiplyCompositing() : nil)
                                        multiplyCompositionState = EdgeLightWindow.layer?.compositingFilter != nil
                                    }
                                )
                        )
                        
                        Toggle("\(windowedModeState ?? false ? "" : "")Enable windowed mode", isOn:
                                Binding(
                                    get: { windowedModeState == nil ? EdgeLightWindow.window?.hasShadow ?? false : windowedModeState! },
                                    set: { value in
                                        windowedModeState = EdgeLightWindow.setWindowed(value: value)
                                    }
                                )
                        )
                    }
                    
                }
                .padding(24)
                .buttonStyle(FullWidthButtonStyle())
                .toggleStyle(FullWidthToggleStyle())
            }
        }
        .onAppear {
            let _ = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: keyDownEvent)
            let window = NSApplication.shared.windows.first!
            print(window)
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    ControllerView()
        .environmentObject(GlobalState())
        .frame(width: 400)
        //.frame(width: 400, height: 520)
}
