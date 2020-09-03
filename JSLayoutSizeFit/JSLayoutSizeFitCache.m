//
//  JSLayoutSizeFitCache.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import "JSLayoutSizeFitCache.h"

@interface JSLayoutSizeFitCache ()

@property (nonatomic, strong) NSMutableDictionary *cacheDictionary;

@end

@implementation JSLayoutSizeFitCache

#pragma mark - Base

- (BOOL)containsKey:(id)key {
    if (key) {
        return [self.cacheDictionary objectForKey:key] != nil;
    }
    return false;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    if (key && object) {
        [self.cacheDictionary setObject:object forKey:key];
    }
}

- (nullable id)objectForKey:(NSString *)key {
    if (key) {
        return [self.cacheDictionary objectForKey:key];
    }
    return nil;
}

#pragma mark - Remove

- (void)removeForKey:(NSString *)key {
    [self.cacheDictionary removeObjectForKey:key];
}

- (void)removeAllKey {
    [self.cacheDictionary removeAllObjects];
}

#pragma mark - CGFloat

- (void)setCGFloat:(CGFloat)value forKey:(NSString *)key {
    if (key) {
        [self setObject:@(value) forKey:key];
    }
}

- (CGFloat)CGFloatForKey:(NSString *)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
#if CGFLOAT_IS_DOUBLE
        return [value doubleValue];
#else
        return [value floatValue];
#endif
    }
    return 0;
}

#pragma mark - CGSize

- (void)setCGSize:(CGSize)value forKey:(NSString *)key {
    [self setObject:[NSValue valueWithCGSize:value] forKey:key];
}

- (CGSize)CGSizeForKey:(NSString *)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:NSValue.class]) {
        return [value CGSizeValue];
    }
    return CGSizeZero;
}

#pragma mark - 懒加载

- (NSMutableDictionary *)cacheDictionary {
    if (!_cacheDictionary) {
        _cacheDictionary = [NSMutableDictionary dictionary];
    }
    return _cacheDictionary;
}

@end
