//
//  UITableView+JSLayoutSizeFit.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JSConfigurationTableViewCell)(__kindof UITableViewCell *cell);
typedef void(^JSConfigurationHeaderFooterView)(__kindof UITableViewHeaderFooterView *headerFooterView);

@interface UITableView (JSLayoutSizeFit)

/// cell
- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                          configuration:(nullable JSConfigurationTableViewCell)configuration;
- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                             cacheByKey:(nullable id<NSCopying>)key
                          configuration:(nullable JSConfigurationTableViewCell)configuration;

- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                           contentWidth:(CGFloat)contentWidth
                          configuration:(nullable JSConfigurationTableViewCell)configuration;
- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                           contentWidth:(CGFloat)contentWidth
                             cacheByKey:(nullable id<NSCopying>)key
                          configuration:(nullable JSConfigurationTableViewCell)configuration;

/// section
- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                      configuration:(nullable JSConfigurationHeaderFooterView)configuration;
- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                         cacheByKey:(nullable id<NSCopying>)key
                                      configuration:(nullable JSConfigurationHeaderFooterView)configuration;

- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                       contentWidth:(CGFloat)contentWidth
                                      configuration:(nullable JSConfigurationHeaderFooterView)configuration;
- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                       contentWidth:(CGFloat)contentWidth
                                         cacheByKey:(nullable id<NSCopying>)key
                                      configuration:(nullable JSConfigurationHeaderFooterView)configuration;

@end

NS_ASSUME_NONNULL_END
