import SwiftUI

// NOTE: this is no longer used!

struct ControllerWindow {
    public static var controllerWindow: NSWindow? = nil
    
    @MainActor static func createControllerWindow() -> NSWindow {
        let content = ControllerView().environmentObject(GlobalState.GLOBAL_instance)
        
        let controller = NSHostingController(rootView: content)
//        controller.sizingOptions = .preferredContentSize
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

        window.setContentSize(controller.view.fittingSize)
        
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        return window
    }
}
