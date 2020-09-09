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

typedef void(^JSConfigurationCell)(__kindof UITableViewCell *cell);
typedef void(^JSConfigurationHeaderFooter)(__kindof UITableViewHeaderFooterView *headerFooterView);

@interface UITableView (JSLayoutSizeFit)

@property (nonatomic, readonly) JSLayoutSizeFitCache *js_rowHeightFitCache;
@property (nonatomic, readonly) JSLayoutSizeFitCache *js_sectionHeightFitCache;

/// cell
- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                          configuration:(nullable JSConfigurationCell)configuration;
- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                             cacheByKey:(nullable id<NSCopying>)key
                          configuration:(nullable JSConfigurationCell)configuration;

- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                           contentWidth:(CGFloat)contentWidth
                          configuration:(nullable JSConfigurationCell)configuration;
- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                           contentWidth:(CGFloat)contentWidth
                             cacheByKey:(nullable id<NSCopying>)key
                          configuration:(nullable JSConfigurationCell)configuration;

/// section
- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                      configuration:(nullable JSConfigurationHeaderFooter)configuration;
- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                         cacheByKey:(nullable id<NSCopying>)key
                                      configuration:(nullable JSConfigurationHeaderFooter)configuration;

- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                       contentWidth:(CGFloat)contentWidth
                                      configuration:(nullable JSConfigurationHeaderFooter)configuration;
- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                       contentWidth:(CGFloat)contentWidth
                                         cacheByKey:(nullable id<NSCopying>)key
                                      configuration:(nullable JSConfigurationHeaderFooter)configuration;

@end

NS_ASSUME_NONNULL_END
