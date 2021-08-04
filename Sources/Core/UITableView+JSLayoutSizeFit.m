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
#import "UIScrollView+JSLayoutSizeFit_Private.h"
#import "UIScrollView+JSLayoutSizeFit.h"
#import "UIView+JSLayoutSizeFit_Private.h"
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

#pragma mark - UITableViewSection

- (CGFloat)js_fittingHeightForSectionClass:(Class)sectionClass
                             configuration:(nullable JSConfigurationTableViewSection)configuration {
    return [self js_fittingHeightForSectionClass:sectionClass
                                    contentWidth:JSLayoutSizeFitAutomaticDimension
                                      cacheByKey:nil
                                   configuration:configuration];
}

- (CGFloat)js_fittingHeightForSectionClass:(Class)sectionClass
                                cacheByKey:(nullable id<NSCopying>)key
                             configuration:(nullable JSConfigurationTableViewSection)configuration {
    return [self js_fittingHeightForSectionClass:sectionClass
                                    contentWidth:JSLayoutSizeFitAutomaticDimension
                                      cacheByKey:key
                                   configuration:configuration];
}

- (CGFloat)js_fittingHeightForSectionClass:(Class)sectionClass
                              contentWidth:(CGFloat)contentWidth
                             configuration:(nullable JSConfigurationTableViewSection)configuration {
    return [self js_fittingHeightForSectionClass:sectionClass
                                    contentWidth:contentWidth
                                      cacheByKey:nil
                                   configuration:configuration];
}

- (CGFloat)js_fittingHeightForSectionClass:(Class)sectionClass
                              contentWidth:(CGFloat)contentWidth
                                cacheByKey:(nullable id<NSCopying>)key
                             configuration:(nullable JSConfigurationTableViewSection)configuration {
    if (![sectionClass isSubclassOfClass:UITableViewHeaderFooterView.class]) {
        NSAssert(NO, @"viewClass必须是UITableViewHeaderFooterView类或者其子类");
    }
    return [self __js_fittingHeightForViewClass:sectionClass
                                   contentWidth:contentWidth
                                     cacheByKey:key
                                  configuration:configuration];
}

#pragma mark - Private

- (CGFloat)__js_fittingHeightForViewClass:(Class)viewClass
                             contentWidth:(CGFloat)contentWidth
                               cacheByKey:(nullable id<NSCopying>)key
                            configuration:(nullable void(^)(__kindof UIView *))configuration {
    CGFloat resultHeight = 0;
    /// FitCache
    JSLayoutSizeFitCache *fitCache = [viewClass isSubclassOfClass:UITableViewCell.class] ? self.js_rowSizeFitCache : self.js_sectionSizeFitCache;
    if (key != nil && [fitCache containsKey:key]) {
        resultHeight = [fitCache CGFloatForKey:key];
    } else {
        /// 获取模板View
        __kindof UIView *templateView = [self js_templateViewForViewClass:viewClass];
        /// 准备
        [self __js_prepareForTemplateView:templateView contentWidth:contentWidth configuration:configuration];
        /// 计算高度
        resultHeight = [self __js_systemFittingHeightForTemplateView:templateView];
        /// 若Key存在时则写入内存
        if (key != nil) {
            [fitCache setCGFloat:resultHeight forKey:key];
        }
    }
    return resultHeight;
}

- (void)__js_prepareForTemplateView:(__kindof UIView *)templateView
                       contentWidth:(CGFloat)contentWidth
                      configuration:(nullable void(^)(__kindof UIView *))configuration {
    CGFloat finalContentWidth = contentWidth != JSLayoutSizeFitAutomaticDimension ? contentWidth : self.js_templateContainerWidth;
    NSAssert(finalContentWidth != 0, @"contentWidth必须大于0, 否则计算高度就无意义了!");
    UIView *contentView = templateView.js_templateContentView;
    if (!contentView) {
        NSAssert(NO, @"理论上contentView不可能为nil, 需要观察下哪里出问题了");
    }
    if (templateView.js_width != finalContentWidth) {
        templateView.js_width = finalContentWidth;
    }
    if (contentView.js_width != finalContentWidth) {
        contentView.js_width = finalContentWidth;
    }
    if ([templateView respondsToSelector:@selector(prepareForReuse)]) {
        [templateView prepareForReuse];
    }
    if (configuration) {
        configuration(templateView);
    }
}

- (CGFloat)__js_systemFittingHeightForTemplateView:(__kindof UIView *)templateView {
    UIView *contentView = templateView.js_templateContentView;
    CGFloat contentWidth = contentView.js_width;
    CGFloat fittingHeight = 0;
    if (templateView.js_isUseFrameLayout) {
        fittingHeight = [templateView sizeThatFits:CGSizeMake(contentWidth, JSLayoutSizeFitAutomaticDimension)].height;
    } else {
        [contentView js_addFenceConstraintIfNeeded];
        if (contentView.js_widthConstraint.constant != contentWidth) {
            contentView.js_widthConstraint.constant = contentWidth;
        }
        fittingHeight = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    if ([templateView isKindOfClass:UITableViewCell.class] && self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingHeight += JSCoreHelper.pixelOne;
    }
    return fittingHeight;
}

@end
