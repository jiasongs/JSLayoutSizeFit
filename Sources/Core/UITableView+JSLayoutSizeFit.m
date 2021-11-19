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

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JSRuntimeOverrideImplementation(UITableView.class, NSSelectorFromString(@"_configureCellForDisplay:forIndexPath:"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UITableView *selfObject, UITableViewCell *cell, NSIndexPath *indexPath) {
                
                __kindof UIView *templateView = [selfObject js_templateViewForViewClass:cell.class];
                templateView.js_realTableViewCell = cell;
                
                // call super，-[UITableViewDelegate tableView:willDisplayCell:forRowAtIndexPath:] 比这个还晚，所以不用担心触发 delegate
                void (*originSelectorIMP)(id, SEL, UITableViewCell *, NSIndexPath *);
                originSelectorIMP = (void (*)(id, SEL, UITableViewCell *, NSIndexPath *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, cell, indexPath);
            };
        });
    });
}

#pragma mark - UITableViewCell

- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                          configuration:(nullable JSConfigurationTableViewCell)configuration {
    return [self js_fittingHeightForCellClass:cellClass
                                   cacheByKey:nil
                                configuration:configuration];
}

- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                             cacheByKey:(nullable id<NSCopying>)key
                          configuration:(nullable JSConfigurationTableViewCell)configuration {
    if (![cellClass isSubclassOfClass:UITableViewCell.class]) {
        NSAssert(NO, @"cellClass必须是UITableViewCell类或者其子类");
    }
    return [self __js_fittingHeightForViewClass:cellClass
                                     cacheByKey:key
                                  configuration:configuration];
}

#pragma mark - UITableViewSection

- (CGFloat)js_fittingHeightForSectionClass:(Class)sectionClass
                             configuration:(nullable JSConfigurationTableViewSection)configuration {
    return [self js_fittingHeightForSectionClass:sectionClass
                                      cacheByKey:nil
                                   configuration:configuration];
}

- (CGFloat)js_fittingHeightForSectionClass:(Class)sectionClass
                                cacheByKey:(nullable id<NSCopying>)key
                             configuration:(nullable JSConfigurationTableViewSection)configuration {
    if (![sectionClass isSubclassOfClass:UITableViewHeaderFooterView.class]) {
        NSAssert(NO, @"viewClass必须是UITableViewHeaderFooterView类或者其子类");
    }
    return [self __js_fittingHeightForViewClass:sectionClass
                                     cacheByKey:key
                                  configuration:configuration];
}

#pragma mark - Private

- (CGFloat)__js_fittingHeightForViewClass:(Class)viewClass
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
        [self __js_prepareForTemplateView:templateView configuration:configuration];
        /// 计算高度
        resultHeight = [self __js_systemFittingHeightForTemplateView:templateView];
        /// 若Key存在时且realTableViewCell存在时写入内存
        if (key != nil && templateView.js_realTableViewCell != nil) {
            [fitCache setCGFloat:resultHeight forKey:key];
        }
    }
    return resultHeight;
}

- (void)__js_prepareForTemplateView:(__kindof UIView *)templateView
                      configuration:(nullable void(^)(__kindof UIView *))configuration {
    /// 真实cell
    __kindof UITableViewCell *cell = templateView.js_realTableViewCell;
    
    if (cell != nil) {
        NSLog(@"");
    }
    
    UIView *contentView = templateView.js_templateContentView;
    /// 约束布局需要给contentView添加栅栏
    if (!templateView.js_isUseFrameLayout) {
        [contentView js_addFenceConstraintIfNeeded];
    }
    CGFloat width = cell.js_width > 0 ? cell.js_width : self.js_templateContainerWidth;
    CGFloat contentWidth = cell.contentView.js_width > 0 ? cell.contentView.js_width : self.js_templateContainerWidth;
    if (templateView.js_width != width || contentView.js_width != contentWidth) {
        /// 设置View的宽度
        templateView.js_fixedSize = CGSizeMake(width, 0);
        contentView.js_fixedSize = CGSizeMake(contentWidth, 0);
        /// 更新约束的宽
        if (contentView.js_widthConstraint != nil) {
            contentView.js_widthConstraint.constant = contentWidth;
        }
        /// 强制布局, 使外部可以拿到一些控件的真实布局
        [templateView setNeedsLayout];
        [templateView layoutIfNeeded];
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
    CGFloat fittingHeight = 0;
    if (templateView.js_isUseFrameLayout) {
        fittingHeight = [templateView sizeThatFits:CGSizeMake(contentView.js_width, 0)].height;
    } else {
        fittingHeight = [contentView systemLayoutSizeFittingSize:CGSizeMake(contentView.js_width, 0)].height;
    }
    if ([templateView isKindOfClass:UITableViewCell.class] && self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        static CGFloat pixelOne = 1;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            pixelOne = 1 / UIScreen.mainScreen.scale;
        });
        fittingHeight += pixelOne;
    }
    return fittingHeight;
}

@end
