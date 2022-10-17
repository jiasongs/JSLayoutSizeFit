//
//  UITableView+LayoutSizeFit.swift
//  JSLayoutSizeFit
//
//  Created by jiasong on 2021/1/13.
//

import UIKit

public extension LayoutSizeFitWrapper where Base: UITableView {
    
    var fittingHeightCacheBuilder: JSLayoutSizeFitCacheBuilder {
        return self.base.js_fittingHeightCacheBuilder
    }
    
    func setFittingHeightCacheBuilder(_ builder: JSLayoutSizeFitCacheBuilder?) {
        self.base.js_fittingHeightCacheBuilder = builder
    }
    
    var fittingHeightCache: JSLayoutSizeFitCache {
        return self.base.js_fittingHeightCache
    }
    
    func fittingHeight<Cell: UITableViewCell>(forCellClass cellClass: Cell.Type,
                                              at indexPath: IndexPath,
                                              cacheBy key: String? = nil,
                                              configuration: ((Cell) -> Void)? = nil) -> CGFloat {
        return self.base.js_fittingHeight(forCellClass: cellClass, at:indexPath, cacheByKey: key as NSString?) { (cell) in
            configuration?(cell as! Cell)
        }
    }
    
    func fittingHeight<Section: UITableViewHeaderFooterView>(forSectionClass sectionClass: Section.Type,
                                                             cacheBy key: String? = nil,
                                                             configuration: ((Section) -> Void)? = nil) -> CGFloat {
        return self.base.js_fittingHeight(forSectionClass: sectionClass, cacheByKey: key as NSString?) { (section) in
            configuration?(section as! Section)
        }
    }
    
}
