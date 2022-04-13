//
//  UICollectionView+JSLayoutSizeFit.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JSConfigurationReusableView)(__kindof UICollectionReusableView *reusableView);

@interface UICollectionView (JSLayoutSizeFit)

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration;

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                       contentWidthInSection:(NSInteger)section
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration;

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                                contentWidth:(CGFloat)contentWidth
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration;

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                      contentHeightInSection:(NSInteger)section
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration;

- (CGSize)js_fittingSizeForReusableViewClass:(Class)viewClass
                               contentHeight:(CGFloat)contentHeight
                                  cacheByKey:(nullable id<NSCopying>)key
                               configuration:(nullable JSConfigurationReusableView)configuration;

@end

NS_ASSUME_NONNULL_END
