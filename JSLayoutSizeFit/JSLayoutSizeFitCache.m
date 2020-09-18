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

- (BOOL)containsKey:(id<NSCopying>)key {
    if (key) {
        return [self.cacheDictionary.allKeys containsObject:key];
    }
    return false;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    if (key && object) {
        [self.cacheDictionary setObject:object forKey:key];
    }
}

- (nullable id)objectForKey:(id<NSCopying>)key {
    if (key) {
        return [self.cacheDictionary objectForKey:key];
    }
    return nil;
}

#pragma mark - Remove

- (void)removeValueForKey:(id<NSCopying>)key {
    [self.cacheDictionary removeObjectForKey:key];
}

- (void)removeAllValues {
    [self.cacheDictionary removeAllObjects];
}

#pragma mark - CGFloat

- (void)setCGFloat:(CGFloat)value forKey:(id<NSCopying>)key {
    [self setObject:@(value) forKey:key];
}

- (CGFloat)CGFloatForKey:(id<NSCopying>)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:NSValue.class] || [value isKindOfClass:NSString.class]) {
#if CGFLOAT_IS_DOUBLE
        return [value doubleValue];
#else
        return [value floatValue];
#endif
    }
    return 0;
}

#pragma mark - CGSize

- (void)setCGSize:(CGSize)value forKey:(id<NSCopying>)key {
    [self setObject:[NSValue valueWithCGSize:value] forKey:key];
}

- (CGSize)CGSizeForKey:(id<NSCopying>)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:NSValue.class] || [value isKindOfClass:NSString.class]) {
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
