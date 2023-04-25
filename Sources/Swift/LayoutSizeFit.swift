//
//  LayoutSizeFit.swift
//  JSLayoutSizeFit
//
//  Created by jiasong on 2021/1/13.
//

import Foundation

public struct LayoutSizeFitWrapper<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
    
}

public protocol LayoutSizeFitCompatible {}

extension LayoutSizeFitCompatible {
    
    public static var lsf: LayoutSizeFitWrapper<Self>.Type {
        get { LayoutSizeFitWrapper<Self>.self }
        set { }
    }
    
    public var lsf: LayoutSizeFitWrapper<Self> {
        get { LayoutSizeFitWrapper(self) }
        set { }
    }
    
}

public protocol LayoutSizeFitCompatibleObject: AnyObject {}

extension LayoutSizeFitCompatibleObject {
    
    public static var lsf: LayoutSizeFitWrapper<Self>.Type {
        get { LayoutSizeFitWrapper<Self>.self }
        set { }
    }
    
    public var lsf: LayoutSizeFitWrapper<Self> {
        get { LayoutSizeFitWrapper(self) }
        set { }
    }
    
}

extension IndexPath: LayoutSizeFitCompatible {}

extension UIView: LayoutSizeFitCompatibleObject {}
