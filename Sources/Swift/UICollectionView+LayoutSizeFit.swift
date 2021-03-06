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
        return self.base.js_fittingSize(forReusableViewClass: viewClass, cacheByKey: key as NSString?) { (reusableView) in
            configuration?(reusableView as! ReusableView)
        }
    }
    
    func fittingHeight<ReusableView>(forReusableViewClass viewClass: AnyClass,
                                     contentWidth: CGFloat,
                                     cacheBy key: String? = nil,
                                     configuration: ((ReusableView) -> Void)? = nil) -> CGSize where ReusableView : UICollectionReusableView {
        return self.base.js_fittingSize(forReusableViewClass: viewClass, contentWidth: contentWidth, cacheByKey: key as NSString?) { (reusableView) in
            configuration?(reusableView as! ReusableView)
        }
    }
    
    func fittingHeight<ReusableView>(forReusableViewClass viewClass: AnyClass,
                                     contentHeight: CGFloat,
                                     cacheBy key: String? = nil,
                                     configuration: ((ReusableView) -> Void)? = nil) -> CGSize where ReusableView : UICollectionReusableView {
        return self.base.js_fittingSize(forReusableViewClass: viewClass, contentHeight: contentHeight, cacheByKey: key as NSString?) { (reusableView) in
            configuration?(reusableView as! ReusableView)
        }
    }
    
}
