//
//  JSLayoutSizeFitCache.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSLayoutSizeFitCache : NSObject

- (BOOL)containsKey:(id<NSCopying>)key;
- (void)setObject:(id)object forKey:(id<NSCopying>)key;
- (nullable id)objectForKey:(id<NSCopying>)key;

- (void)removeObjectForKey:(id<NSCopying>)key;
- (void)removeAllObjects;

- (void)setCGFloat:(CGFloat)value forKey:(id<NSCopying>)key;
- (CGFloat)CGFloatForKey:(id<NSCopying>)key;

- (void)setCGSize:(CGSize)value forKey:(id<NSCopying>)key;
- (CGSize)CGSizeForKey:(id<NSCopying>)key;

@end

NS_ASSUME_NONNULL_END
