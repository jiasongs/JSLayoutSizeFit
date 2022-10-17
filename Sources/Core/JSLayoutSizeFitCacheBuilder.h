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
- (JSLayoutSizeFitCache *)fittingCacheForContainerView:(__kindof UIView *)containerView;
- (void)invalidateFittingCacheForCacheKey:(id<NSCopying>)cacheKey;
- (void)invalidateAllFittingCache;

@end

NS_ASSUME_NONNULL_END
