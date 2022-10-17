//
//  JSLayoutSizeFitCacheBuilder.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2022/10/17.
//

#import <UIKit/UIKit.h>

@class JSLayoutSizeFitCache;

NS_ASSUME_NONNULL_BEGIN

@protocol JSLayoutSizeFitCacheBuilder <NSObject>

@required
- (JSLayoutSizeFitCache *)fittingCacheInView:(__kindof UIView *)view;
- (void)invalidateFittingCacheForCacheKey:(id<NSCopying>)cacheKey inView:(__kindof UIView *)view;
- (void)invalidateAllFittingCacheInView:(__kindof UIView *)view;

@end

NS_ASSUME_NONNULL_END
