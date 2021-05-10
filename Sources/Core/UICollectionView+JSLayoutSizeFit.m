//
//  UICollectionView+JSLayoutSizeFit.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import "UICollectionView+JSLayoutSizeFit.h"
#import "JSCoreKit.h"
#import "JSLayoutSizeFitCache.h"
#import "UIScrollView+JSLayoutSizeFit_Private.h"
#import "UIScrollView+JSLayoutSizeFit.h"
#import "UIView+JSLayoutSizeFit_Private.h"
#import "UIView+JSLayoutSizeFit.h"

@implementation UICollectionView (JSLayoutSizeFit)

#pragma mark - UICollectionViewCell

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                               configuration:(nullable JSConfigurationReusableView)configuration {
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(JSLayoutSizeFitAutomaticDimension, JSLayoutSizeFitAutomaticDimension)
                                           cacheByKey:nil
                                        configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(JSLayoutSizeFitAutomaticDimension, JSLayoutSizeFitAutomaticDimension)
                                           cacheByKey:key
                                        configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                                contentWidth:(CGFloat)contentWidth
                               configuration:(nullable JSConfigurationReusableView)configuration {
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(contentWidth, JSLayoutSizeFitAutomaticDimension)
                                           cacheByKey:nil
                                        configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                                contentWidth:(CGFloat)contentWidth
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(contentWidth, JSLayoutSizeFitAutomaticDimension)
                                           cacheByKey:key
                                        configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                               contentHeight:(CGFloat)contentHeight
                               configuration:(nullable JSConfigurationReusableView)configuration {
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(JSLayoutSizeFitAutomaticDimension, contentHeight)
                                           cacheByKey:nil
                                        configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                               contentHeight:(CGFloat)contentHeight
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(JSLayoutSizeFitAutomaticDimension, contentHeight)
                                           cacheByKey:key
                                        configuration:configuration];
}

#pragma mark - Private

- (CGSize)__js_fittingSizeForReusableViewClass:(Class)viewClass
                                   contentSize:(CGSize)contentSize
                                    cacheByKey:(nullable id<NSCopying>)key
                                 configuration:(nullable JSConfigurationReusableView)configuration {
    if (![viewClass isSubclassOfClass:UICollectionReusableView.class]) {
        NSAssert(NO, @"viewClass必须是UICollectionReusableView类或者其子类");
    }
    /// FitCache
    JSLayoutSizeFitCache *fitCache = [viewClass isSubclassOfClass:UICollectionViewCell.class] ? self.js_rowSizeFitCache : self.js_sectionSizeFitCache;
    if (key && [fitCache containsKey:key]) {
        return [fitCache CGSizeForKey:key];
    }
    /// 获取模板View
    __kindof UICollectionReusableView *templateView = [self js_templateViewForViewClass:viewClass];
    /// 准备
    [self __js_prepareForTemplateView:templateView contentSize:contentSize configuration:configuration];
    /// 计算size
    CGSize size = [self __js_systemFittingSizeForTemplateView:templateView];
    /// 若Key存在时则写入内存
    if (key) {
        [fitCache setCGSize:size forKey:key];
    }
    return size;
}

- (void)__js_prepareForTemplateView:(__kindof UIView *)templateView
                        contentSize:(CGSize)contentSize
                      configuration:(nullable JSConfigurationReusableView)configuration {
    CGSize finalContentSize = CGSizeZero;
    if (contentSize.width != JSLayoutSizeFitAutomaticDimension) {
        finalContentSize.width = contentSize.width;
    }
    if (contentSize.height != JSLayoutSizeFitAutomaticDimension) {
        finalContentSize.height = contentSize.height;
    }
    UIView *contentView = templateView.js_templateContentView;
    if (templateView.js_width != finalContentSize.width) {
        templateView.js_width = finalContentSize.width;
    }
    if (templateView.js_height != finalContentSize.height) {
        templateView.js_height = finalContentSize.height;
    }
    if (contentView.js_width != finalContentSize.width) {
        contentView.js_width = finalContentSize.width;
    }
    if (contentView.js_height != finalContentSize.height) {
        contentView.js_height = finalContentSize.height;
    }
    
    if ([templateView respondsToSelector:@selector(prepareForReuse)]) {
        [templateView prepareForReuse];
    }
    if (configuration) {
        configuration(templateView);
    }
}

- (CGSize)__js_systemFittingSizeForTemplateView:(__kindof UIView *)templateView {
    UIView *contentView = templateView.js_templateContentView ? : templateView;
    CGSize finalContentSize = templateView.bounds.size;
    if (contentView.js_width <= 0) {
        finalContentSize.width = JSLayoutSizeFitAutomaticDimension;
    }
    if (contentView.js_height <= 0) {
        finalContentSize.height = JSLayoutSizeFitAutomaticDimension;
    }
    CGSize fittingSize = CGSizeZero;
    if (templateView.js_isUseFrameLayout) {
        fittingSize = [templateView sizeThatFits:finalContentSize];
    } else {
        if (finalContentSize.width == JSLayoutSizeFitAutomaticDimension && finalContentSize.height == JSLayoutSizeFitAutomaticDimension) {
            if (contentView.js_heightConstraint) {
                [contentView removeConstraint:contentView.js_heightConstraint];
            }
            if (contentView.js_widthConstraint) {
                [contentView removeConstraint:contentView.js_widthConstraint];
            }
            fittingSize = [templateView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        } else {
            if (finalContentSize.width == JSLayoutSizeFitAutomaticDimension) {
                [contentView js_addHeightConstraintIfNeeded];
                if (contentView.js_heightConstraint.constant != finalContentSize.height) {
                    contentView.js_heightConstraint.constant = finalContentSize.height;
                }
            } else {
                [contentView js_addWidthConstraintIfNeeded];
                if (contentView.js_widthConstraint.constant != finalContentSize.width) {
                    contentView.js_widthConstraint.constant = finalContentSize.width;
                }
            }
            fittingSize = [templateView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        }
    }
    return fittingSize;
}

@end
