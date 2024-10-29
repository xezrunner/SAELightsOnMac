import SwiftUI

struct ControllerWindow {
    public static var controllerWindow: NSWindow? = nil
    
    static func createControllerWindow() -> NSWindow {
        let window = NSWindow()
        self.controllerWindow = window
        
        window.setFrame(NSRect(x: 0, y: 0, width: 400, height: 580), display: false)
        window.title = "Edge light window controller"
        window.styleMask = [.titled, .resizable, .closable, .miniaturizable, .fullSizeContentView]
        window.level = .normal
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.collectionBehavior = NSWindow.CollectionBehavior.managed // Restore spaces / mission ctrl
        window.titlebarAppearsTransparent = true
        
        let mainView = ControllerView().environmentObject(SAEMacTestApp.globalState)
        let mainViewHost = HostingView(rootView: mainView, frame: window.contentRect(forFrameRect: window.frame))
        window.contentView = mainViewHost

        window.center()
        window.makeKeyAndOrderFront(nil)
        return window
    }
}
