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
                
                // call super，-[UITableViewDelegate tableView:willDisplayCell:forRowAtIndexPath:] 比这个还晚，所以不用担心触发 delegate
                void (*originSelectorIMP)(id, SEL, UITableViewCell *, NSIndexPath *);
                originSelectorIMP = (void (*)(id, SEL, UITableViewCell *, NSIndexPath *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, cell, indexPath);
                
                if (cell.js_width == 0 || cell.contentView.js_width == 0) {
                    return;
                }
                
                __kindof UIView *templateView = [selfObject js_templateViewForViewClass:cell.class];
                if (templateView != nil) {
                    [templateView js_setRealTableViewCell:cell forIndexPath:indexPath];
                }
            };
        });
    });
}

#pragma mark - UITableView - Cell

- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                             cacheByKey:(nullable id<NSCopying>)key
                          configuration:(nullable JSConfigurationTableViewCell)configuration {
    return [self js_fittingHeightForCellClass:cellClass
                                  atIndexPath:nil
                                   cacheByKey:key
                                configuration:configuration];
}

- (CGFloat)js_fittingHeightForCellClass:(Class)cellClass
                            atIndexPath:(nullable NSIndexPath *)indexPath
                             cacheByKey:(nullable id<NSCopying>)key
                          configuration:(nullable JSConfigurationTableViewCell)configuration {
    NSAssert([cellClass isSubclassOfClass:UITableViewCell.class], @"cellClass必须是UITableViewCell类或者其子类");
    
    return [self __js_fittingHeightForViewClass:cellClass
                                    atIndexPath:indexPath
                                     cacheByKey:key
                                  configuration:configuration];
}

#pragma mark - UITableView - Section

- (CGFloat)js_fittingHeightForSectionClass:(Class)sectionClass
                                cacheByKey:(nullable id<NSCopying>)key
                             configuration:(nullable JSConfigurationTableViewSection)configuration {
    NSAssert([sectionClass isSubclassOfClass:UITableViewHeaderFooterView.class], @"sectionClass必须是UITableViewHeaderFooterView类或者其子类");
    
    return [self __js_fittingHeightForViewClass:sectionClass
                                    atIndexPath:nil
                                     cacheByKey:key
                                  configuration:configuration];
}

#pragma mark - Private

- (CGFloat)__js_fittingHeightForViewClass:(Class)viewClass
                              atIndexPath:(nullable NSIndexPath *)indexPath
                               cacheByKey:(nullable id<NSCopying>)key
                            configuration:(nullable void(^)(__kindof UIView *))configuration {
    CGFloat resultHeight = 0;
    /// FitCache
    JSLayoutSizeFitCache *fitCache = [viewClass isSubclassOfClass:UITableViewCell.class] ? self.js_rowSizeFitCache : self.js_sectionSizeFitCache;
    
    if (key != nil && [fitCache containsKey:key]) {
        resultHeight = [fitCache CGFloatForKey:key];
    } else {
        /// 制作/获取模板View
        __kindof UIView *templateView = [self js_makeTemplateViewIfNecessaryWithViewClass:viewClass];
        
        /// 准备
        [self js_prepareForTemplateView:templateView atIndexPath:indexPath configuration:configuration];
        
        /// 计算高度
        resultHeight = [self js_fittingHeightContainsSeparatorForTemplateView:templateView];
        
        /// 写入内存
        if (key != nil) {
            if ([templateView isKindOfClass:UITableViewHeaderFooterView.class]) {
                [fitCache setCGFloat:resultHeight forKey:key];
            } else if ([templateView isKindOfClass:UITableViewCell.class] && (!indexPath || [templateView js_realTableViewCellForIndexPath:indexPath] != nil)) {
                [fitCache setCGFloat:resultHeight forKey:key];
            }
        }
    }
    
    return resultHeight;
}

- (void)js_prepareForTemplateView:(__kindof UIView *)templateView
                      atIndexPath:(nullable NSIndexPath *)indexPath
                    configuration:(nullable void(^)(__kindof UIView *))configuration {
    UIView *contentView = templateView.js_templateContentView;
    
    CGFloat cellWidth = 0;
    CGFloat contentWidth = 0;
    CGFloat insetValue = self.style == UITableViewStyleGrouped + 1 ? JSUIEdgeInsetsGetHorizontalValue(self.layoutMargins) : 0;
    if ([templateView isKindOfClass:UITableViewHeaderFooterView.class]) {
        cellWidth = self.js_validContentSize.width;
        contentWidth = cellWidth - insetValue;
    } else if ([templateView isKindOfClass:UITableViewCell.class]) {
        UITableViewCell *realCell = indexPath ? [templateView js_realTableViewCellForIndexPath:indexPath] : nil;
        if (realCell != nil) {
            cellWidth = realCell.js_width;
            contentWidth = realCell.contentView.js_width;
        } else {
            cellWidth = self.js_validContentSize.width - insetValue;
            contentWidth = cellWidth;
        }
    }
    
    if (templateView.js_fixedSize.width != cellWidth || contentView.js_fixedSize.width != contentWidth) {
        /// 计算出最小height, 防止约束或布局冲突
        CGFloat minimumHeight = [self js_fittingHeightForTemplateView:templateView widthContentWidth:contentWidth];
        
        templateView.js_fixedSize = CGSizeMake(cellWidth, minimumHeight);
        contentView.js_fixedSize =  CGSizeMake(contentWidth, minimumHeight);
        
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

- (CGFloat)js_fittingHeightContainsSeparatorForTemplateView:(__kindof UIView *)templateView {
    UIView *contentView = templateView.js_templateContentView;
    
    CGFloat fittingHeight = [self js_fittingHeightForTemplateView:templateView widthContentWidth:contentView.js_width];
    
    if ([templateView isKindOfClass:UITableViewCell.class] && self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        static CGFloat pixelOne = 1;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            pixelOne = 1 / (UIScreen.mainScreen.scale ? : 1);
        });
        fittingHeight += pixelOne;
    }
    
    return fittingHeight;
}

- (CGFloat)js_fittingHeightForTemplateView:(__kindof UIView *)templateView
                         widthContentWidth:(CGFloat)contentWidth {
    UIView *contentView = templateView.js_templateContentView;
    
    CGFloat fittingHeight = 0;
    if (templateView.js_isUseFrameLayout) {
        fittingHeight = [templateView js_templateSizeThatFits:CGSizeMake(contentWidth, 0)].height;
    } else {
        fittingHeight = [contentView systemLayoutSizeFittingSize:CGSizeMake(contentWidth, 0)].height;
    }
    
    return fittingHeight;
}

@end
