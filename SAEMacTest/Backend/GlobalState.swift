import SwiftUI

class GlobalState: ObservableObject {
    @Published var useIntelligenceLightView = true
    
    @Published var meshColors: [Color] = [
        Color.purple,
        Color.blue,
        Color.yellow,
        Color.pink
     ]
}
