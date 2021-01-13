//
//  UICollectionView+LayoutSizeFit.swift
//  JSLayoutSizeFit
//
//  Created by jiasong on 2021/1/13.
//

import UIKit

extension UICollectionView: LayoutSizeFitCompatible {}

public extension LayoutSizeFitWrapper where Base: UICollectionView {
    
    func fittingHeight<ReusableView>(forReusableViewClass reusableClass: AnyClass,
                                     cacheBy key: NSCopying? = nil,
                                     configuration: ((ReusableView) -> Void)? = nil) -> CGSize where ReusableView : UICollectionReusableView {
        return self.base.js_fittingSize(forReusableViewClass: reusableClass, cacheByKey: key) { (reusableView) in
            if let block = configuration, let reusableView = reusableView as? ReusableView {
                block(reusableView)
            }
        }
    }
    
}
