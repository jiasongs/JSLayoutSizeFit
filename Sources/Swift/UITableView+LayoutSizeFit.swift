//
//  UITableView+LayoutSizeFit.swift
//  JSLayoutSizeFit
//
//  Created by jiasong on 2021/1/13.
//

import UIKit

public extension LayoutSizeFitWrapper where Base: UITableView {
    
    func fittingHeight<Cell>(forCellClass cellClass: AnyClass,
                             contentWidth width: CGFloat = JSLayoutSizeFitAutomaticDimension,
                             cacheBy key: String? = nil,
                             configuration: ((Cell) -> Void)? = nil) -> CGFloat where Cell : UITableViewCell {
        return self.base.js_fittingHeight(forCellClass: cellClass, contentWidth: width, cacheByKey: key as NSString?) { (cell) in
            configuration?(cell as! Cell)
        }
    }
    
    func fittingHeight<Section>(forSectionClass sectionClass: AnyClass,
                                contentWidth width: CGFloat = JSLayoutSizeFitAutomaticDimension,
                                cacheBy key: String? = nil,
                                configuration: ((Section) -> Void)? = nil) -> CGFloat where Section : UITableViewHeaderFooterView {
        return self.base.js_fittingHeight(forSectionClass: sectionClass, contentWidth: width, cacheByKey: key as NSString?) { (section) in
            configuration?(section as! Section)
        }
    }
    
}
