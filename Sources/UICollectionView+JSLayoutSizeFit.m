//
//  UICollectionView+JSLayoutSizeFit.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import "UICollectionView+JSLayoutSizeFit.h"
#import "JSCoreKit.h"
#import "JSLayoutSizeFitCache.h"
#import "UIScrollView+JSLayoutSizeFit.h"
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

#pragma mark - 通用

- (CGSize)__js_fittingSizeForReusableViewClass:(Class)viewClass
                                    cacheByKey:(nullable id<NSCopying>)key
                                 configuration:(nullable JSConfigurationReusableView)configuration {
    JSLayoutSizeFitCache *fitCache = [viewClass isSubclassOfClass:UICollectionViewCell.class] ? self.js_rowSizeFitCache : self.js_sectionSizeFitCache;
    if (key && [fitCache containsKey:key]) {
        return [fitCache CGSizeForKey:key];
    }
    __kindof UICollectionReusableView *templateView = [self js_templateViewForViewClass:viewClass];
    if ([templateView respondsToSelector:@selector(prepareForReuse)]) {
        [templateView prepareForReuse];
    }
    if (configuration) {
        configuration(templateView);
    }
    CGSize size = [self __js_systemFittingSizeForTemplateView:templateView];
    if (key) {
        [fitCache setCGSize:size forKey:key];
    }
    return size;
}

#pragma mark - 计算高度

- (CGSize)__js_systemFittingSizeForTemplateView:(__kindof UIView *)templateView {
    CGSize fittingSize = CGSizeZero;
    if (templateView.js_useFrameLayout) {
        fittingSize = [templateView sizeThatFits:CGSizeMake(JSLayoutSizeFitAutomaticDimension, JSLayoutSizeFitAutomaticDimension)];
    } else {
        fittingSize = [templateView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    }
    return fittingSize;
}

@end
