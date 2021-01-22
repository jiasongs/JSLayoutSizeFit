//
//  UICollectionView+LayoutSizeFit.swift
//  JSLayoutSizeFit
//
//  Created by jiasong on 2021/1/13.
//

import UIKit

public extension LayoutSizeFitWrapper where Base: UICollectionView {
    
    func fittingHeight<ReusableView>(forReusableViewClass viewClass: AnyClass,
                                     cacheBy key: String? = nil,
                                     configuration: ((ReusableView) -> Void)? = nil) -> CGSize where ReusableView : UICollectionReusableView {
        let ocKey: NSString? = key as NSString?
        return self.base.js_fittingSize(forReusableViewClass: viewClass, cacheByKey: ocKey) { (reusableView) in
            if let block = configuration, let reusableView = reusableView as? ReusableView {
                block(reusableView)
            }
        }
    }
    
}
