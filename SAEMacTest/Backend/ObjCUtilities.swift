//
//  ObjCCallable.swift
//  SAEMacTest
//
//  Created by Sebastian Kassai on 27/10/2024.
//

import AppKit

typealias T_callToObjC              = @convention(c) (AnyObject, Selector)           -> Void

typealias T_callToObjCWithInteger   = @convention(c) (AnyObject, Selector, Int)      -> Void
typealias T_callToObjCWithInteger2  = @convention(c) (AnyObject, Selector, Int, Int) -> Void

typealias T_callToObjCWithFloat     = @convention(c) (AnyObject, Selector, Float)    -> Void
typealias T_callToObjCWithDouble    = @convention(c) (AnyObject, Selector, Double)   -> Void
typealias T_callToObjCWithNSRect    = @convention(c) (AnyObject, Selector, NSRect)   -> Void
typealias T_callToObjCWithNSScreen  = @convention(c) (AnyObject, Selector, NSScreen) -> Void

// TODO: naming!

// MARK: Static

// TODO: this might be unnecessary, as the dynamic perform() version would do the same thing.
func callToObjC(_ inst: AnyObject, _ selectorName: String) {
    let selector = NSSelectorFromString(selectorName)
    guard let method = class_getInstanceMethod(type(of: inst), selector) else {
        fatalError("Can't get instance method for selector \(selectorName)")
    }
    let imp = method_getImplementation(method)
    
    unsafeBitCast(imp, to: T_callToObjC.self)(inst, selector)
}

func callToObjC<T>(_ inst: AnyObject, _ selectorName: String, _ arg: T? = nil) {
    let selector = NSSelectorFromString(selectorName)
    
    guard let method = class_getInstanceMethod(type(of: inst), selector) else {
        fatalError("Can't get instance method for selector \(selectorName)")
    }
    let imp = method_getImplementation(method)
    
    switch arg {
    case let value as Int:      unsafeBitCast(imp, to: T_callToObjCWithInteger.self)  (inst, selector, value)
    case let value as Bool:     unsafeBitCast(imp, to: T_callToObjCWithInteger.self)  (inst, selector, value ? 1 : 0)
    case let value as Float:    unsafeBitCast(imp, to: T_callToObjCWithFloat.self)    (inst, selector, value)
    case let value as Double:   unsafeBitCast(imp, to: T_callToObjCWithDouble.self)   (inst, selector, value)
    case let value as NSRect:   unsafeBitCast(imp, to: T_callToObjCWithNSRect.self)   (inst, selector, value)
    case let value as NSScreen: unsafeBitCast(imp, to: T_callToObjCWithNSScreen.self) (inst, selector, value)
    default:                    fatalError("Invalid type given as arg to \(#function)!")
    }
}

func callToObjC<T>(_ inst: AnyObject, _ selectorName: String, _ arg0: T? = nil, _ arg1: T? = nil) {
    let selector = NSSelectorFromString(selectorName)
    
    guard let method = class_getInstanceMethod(type(of: inst), selector) else {
        fatalError("Can't get instance method for selector \(selectorName)")
    }
    let imp = method_getImplementation(method)
    
    switch arg0 {
    case let value as Int:      unsafeBitCast(imp, to: T_callToObjCWithInteger2.self)(inst, selector, value, value)
    case let value as Bool:     unsafeBitCast(imp, to: T_callToObjCWithInteger2.self)(inst, selector, value ? 1 : 0, arg1 as! Bool ? 1 : 0)
    default:                    fatalError("Invalid type given as arg to \(#function)!")
    }
}

// MARK: Dynamic

func callToObjC_dynamic(_ inst: AnyObject, _ selectorName: String, _ args: Any...) -> Unmanaged<AnyObject>? {
    let selector = NSSelectorFromString(selectorName)
    
    switch args.count {
    case 0: do { return inst.perform(selector) }
    case 1: do { return inst.perform(selector, with: args[0]) }
    case 2: do { return inst.perform(selector, with: args[0], with: args[1]) }
    default: fatalError("Invalid number of arguments!")
    }
}
