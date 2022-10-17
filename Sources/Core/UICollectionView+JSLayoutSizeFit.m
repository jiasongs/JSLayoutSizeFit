//
//  UICollectionView+JSLayoutSizeFit.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import "UICollectionView+JSLayoutSizeFit.h"
#import "JSCoreKit.h"
#import "JSLayoutSizeFitCache.h"
#import "JSLayoutSizeFitCacheBuilder.h"
#import "JSLayoutSizeFitCacheBuilderDefault.h"
#import "UIScrollView+JSLayoutSizeFit_Private.h"
#import "UIScrollView+JSLayoutSizeFit.h"
#import "UIView+JSLayoutSizeFit_Private.h"
#import "UIView+JSLayoutSizeFit.h"

@implementation UICollectionView (JSLayoutSizeFit)

#pragma mark - LayoutSizeFitCache

- (id<JSLayoutSizeFitCacheBuilder>)js_fittingSizeCacheBuilder {
    id<JSLayoutSizeFitCacheBuilder> builder = objc_getAssociatedObject(self, @selector(js_fittingSizeCacheBuilder));
    if (!builder) {
        builder = self.js_defaultFittingSizeCache;
    }
    return builder;
}

- (void)setJs_fittingSizeCacheBuilder:(id<JSLayoutSizeFitCacheBuilder>)js_fittingSizeCacheBuilder {
    objc_setAssociatedObject(self, @selector(js_fittingSizeCacheBuilder), js_fittingSizeCacheBuilder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JSLayoutSizeFitCacheBuilderDefault *)js_defaultFittingSizeCache {
    JSLayoutSizeFitCacheBuilderDefault *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [[JSLayoutSizeFitCacheBuilderDefault alloc] init];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

- (JSLayoutSizeFitCache *)js_fittingSizeCache {
    return [self.js_fittingSizeCacheBuilder fittingCacheForContainerView:self];
}

- (void)js_invalidateFittingSizeForCacheKey:(id<NSCopying>)cacheKey {
    [self.js_fittingSizeCacheBuilder invalidateFittingCacheForCacheKey:cacheKey];
}

- (void)js_invalidateAllFittingSize {
    [self.js_fittingSizeCacheBuilder invalidateAllFittingCache];
}

#pragma mark - UICollectionReusableView

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeZero
                                           cacheByKey:key
                                        configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                    estimateWidthAtIndexPath:(NSIndexPath *)indexPath
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    return [self js_fittingSizeForReusableViewClass:viewClass
                                       contentWidth:[self js_validViewSizeAtIndexPath:indexPath].width
                                         cacheByKey:key
                                      configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                                contentWidth:(CGFloat)contentWidth
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    NSAssert(contentWidth >= 0, @"contentWidth必须 >= 0");
    
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(contentWidth, 0)
                                           cacheByKey:key
                                        configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                   estimateHeightAtIndexPath:(NSIndexPath *)indexPath
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    return [self js_fittingSizeForReusableViewClass:viewClass
                                      contentHeight:[self js_validViewSizeAtIndexPath:indexPath].height
                                         cacheByKey:key
                                      configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                               contentHeight:(CGFloat)contentHeight
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    NSAssert(contentHeight >= 0, @"contentHeight必须 >= 0");
    
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(0, contentHeight)
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
    JSLayoutSizeFitCache *fittingSizeCache = self.js_fittingSizeCache;
    
    if (key != nil && [fittingSizeCache containsKey:key]) {
        resultSize = [fittingSizeCache CGSizeForKey:key];
    } else {
        /// 制作/获取模板View
        __kindof UICollectionReusableView *templateView = [self js_makeTemplateViewIfNecessaryWithViewClass:viewClass nibName:nil inBundle:nil];
        
        /// 准备
        [self js_prepareForTemplateView:templateView contentSize:contentSize configuration:configuration];
        
        /// 计算size
        resultSize = [self js_fittingSizeForTemplateView:templateView contentSize:contentSize];
        
        /// 设置外部的宽/高
        if (contentSize.width > 0) {
            resultSize.width = contentSize.width;
        }
        if (contentSize.height > 0) {
            resultSize.height = contentSize.height;
        }
        
        /// 若Key存在时则写入内存
        if (key != nil) {
            [fittingSizeCache setCGSize:resultSize forKey:key];
        }
    }
    
    return resultSize;
}

- (void)js_prepareForTemplateView:(__kindof UIView *)templateView
                      contentSize:(CGSize)contentSize
                    configuration:(nullable JSConfigurationReusableView)configuration {
    UIView *contentView = templateView.js_templateContentView;
    
    CGSize fixedSize = templateView.js_fixedSize;
    if (contentSize.width > 0 && contentSize.height <= 0) {
        fixedSize.height = 0;
    } else if (contentSize.height > 0 && contentSize.width <= 0) {
        fixedSize.width = 0;
    }
    BOOL isChangeFixedSize = NO;
    if (CGSizeEqualToSize(contentSize, CGSizeZero)) {
        isChangeFixedSize = CGSizeEqualToSize(fixedSize, JSCoreViewFixedSizeNone);
    } else {
        isChangeFixedSize = !CGSizeEqualToSize(fixedSize, contentSize);
    }
    if (isChangeFixedSize) {
        /// 计算出最小size, 防止约束或布局冲突
        CGSize minimumSize = [self js_fittingSizeForTemplateView:templateView contentSize:contentSize finallySize:contentSize];
        
        CGSize maximumSize = CGSizeMake(MAX(contentSize.width, minimumSize.width),
                                        MAX(contentSize.height, minimumSize.height));
        templateView.js_fixedSize = maximumSize;
        contentView.js_fixedSize = maximumSize;
        
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

- (CGSize)js_fittingSizeForTemplateView:(__kindof UIView *)templateView contentSize:(CGSize)contentSize {
    return [self js_fittingSizeForTemplateView:templateView contentSize:contentSize finallySize:templateView.js_size];
}

- (CGSize)js_fittingSizeForTemplateView:(__kindof UIView *)templateView contentSize:(CGSize)contentSize finallySize:(CGSize)finallySize {
    CGSize fittingSize = CGSizeZero;
    if (templateView.js_isUseFrameLayout) {
        fittingSize = [templateView js_templateSizeThatFits:finallySize];
    } else {
        UILayoutPriority horizontalPriority = contentSize.width > 0 && contentSize.height <= 0 ? UILayoutPriorityRequired : UILayoutPriorityFittingSizeLevel;
        UILayoutPriority verticalPriority = contentSize.height > 0 && contentSize.width <= 0 ? UILayoutPriorityRequired : UILayoutPriorityFittingSizeLevel;
        fittingSize = [templateView systemLayoutSizeFittingSize:finallySize
                                  withHorizontalFittingPriority:horizontalPriority
                                        verticalFittingPriority:verticalPriority];
    }
    
    return fittingSize;
}

- (CGSize)js_validViewSizeAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = self.js_validViewSize;
    
    UIEdgeInsets sectionInset = UIEdgeInsetsZero;
    if ([self.collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
        sectionInset = [(UICollectionViewFlowLayout *)self.collectionViewLayout sectionInset];
    }
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInset = [(id<UICollectionViewDelegateFlowLayout>)self.delegate collectionView:self layout:self.collectionViewLayout insetForSectionAtIndex:indexPath.section];
    }
    
    size.width = MAX(size.width - JSUIEdgeInsetsGetHorizontalValue(sectionInset), 0);
    size.height = MAX(size.height - JSUIEdgeInsetsGetVerticalValue(sectionInset), 0);
    
    return size;
}

@end
