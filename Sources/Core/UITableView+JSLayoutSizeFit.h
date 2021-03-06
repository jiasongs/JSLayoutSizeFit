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
typedef void(^JSConfigurationTableViewSection)(__kindof UITableViewHeaderFooterView *headerFooterView);

@interface UITableView (JSLayoutSizeFit)

/// Cell
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

/// Section
- (CGFloat)js_fittingHeightForSectionClass:(Class)sectionClass
                             configuration:(nullable JSConfigurationTableViewSection)configuration;

- (CGFloat)js_fittingHeightForSectionClass:(Class)sectionClass
                                cacheByKey:(nullable id<NSCopying>)key
                             configuration:(nullable JSConfigurationTableViewSection)configuration;

- (CGFloat)js_fittingHeightForSectionClass:(Class)sectionClass
                              contentWidth:(CGFloat)contentWidth
                             configuration:(nullable JSConfigurationTableViewSection)configuration;

- (CGFloat)js_fittingHeightForSectionClass:(Class)sectionClass
                              contentWidth:(CGFloat)contentWidth
                                cacheByKey:(nullable id<NSCopying>)key
                             configuration:(nullable JSConfigurationTableViewSection)configuration;

@end

NS_ASSUME_NONNULL_END
