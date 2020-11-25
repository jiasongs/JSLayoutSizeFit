//
//  JSLayoutSizeFitCache.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import "JSLayoutSizeFitCache.h"
#import <os/lock.h>

@interface JSLayoutSizeFitCache () {
    os_unfair_lock _lock;
}

@property (nonatomic, strong) NSMutableDictionary *cacheDictionary;

@end

@implementation JSLayoutSizeFitCache

- (instancetype)init {
    if (self = [super init]) {
        _lock = OS_UNFAIR_LOCK_INIT;
        _cacheDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Base

- (BOOL)containsKey:(id<NSCopying>)key {
    if (key) {
        os_unfair_lock_lock(&_lock);
        BOOL contains = [self.cacheDictionary.allKeys containsObject:key];
        os_unfair_lock_unlock(&_lock);
        return contains;
    }
    return false;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    if (key && object) {
        os_unfair_lock_lock(&_lock);
        [self.cacheDictionary setObject:object forKey:key];
        os_unfair_lock_unlock(&_lock);
    }
}

- (nullable id)objectForKey:(id<NSCopying>)key {
    if (key) {
        os_unfair_lock_lock(&_lock);
        id value = [self.cacheDictionary objectForKey:key];
        os_unfair_lock_unlock(&_lock);
        return value;
    }
    return nil;
}

#pragma mark - Remove

- (void)removeObjectForKey:(id<NSCopying>)key {
    os_unfair_lock_lock(&_lock);
    [self.cacheDictionary removeObjectForKey:key];
    os_unfair_lock_unlock(&_lock);
}

- (void)removeAllObjects {
    os_unfair_lock_lock(&_lock);
    [self.cacheDictionary removeAllObjects];
    os_unfair_lock_unlock(&_lock);
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

@end
