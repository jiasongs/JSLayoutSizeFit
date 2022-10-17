//
//  UITableView+JSLayoutSizeFit.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JSLayoutSizeFitCacheBuilder;
@class JSLayoutSizeFitCache;

NS_ASSUME_NONNULL_BEGIN

typedef void(^JSConfigurationTableViewCell)(__kindof UITableViewCell *cell);
typedef void(^JSConfigurationTableViewSection)(__kindof UITableViewHeaderFooterView *headerFooterView);

@interface UITableView (JSLayoutSizeFit)

@property (null_resettable, nonatomic, weak) id<JSLayoutSizeFitCacheBuilder> js_fittingHeightCacheBuilder;
@property (nonatomic, readonly) JSLayoutSizeFitCache *js_fittingHeightCache;

- (void)js_invalidateFittingHeightForCacheKey:(id<NSCopying>)cacheKey;
- (void)js_invalidateAllFittingHeight;

/// Cell
- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                             cacheByKey:(nullable id<NSCopying>)key
                          configuration:(nullable JSConfigurationTableViewCell)configuration;

- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                            atIndexPath:(nullable NSIndexPath *)indexPath
                             cacheByKey:(nullable id<NSCopying>)key
                          configuration:(nullable JSConfigurationTableViewCell)configuration;

/// Section
- (CGFloat)js_fittingHeightForSectionClass:(Class)sectionClass
                                cacheByKey:(nullable id<NSCopying>)key
                             configuration:(nullable JSConfigurationTableViewSection)configuration;

@end

NS_ASSUME_NONNULL_END
