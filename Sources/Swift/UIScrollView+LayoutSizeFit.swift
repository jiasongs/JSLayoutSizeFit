//
//  UIScrollView+LayoutSizeFit.swift
//  JSLayoutSizeFit
//
//  Created by jiasong on 2021/1/13.
//

import UIKit

public extension LayoutSizeFitWrapper where Base: UIScrollView {
    
    var rowSizeFitCache: JSLayoutSizeFitCache {
        return self.base.js_rowSizeFitCache
    }
    
    var sectionSizeFitCache: JSLayoutSizeFitCache {
        return self.base.js_sectionSizeFitCache
    }
    
}
