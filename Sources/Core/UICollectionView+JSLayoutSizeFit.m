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
    NSAssert(contentWidth >= 0, @"contentWidth必须 >= 0");
    
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(contentWidth, JSLayoutSizeFitAutomaticDimension)
                                           cacheByKey:nil
                                        configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                                contentWidth:(CGFloat)contentWidth
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    NSAssert(contentWidth >= 0, @"contentWidth必须 >= 0");
    
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(contentWidth, JSLayoutSizeFitAutomaticDimension)
                                           cacheByKey:key
                                        configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                               contentHeight:(CGFloat)contentHeight
                               configuration:(nullable JSConfigurationReusableView)configuration {
    NSAssert(contentHeight >= 0, @"contentHeight必须 >= 0");
    
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(JSLayoutSizeFitAutomaticDimension, contentHeight)
                                           cacheByKey:nil
                                        configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                               contentHeight:(CGFloat)contentHeight
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    NSAssert(contentHeight >= 0, @"contentHeight必须 >= 0");
    
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
    NSAssert([viewClass isSubclassOfClass:UICollectionReusableView.class], @"viewClass必须为UICollectionReusableView类或者其子类");
    
    CGSize resultSize = CGSizeZero;
    /// FitCache
    JSLayoutSizeFitCache *fitCache = [viewClass isSubclassOfClass:UICollectionViewCell.class] ? self.js_rowSizeFitCache : self.js_sectionSizeFitCache;
    
    if (key != nil && [fitCache containsKey:key]) {
        resultSize = [fitCache CGSizeForKey:key];
    } else {
        /// 制作/获取模板View
        __kindof UICollectionReusableView *templateView = [self js_makeTemplateViewIfNecessaryWithViewClass:viewClass];
        
        /// 准备
        [self js_prepareForTemplateView:templateView contentSize:contentSize configuration:configuration];
        
        /// 计算size
        resultSize = [self js_systemFittingSizeForTemplateView:templateView];
        
        /// 设置外部的宽/高
        if (contentSize.width != JSLayoutSizeFitAutomaticDimension) {
            resultSize.width = contentSize.width;
        }
        if (contentSize.height != JSLayoutSizeFitAutomaticDimension) {
            resultSize.height = contentSize.height;
        }
        
        /// 若Key存在时则写入内存
        if (key != nil) {
            [fitCache setCGSize:resultSize forKey:key];
        }
    }
    
    return resultSize;
}

- (void)js_prepareForTemplateView:(__kindof UIView *)templateView
                      contentSize:(CGSize)contentSize
                    configuration:(nullable JSConfigurationReusableView)configuration {
    UIView *contentView = templateView.js_templateContentView;
    
    CGSize fixedSize = CGSizeZero;
    if (contentSize.width != JSLayoutSizeFitAutomaticDimension) {
        fixedSize.width = contentSize.width;
    }
    if (contentSize.height != JSLayoutSizeFitAutomaticDimension) {
        fixedSize.height = contentSize.height;
    }
    
    if (!CGSizeEqualToSize(templateView.js_fixedSize, fixedSize)) {
        templateView.js_fixedSize = fixedSize;
        contentView.js_fixedSize = fixedSize;
        
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

- (CGSize)js_systemFittingSizeForTemplateView:(__kindof UIView *)templateView {
    CGSize fittingSize = CGSizeZero;
    
    if (templateView.js_isUseFrameLayout) {
        fittingSize = [templateView sizeThatFits:templateView.js_size];
    } else {
        fittingSize = [templateView systemLayoutSizeFittingSize:templateView.js_size];
    }
    
    return fittingSize;
}

@end
