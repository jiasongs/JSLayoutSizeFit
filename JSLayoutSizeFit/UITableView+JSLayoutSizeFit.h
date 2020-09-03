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
- (CGFloat)js_heightForCellClass:(Class)cellClass configuration:(ConfigurationCell)configuration;
- (CGFloat)js_heightForCellClass:(Class)cellClass cacheByKey:(nullable id)key configuration:(ConfigurationCell)configuration;

- (CGFloat)js_heightForCellClass:(Class)cellClass contentWidth:(CGFloat)contentWidth configuration:(ConfigurationCell)configuration;
- (CGFloat)js_heightForCellClass:(Class)cellClass contentWidth:(CGFloat)contentWidth cacheByKey:(nullable id)key configuration:(ConfigurationCell)configuration;

/// section
- (CGFloat)js_heightForHeaderFooterViewClass:(Class)viewClass configuration:(ConfigurationHeaderFooter)configuration;
- (CGFloat)js_heightForHeaderFooterViewClass:(Class)viewClass cacheByKey:(nullable id)key configuration:(ConfigurationHeaderFooter)configuration;

- (CGFloat)js_heightForHeaderFooterViewClass:(Class)viewClass contentWidth:(CGFloat)contentWidth configuration:(ConfigurationHeaderFooter)configuration;
- (CGFloat)js_heightForHeaderFooterViewClass:(Class)viewClass contentWidth:(CGFloat)contentWidth cacheByKey:(nullable id)key configuration:(ConfigurationHeaderFooter)configuration;

@end

NS_ASSUME_NONNULL_END
