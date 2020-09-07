//
//  UITableView+JSLayoutSizeFit.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JSLayoutSizeFitCache;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ConfigurationCell)(__kindof UITableViewCell *cell);
typedef void(^ConfigurationHeaderFooter)(__kindof UITableViewHeaderFooterView *headerFooterView);

@interface UITableView (JSLayoutSizeFit)

@property (nonatomic, readonly) JSLayoutSizeFitCache *js_rowHeightFitCache;
@property (nonatomic, readonly) JSLayoutSizeFitCache *js_sectionHeightFitCache;

/// cell
- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                          configuration:(nullable ConfigurationCell)configuration;
- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                             cacheByKey:(nullable id)key
                          configuration:(nullable ConfigurationCell)configuration;

- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                           contentWidth:(CGFloat)contentWidth
                          configuration:(nullable ConfigurationCell)configuration;
- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                           contentWidth:(CGFloat)contentWidth
                             cacheByKey:(nullable id)key
                          configuration:(nullable ConfigurationCell)configuration;

/// section
- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                      configuration:(nullable ConfigurationHeaderFooter)configuration;
- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                         cacheByKey:(nullable id)key
                                      configuration:(nullable ConfigurationHeaderFooter)configuration;

- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                       contentWidth:(CGFloat)contentWidth
                                      configuration:(nullable ConfigurationHeaderFooter)configuration;
- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                       contentWidth:(CGFloat)contentWidth
                                         cacheByKey:(nullable id)key
                                      configuration:(nullable ConfigurationHeaderFooter)configuration;

@end

NS_ASSUME_NONNULL_END
