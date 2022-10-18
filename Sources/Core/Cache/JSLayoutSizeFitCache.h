//
//  JSLayoutSizeFitCache.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2022/10/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JSLayoutSizeFitCache <NSObject>

@required
- (BOOL)containsCacheKey:(id<NSCopying>)cacheKey inView:(__kindof UIView *)view;

- (nullable id)valueForCacheKey:(id<NSCopying>)cacheKey inView:(__kindof UIView *)view;

- (void)setValue:(id)value forCacheKey:(id<NSCopying>)cacheKey inView:(__kindof UIView *)view;

- (void)invalidateValueForCacheKey:(id<NSCopying>)cacheKey inView:(__kindof UIView *)view;
- (void)invalidateAllValueInView:(__kindof UIView *)view;

@end

NS_ASSUME_NONNULL_END
