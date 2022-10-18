//
//  JSLayoutSizeFitCacheDictionary.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import "JSLayoutSizeFitCacheDictionary.h"
#import <os/lock.h>

@interface JSLayoutSizeFitCacheDictionary () {
    os_unfair_lock _lock;
}

@property (nonatomic, strong) NSMutableDictionary *cacheDictionary;

@end

@implementation JSLayoutSizeFitCacheDictionary

- (instancetype)init {
    if (self = [super init]) {
        _lock = OS_UNFAIR_LOCK_INIT;
        _cacheDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)containsKey:(id<NSCopying>)key {
    return [self objectForKey:key] != nil;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    if (key != nil && object != nil) {
        [self addLock];
        [self.cacheDictionary setObject:object forKey:key];
        [self unLock];
    }
}

- (nullable id)objectForKey:(id<NSCopying>)key {
    if (key != nil) {
        [self addLock];
        id value = [self.cacheDictionary objectForKey:key];
        [self unLock];
        return value;
    }
    return nil;
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    if (key != nil) {
        [self addLock];
        [self.cacheDictionary removeObjectForKey:key];
        [self unLock];
    }
}

- (void)removeAllObjects {
    [self addLock];
    [self.cacheDictionary removeAllObjects];
    [self unLock];
}

- (void)addCachesFromCache:(JSLayoutSizeFitCacheDictionary *)otherCache {
    [otherCache addLock];
    NSDictionary *dictionary = otherCache.cacheDictionary ? : @{};
    [otherCache unLock];
    [self addLock];
    [self.cacheDictionary addEntriesFromDictionary:dictionary];
    [self unLock];
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
    JSLayoutSizeFitCacheDictionary *newCache = [[JSLayoutSizeFitCacheDictionary allocWithZone:zone] init];
    [newCache addCachesFromCache:self];
    return newCache;
}

@end
