// https://gist.github.com/VAnsimov/3d30fc02780c4d6fcea4ba425084ae2c

import SwiftUI
import AppKit

public final class HostingView<T: View>: NSView {
    var hostingController: NSHostingController<T>

    public var rootView: T {
        get { hostingController.rootView }
        set { hostingController.rootView = newValue }
    }

    public init(rootView: T, frame: CGRect = .zero) {
        hostingController = NSHostingController(rootView: rootView)
        
        super.init(frame: frame)
        //super.wantsLayer = true
        //layer?.backgroundColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        super.autoresizingMask = NSView.AutoresizingMask([NSView.AutoresizingMask.width, NSView.AutoresizingMask.height])
        
        hostingController.view.frame = self.bounds
        hostingController.view.autoresizingMask = NSView.AutoresizingMask([NSView.AutoresizingMask.width, NSView.AutoresizingMask.height])

        addSubview(hostingController.view)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func addChildControllerTo(_ controller: NSViewController) {
        controller.addChild(hostingController)
    }

    public func removeChildControllerTo(_ controller: NSViewController) {
        hostingController.removeFromParent()
    }
}
