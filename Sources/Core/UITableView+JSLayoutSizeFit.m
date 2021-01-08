//
//  UITableView+JSLayoutSizeFit.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import "UITableView+JSLayoutSizeFit.h"
#import "JSCoreKit.h"
#import "JSLayoutSizeFitCache.h"
#import "UIScrollView+JSLayoutSizeFit.h"
#import "UIView+JSLayoutSizeFit.h"

@implementation UITableView (JSLayoutSizeFit)

#pragma mark - UITableViewCell

- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                          configuration:(nullable JSConfigurationTableViewCell)configuration {
    return [self js_fittingHeightForCellClass:cellClass
                                 contentWidth:JSLayoutSizeFitAutomaticDimension
                                   cacheByKey:nil
                                configuration:configuration];
}

- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                             cacheByKey:(nullable id<NSCopying>)key
                          configuration:(nullable JSConfigurationTableViewCell)configuration {
    return [self js_fittingHeightForCellClass:cellClass
                                 contentWidth:JSLayoutSizeFitAutomaticDimension
                                   cacheByKey:key
                                configuration:configuration];
}

- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                           contentWidth:(CGFloat)contentWidth
                          configuration:(nullable JSConfigurationTableViewCell)configuration {
    return [self js_fittingHeightForCellClass:cellClass
                                 contentWidth:contentWidth
                                   cacheByKey:nil
                                configuration:configuration];
}

- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                           contentWidth:(CGFloat)contentWidth
                             cacheByKey:(nullable id<NSCopying>)key
                          configuration:(nullable JSConfigurationTableViewCell)configuration {
    if (![cellClass isSubclassOfClass:UITableViewCell.class]) {
        NSAssert(NO, @"cellClass必须是UITableViewCell类或者其子类");
    }
    return [self __js_fittingHeightForViewClass:cellClass
                                   contentWidth:contentWidth
                                     cacheByKey:key
                                  configuration:configuration];
}

#pragma mark - UITableViewHeaderFooterView

- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                      configuration:(nullable JSConfigurationHeaderFooterView)configuration {
    return [self js_fittingHeightForHeaderFooterViewClass:viewClass
                                             contentWidth:JSLayoutSizeFitAutomaticDimension
                                               cacheByKey:nil
                                            configuration:configuration];
}

- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                         cacheByKey:(nullable id<NSCopying>)key
                                      configuration:(nullable JSConfigurationHeaderFooterView)configuration {
    return [self js_fittingHeightForHeaderFooterViewClass:viewClass
                                             contentWidth:JSLayoutSizeFitAutomaticDimension
                                               cacheByKey:key
                                            configuration:configuration];
}

- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                       contentWidth:(CGFloat)contentWidth
                                      configuration:(nullable JSConfigurationHeaderFooterView)configuration {
    return [self js_fittingHeightForHeaderFooterViewClass:viewClass
                                             contentWidth:contentWidth
                                               cacheByKey:nil
                                            configuration:configuration];
}

- (CGFloat)js_fittingHeightForHeaderFooterViewClass:(Class)viewClass
                                       contentWidth:(CGFloat)contentWidth
                                         cacheByKey:(nullable id<NSCopying>)key
                                      configuration:(nullable JSConfigurationHeaderFooterView)configuration {
    if (![viewClass isSubclassOfClass:UITableViewHeaderFooterView.class]) {
        NSAssert(NO, @"viewClass必须是UITableViewHeaderFooterView类或者其子类");
    }
    return [self __js_fittingHeightForViewClass:viewClass
                                   contentWidth:contentWidth
                                     cacheByKey:key
                                  configuration:configuration];
}

#pragma mark - 通用

- (CGFloat)__js_fittingHeightForViewClass:(Class)viewClass
                             contentWidth:(CGFloat)contentWidth
                               cacheByKey:(nullable id<NSCopying>)key
                            configuration:(nullable void(^)(__kindof UIView *))configuration {
    JSLayoutSizeFitCache *fitCache = [viewClass isSubclassOfClass:UITableViewCell.class] ? self.js_rowSizeFitCache : self.js_sectionSizeFitCache;
    if (key && [fitCache containsKey:key]) {
        return [fitCache CGFloatForKey:key];
    }
    __kindof UIView *templateView = [self js_templateViewForViewClass:viewClass];
    if ([templateView respondsToSelector:@selector(prepareForReuse)]) {
        [templateView prepareForReuse];
    }
    if (configuration) {
        configuration(templateView);
    }
    CGFloat newContentWidth = contentWidth != JSLayoutSizeFitAutomaticDimension ? contentWidth : self.js_templateContainerWidth;
    CGFloat height = [self __js_systemFittingHeightForTemplateView:templateView contentWidth:newContentWidth];
    if (key) {
        [fitCache setCGFloat:height forKey:key];
    }
    return height;
}

#pragma mark - 计算高度

- (CGFloat)__js_systemFittingHeightForTemplateView:(__kindof UIView *)templateView contentWidth:(CGFloat)contentWidth {
    NSAssert(contentWidth != 0, @"contentWidth必须大于0, 否则计算高度就无意义了!");
    UIView *contentView = templateView.js_templateContentView;
    if (!contentView) {
        NSAssert(NO, @"理论上contentView不可能为nil, 需要观察下哪里出问题了");
    }
    if (templateView.js_width != contentWidth) {
        templateView.js_width = contentWidth;
    }
    if (contentView.js_width != contentWidth) {
        contentView.js_width = contentWidth;
    }
    CGFloat fittingHeight = 0;
    if (templateView.js_useFrameLayout) {
        fittingHeight = [templateView sizeThatFits:CGSizeMake(contentWidth, JSLayoutSizeFitAutomaticDimension)].height;
    } else {
        [contentView js_addFenceConstraintIfNeeded];
        if (contentView.js_fenceConstraint.constant != contentWidth) {
            contentView.js_fenceConstraint.constant = contentWidth;
            [contentView setNeedsUpdateConstraints];
            [contentView.superview setNeedsUpdateConstraints];
        }
        fittingHeight = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    /// 分割线
    if ([templateView isKindOfClass:UITableViewCell.class] && self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingHeight += JSCoreHelper.pixelOne;
    }
    return fittingHeight;
}

@end
