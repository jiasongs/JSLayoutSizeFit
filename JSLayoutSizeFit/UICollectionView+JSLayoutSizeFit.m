//
//  UICollectionView+JSLayoutSizeFit.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import "UICollectionView+JSLayoutSizeFit.h"
#import <JSCommonDefines.h>
#import <UIView+JSLayout.h>
#import "JSLayoutSizeFitCache.h"
#import "UIScrollView+JSLayoutSizeFit.h"
#import "UIView+JSLayoutSizeFit.h"

@implementation UICollectionView (JSLayoutSizeFit)

#pragma mark - UICollectionViewCell

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                                contentWidth:(CGFloat)contentWidth
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    if (![viewClass isSubclassOfClass:UICollectionReusableView.class]) {
        NSAssert(false, @"viewClass必须是UICollectionReusableView类或者其子类");
    }
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(contentWidth, JSLayoutSizeFitInvalidDimension)
                                           cacheByKey:key
                                        configuration:configuration];
}

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                               contentHeight:(CGFloat)contentHeight
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration {
    if (![viewClass isSubclassOfClass:UICollectionReusableView.class]) {
        NSAssert(false, @"viewClass必须是UICollectionReusableView类或者其子类");
    }
    return [self __js_fittingSizeForReusableViewClass:viewClass
                                          contentSize:CGSizeMake(JSLayoutSizeFitInvalidDimension, contentHeight)
                                           cacheByKey:key
                                        configuration:configuration];
}

#pragma mark - 通用

- (CGSize)__js_fittingSizeForReusableViewClass:(Class)viewClass
                                   contentSize:(CGSize)contentSize
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
    CGSize size = [self __js_systemFittingSizeForTemplateView:templateView contentSize:contentSize];
    if (key) {
        [fitCache setCGSize:size forKey:key];
    }
    return size;
}

#pragma mark - 计算高度

- (CGSize)__js_systemFittingSizeForTemplateView:(__kindof UIView *)templateView contentSize:(CGSize)contentSize {
    CGFloat contentWidth = contentSize.width, contentHeight = contentSize.height;
    if ((contentWidth == JSLayoutSizeFitInvalidDimension && contentHeight == JSLayoutSizeFitInvalidDimension) || (contentWidth != JSLayoutSizeFitInvalidDimension && contentHeight != JSLayoutSizeFitInvalidDimension)) {
        NSAssert(false, @"contentWidth、contentHeight必须固定其中一个");
    }
    UIView *contentView = templateView.js_templateContentView;
//    
//    if (contentWidth != JSLayoutSizeFitInvalidDimension) {
//        if (templateView.js_width != contentWidth) {
//            templateView.js_width = contentWidth;
//        }
//        if (contentView && contentView.js_width != contentWidth) {
//            contentView.js_width = contentWidth;
//        }
//    } else if (contentHeight != JSLayoutSizeFitInvalidDimension) {
//        if (templateView.js_height != contentHeight) {
//            templateView.js_height = contentHeight;
//        }
//        if (contentView && contentView.js_height != contentHeight) {
//            contentView.js_height = contentHeight;
//        }
//    }
    templateView.js_width = 375;
    contentView.js_width = 375;
    CGSize fittingSize = CGSizeZero;
    if (templateView.js_enforceFrameLayout) {
        fittingSize = [templateView sizeThatFits:CGSizeMake(contentWidth, contentHeight)];
    } else {
//        NSLayoutConstraint *heightFenceConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
//        heightFenceConstraint.priority = UILayoutPriorityRequired - 1;
//        [contentView addConstraint:heightFenceConstraint];
//        if (contentView && contentView.js_widthFenceConstraint.constant != contentWidth) {
//            contentView.js_widthFenceConstraint.constant = contentWidth;
//            [contentView setNeedsUpdateConstraints];
//            [templateView setNeedsUpdateConstraints];
//        }
        contentView.js_widthFenceConstraint.constant = 100;
        [contentView setNeedsUpdateConstraints];
        [templateView setNeedsUpdateConstraints];
        fittingSize = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    }
    return CGSizeMake(JSCGFlat(fittingSize.width), JSCGFlat(fittingSize.height));
}

@end
