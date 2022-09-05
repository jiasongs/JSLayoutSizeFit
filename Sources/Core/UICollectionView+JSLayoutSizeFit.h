//
//  UICollectionView+JSLayoutSizeFit.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import <UIKit/UIKit.h>

@class JSLayoutSizeFitCache;

NS_ASSUME_NONNULL_BEGIN

typedef void(^JSConfigurationReusableView)(__kindof UICollectionReusableView *reusableView);

@interface UICollectionView (JSLayoutSizeFit)

@property (nonatomic, readonly) JSLayoutSizeFitCache *js_fittingSizeCache;

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration;

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                    estimateWidthAtIndexPath:(NSIndexPath *)indexPath
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration;

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                                contentWidth:(CGFloat)contentWidth
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration;

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                   estimateHeightAtIndexPath:(NSIndexPath *)indexPath
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration;

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                               contentHeight:(CGFloat)contentHeight
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration;

- (void)js_invalidateFittingSizeForCacheKey:(id<NSCopying>)cacheKey;
- (void)js_invalidateAllFittingSize;

@end

NS_ASSUME_NONNULL_END
