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
        var ocKey: NSString? = nil
        if key != nil {
            ocKey = NSString(string: key!)
        }
        return self.base.js_fittingHeight(forCellClass: cellClass, contentWidth: width, cacheByKey: ocKey) { (cell) in
            if let block = configuration, let cell = cell as? Cell {
                block(cell)
            }
        }
    }
    
    func fittingHeight<Section>(forSectionClass sectionClass: AnyClass,
                                contentWidth width: CGFloat = JSLayoutSizeFitAutomaticDimension,
                                cacheBy key: String? = nil,
                                configuration: ((Section) -> Void)? = nil) -> CGFloat where Section : UITableViewHeaderFooterView {
        var ocKey: NSString? = nil
        if key != nil {
            ocKey = NSString(string: key!)
        }
        return self.base.js_fittingHeight(forSectionClass: sectionClass, contentWidth: width, cacheByKey: ocKey) { (section) in
            if let block = configuration, let section = section as? Section {
                block(section)
            }
        }
    }
    
}