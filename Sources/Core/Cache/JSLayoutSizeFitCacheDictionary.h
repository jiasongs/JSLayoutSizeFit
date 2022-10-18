//
//  JSLayoutSizeFitCacheDictionary.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSLayoutSizeFitCacheDictionary : NSObject <NSCopying>

- (BOOL)containsKey:(id<NSCopying>)key;

- (nullable id)objectForKey:(id<NSCopying>)key;

- (void)setObject:(id)object forKey:(id<NSCopying>)key;

- (void)removeObjectForKey:(id<NSCopying>)key;
- (void)removeAllObjects;

- (void)addCachesFromCache:(JSLayoutSizeFitCacheDictionary *)otherCache;

@end

NS_ASSUME_NONNULL_END
