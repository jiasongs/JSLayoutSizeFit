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
                                       contentWidth:[self js_validContentSizeAtIndexPath:indexPath].width
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
                                      contentHeight:[self js_validContentSizeAtIndexPath:indexPath].height
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
        resultSize = [self js_fittingSizeForTemplateView:templateView];
        
        /// 设置外部的宽/高
        if (contentSize.width > 0) {
            resultSize.width = contentSize.width;
        }
        if (contentSize.height > 0) {
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
    
    if (!CGSizeEqualToSize(templateView.js_fixedSize, contentSize)) {
        /// 计算出最小size, 防止约束或布局冲突
        CGSize minimumSize = [self js_fittingSizeForTemplateView:templateView withContentSize:contentSize];
        
        CGSize fixedSize = CGSizeMake(MAX(contentSize.width, minimumSize.width),
                                      MAX(contentSize.height, minimumSize.height));
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

- (CGSize)js_fittingSizeForTemplateView:(__kindof UIView *)templateView {
    return [self js_fittingSizeForTemplateView:templateView withContentSize:templateView.js_size];
}

- (CGSize)js_fittingSizeForTemplateView:(__kindof UIView *)templateView
                        withContentSize:(CGSize)contentSize {
    CGSize fittingSize = CGSizeZero;
    if (templateView.js_isUseFrameLayout) {
        fittingSize = [templateView js_templateSizeThatFits:contentSize];
    } else {
        fittingSize = [templateView systemLayoutSizeFittingSize:contentSize];
    }
    
    return fittingSize;
}

- (CGSize)js_validContentSizeAtIndexPath:(NSIndexPath *)indexPath {
    CGSize contentSize = self.js_validContentSize;
    
    UIEdgeInsets sectionInset = UIEdgeInsetsZero;
    if ([self.collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
        sectionInset = [(UICollectionViewFlowLayout *)self.collectionViewLayout sectionInset];
    }
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInset = [(id<UICollectionViewDelegateFlowLayout>)self.delegate collectionView:self layout:self.collectionViewLayout insetForSectionAtIndex:indexPath.section];
    }
    
    contentSize.width = MAX(contentSize.width - JSUIEdgeInsetsGetHorizontalValue(sectionInset), 0);
    contentSize.height = MAX(contentSize.height - JSUIEdgeInsetsGetVerticalValue(sectionInset), 0);
    
    return contentSize;
}

@end
