//
//  UICollectionView+LayoutSizeFit.swift
//  JSLayoutSizeFit
//
//  Created by jiasong on 2021/1/13.
//

import UIKit

public extension LayoutSizeFitWrapper where Base: UICollectionView {
    
    func fittingHeight<ReusableView: UICollectionReusableView>(forReusableViewClass viewClass: ReusableView.Type,
                                                               cacheBy key: String? = nil,
                                                               configuration: ((ReusableView) -> Void)? = nil) -> CGSize {
        return self.base.js_fittingSize(forReusableViewClass: viewClass, cacheByKey: key as NSString?) { (reusableView) in
            configuration?(reusableView as! ReusableView)
        }
    }
    
    func fittingHeight<ReusableView: UICollectionReusableView>(forReusableViewClass viewClass: ReusableView.Type,
                                                               contentWidthAt indexPath: IndexPath,
                                                               cacheBy key: String? = nil,
                                                               configuration: ((ReusableView) -> Void)? = nil) -> CGSize {
        return self.base.js_fittingSize(forReusableViewClass: viewClass, contentWidthAt: indexPath, cacheByKey: key as NSString?) { (reusableView) in
            configuration?(reusableView as! ReusableView)
        }
    }
    
    func fittingHeight<ReusableView: UICollectionReusableView>(forReusableViewClass viewClass: ReusableView.Type,
                                                               contentWidth: CGFloat,
                                                               cacheBy key: String? = nil,
                                                               configuration: ((ReusableView) -> Void)? = nil) -> CGSize {
        return self.base.js_fittingSize(forReusableViewClass: viewClass, contentWidth: contentWidth, cacheByKey: key as NSString?) { (reusableView) in
            configuration?(reusableView as! ReusableView)
        }
    }
    
    func fittingHeight<ReusableView: UICollectionReusableView>(forReusableViewClass viewClass: ReusableView.Type,
                                                               contentHeightAt indexPath: IndexPath,
                                                               cacheBy key: String? = nil,
                                                               configuration: ((ReusableView) -> Void)? = nil) -> CGSize {
        return self.base.js_fittingSize(forReusableViewClass: viewClass, contentHeightAt: indexPath, cacheByKey: key as NSString?) { (reusableView) in
            configuration?(reusableView as! ReusableView)
        }
    }
    
    func fittingHeight<ReusableView: UICollectionReusableView>(forReusableViewClass viewClass: ReusableView.Type,
                                                               contentHeight: CGFloat,
                                                               cacheBy key: String? = nil,
                                                               configuration: ((ReusableView) -> Void)? = nil) -> CGSize {
        return self.base.js_fittingSize(forReusableViewClass: viewClass, contentHeight: contentHeight, cacheByKey: key as NSString?) { (reusableView) in
            configuration?(reusableView as! ReusableView)
        }
    }
    
}
