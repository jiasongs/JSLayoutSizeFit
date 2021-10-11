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
        [self addLock];
        BOOL contains = [self.cacheDictionary.allKeys containsObject:key];
        [self unLock];
        return contains;
    }
    return NO;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    if (key && object) {
        [self addLock];
        [self.cacheDictionary setObject:object forKey:key];
        [self unLock];
    }
}

- (nullable id)objectForKey:(id<NSCopying>)key {
    if (key) {
        [self addLock];
        id value = [self.cacheDictionary objectForKey:key];
        [self unLock];
        return value;
    }
    return nil;
}

#pragma mark - Remove

- (void)removeObjectForKey:(id<NSCopying>)key {
    [self addLock];
    [self.cacheDictionary removeObjectForKey:key];
    [self unLock];
}

- (void)removeAllObjects {
    [self addLock];
    [self.cacheDictionary removeAllObjects];
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

@end
