//
//  UIView+LayoutSizeFit.swift
//  JSLayoutSizeFit
//
//  Created by jiasong on 2021/1/13.
//

import UIKit

public extension LayoutSizeFitWrapper where Base: UIView {
    
    var isUseFrameLayout: Bool {
        return self.base.js_isUseFrameLayout
    }
    
    func useFrameLayout(_ isUse: Bool) {
        self.base.js_isUseFrameLayout = isUse
    }
    
    var isFromTemplateView: Bool {
        return self.base.js_isFromTemplateView
    }
    
}

