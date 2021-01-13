//
//  UITableView+LayoutSizeFit.swift
//  JSLayoutSizeFit
//
//  Created by jiasong on 2021/1/13.
//

import UIKit

extension UITableView: LayoutSizeFitCompatible {}

public extension LayoutSizeFitWrapper where Base: UITableView {
    
    func fittingHeight<Cell>(forCellClass cellClass: AnyClass,
                             contentWidth width: CGFloat = JSLayoutSizeFitAutomaticDimension,
                             cacheBy key: NSCopying? = nil,
                             configuration: ((Cell) -> Void)? = nil) -> CGFloat where Cell : UITableViewCell {
        return self.base.js_fittingHeight(forCellClass: cellClass, contentWidth: width, cacheByKey: key) { (cell) in
            if let block = configuration, let cell = cell as? Cell {
                block(cell)
            }
        }
    }
    
    func fittingHeight<Section>(forSectionClass sectionClass: AnyClass,
                                contentWidth width: CGFloat = JSLayoutSizeFitAutomaticDimension,
                                cacheBy key: NSCopying? = nil,
                                configuration: ((Section) -> Void)? = nil) -> CGFloat where Section : UITableViewHeaderFooterView {
        return self.base.js_fittingHeight(forSectionViewClass: sectionClass, contentWidth: width, cacheByKey: key) { (sectionView) in
            if let block = configuration, let sectionView = sectionView as? Section {
                block(sectionView)
            }
        }
    }
    
}
