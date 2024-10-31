import SwiftUI

struct ControllerWindow {
    public static var controllerWindow: NSWindow? = nil
    
    @MainActor static func createControllerWindow() -> NSWindow {
#if true
        let content = ControllerView().environmentObject(GLOBAL_globalState)
        
        let controller = NSHostingController(rootView: content)
        //controller.view.widthAnchor.constraint (greaterThanOrEqualToConstant: CGFloat(400)).isActive = true
        //controller.view.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(680)).isActive = true
        
        let window = NSWindow(contentViewController: controller)
        
        window.setFrame(NSRect(origin: .zero, size: CGSize(width: 450, height: 680)), display: true)
        window.title = "Edge light window controller"
        window.styleMask = [.titled, .resizable, .closable, .miniaturizable, .fullSizeContentView]
        window.level = .normal
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.collectionBehavior = NSWindow.CollectionBehavior.managed // Restore spaces / mission ctrl
        window.titlebarAppearsTransparent = true
        
        window.center()
        window.makeKeyAndOrderFront(nil)
        return window
#else
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
#endif
    }
}
