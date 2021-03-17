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
                                           cacheByKey:nil
                                        configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    if (![viewClass isSubclassOfClass:UICollectionReusableView.class]) {
        NSAssert(NO, @"viewClass必须是UICollectionReusableView类或者其子类");
    }
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                           cacheByKey:key
                                        configuration:configuration];
}

#pragma mark - Private

- (CGSize)__js_fittingSizeForReusableViewClass:(Class)viewClass
                                    cacheByKey:(nullable id<NSCopying>)key
                                 configuration:(nullable JSConfigurationReusableView)configuration {
    /// FitCache
    JSLayoutSizeFitCache *fitCache = [viewClass isSubclassOfClass:UICollectionViewCell.class] ? self.js_rowSizeFitCache : self.js_sectionSizeFitCache;
    if (key && [fitCache containsKey:key]) {
        return [fitCache CGSizeForKey:key];
    }
    /// 获取模板View
    __kindof UICollectionReusableView *templateView = [self js_templateViewForViewClass:viewClass];
    /// 准备
    [self __js_prepareForTemplateView:templateView configuration:configuration];
    /// 计算size
    CGSize size = [self __js_systemFittingSizeForTemplateView:templateView];
    /// 若Key存在时则写入内存
    if (key) {
        [fitCache setCGSize:size forKey:key];
    }
    return size;
}

- (void)__js_prepareForTemplateView:(__kindof UIView *)templateView
                      configuration:(nullable JSConfigurationReusableView)configuration {
    if ([templateView respondsToSelector:@selector(prepareForReuse)]) {
        [templateView prepareForReuse];
    }
    if (configuration) {
        configuration(templateView);
    }
}

- (CGSize)__js_systemFittingSizeForTemplateView:(__kindof UIView *)templateView {
    CGSize fittingSize = CGSizeZero;
    if (templateView.js_isUseFrameLayout) {
        fittingSize = [templateView sizeThatFits:CGSizeMake(JSLayoutSizeFitAutomaticDimension, JSLayoutSizeFitAutomaticDimension)];
    } else {
        fittingSize = [templateView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    }
    return fittingSize;
}

@end
