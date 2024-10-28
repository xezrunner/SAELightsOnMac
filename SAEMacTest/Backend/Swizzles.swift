import Foundation

class Swizzles {
    // Dummy function that just returns a true Bool.
    @objc dynamic static func returnTrue() -> Bool {
        return true
    }
    
    @objc dynamic static func returnFalse() -> Bool {
        return false
    }
    
    @objc dynamic static func rect() -> CGRect {
        return CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
    }
    
    // https://stackoverflow.com/a/13221685
    @objc dynamic static func constrainFrameRect(frameRect: NSRect) -> NSRect {
        return frameRect
    }
    
    static func swizzle(targetClassName: String,
                 isTargetClassMethod: Bool, targetSelector: String,
                 overrideClass: AnyClass = Swizzles.self,
                 isOverrideClassMethod: Bool = true, overrideSelector: Selector = #selector(Swizzles.returnTrue)) {
        let targetClass: AnyClass? = objc_getClass(targetClassName) as? AnyClass
        
        let targetMethod: Method?
        if isTargetClassMethod { targetMethod = class_getClassMethod   (targetClass, NSSelectorFromString(targetSelector)) }
        else                   { targetMethod = class_getInstanceMethod(targetClass, NSSelectorFromString(targetSelector)) }
        
        let overrideMethod: Method?
        if isOverrideClassMethod { overrideMethod = class_getClassMethod   (overrideClass, overrideSelector) }
        else                     { overrideMethod = class_getInstanceMethod(overrideClass, overrideSelector) }
        
        if targetMethod == nil || overrideMethod == nil {
            print("Can't swizzle! target: \(targetMethod != nil)  override: \(overrideMethod != nil)")
        }
        
        method_exchangeImplementations(targetMethod!, overrideMethod!)
    }
}
