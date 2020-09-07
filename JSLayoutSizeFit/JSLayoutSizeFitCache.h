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

- (BOOL)containsKey:(id)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (nullable id)objectForKey:(NSString *)key;

- (void)removeValueForKey:(NSString *)key;
- (void)removeAllValues;

- (void)setCGFloat:(CGFloat)value forKey:(NSString *)key;
- (CGFloat)CGFloatForKey:(NSString *)key;

- (void)setCGSize:(CGSize)value forKey:(NSString *)key;
- (CGSize)CGSizeForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
