import SwiftUI

class GlobalState: ObservableObject, Identifiable {
    @Published public var useIntelligenceLightView = false
    
    @Published var meshContrast   = 2.555
    @Published var meshBrightness = 0.5
    @Published var meshColors: [Color] = [
        Color(CGColor(red: 1.0,   green: 0.718, blue: 0.0, alpha: 1)),   // yellow
        Color(CGColor(red: 0.067, green: 0.433, blue: 1.0, alpha: 1.0)), // blue
        Color(CGColor(red: 0.726, green: 0.319, blue: 1.0, alpha: 1)),   // purple
        Color(CGColor(red: 1.0,   green: 0.488, blue: 0.0, alpha: 1)),   // orange/brown
     ]
    
    @Published var modeValue   = 1.0
    @Published var volumeLevel: Float = -80.0
    @Published var burstStartPosition: Float = 1
}

@MainActor var GLOBAL_globalState = GlobalState()
