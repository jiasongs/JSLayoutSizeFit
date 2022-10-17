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

@property (nonatomic, strong) NSMutableDictionary *caches;

@end

@implementation JSLayoutSizeFitCache

- (instancetype)init {
    if (self = [super init]) {
        _lock = OS_UNFAIR_LOCK_INIT;
        _caches = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Base

- (BOOL)containsKey:(id<NSCopying>)key {
    return [self objectForKey:key] != nil;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    if (key != nil && object != nil) {
        [self addLock];
        [self.caches setObject:object forKey:key];
        [self unLock];
    }
}

- (nullable id)objectForKey:(id<NSCopying>)key {
    if (key != nil) {
        [self addLock];
        id value = [self.caches objectForKey:key];
        [self unLock];
        return value;
    }
    return nil;
}

- (void)addCachesFromCache:(JSLayoutSizeFitCache *)otherCache {
    [otherCache addLock];
    NSDictionary *dictionary = otherCache.caches ? : @{};
    [otherCache unLock];
    [self addLock];
    [self.caches addEntriesFromDictionary:dictionary];
    [self unLock];
}

#pragma mark - Remove

- (void)removeObjectForKey:(id<NSCopying>)key {
    if (key != nil) {
        [self addLock];
        [self.caches removeObjectForKey:key];
        [self unLock];
    }
}

- (void)removeAllObjects {
    [self addLock];
    [self.caches removeAllObjects];
    [self unLock];
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

#pragma mark - Lock

- (void)addLock {
    os_unfair_lock_lock(&_lock);
}

- (void)unLock {
    os_unfair_lock_unlock(&_lock);
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSLayoutSizeFitCache *newCache = [[JSLayoutSizeFitCache allocWithZone:zone] init];
    [newCache addCachesFromCache:self];
    return newCache;
}

@end
