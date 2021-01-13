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

public protocol LayoutSizeFitCompatible: AnyObject {}

public extension LayoutSizeFitCompatible {
    
    var lsf: LayoutSizeFitWrapper<Self> {
        get { return LayoutSizeFitWrapper(self) }
        set { }
    }
    
}
