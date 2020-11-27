//
//  JSLayoutSizeFitCache.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import "JSLayoutSizeFitCache.h"
/// JSCoreKit
#import "JSCoreCommonDefines.h"

@interface JSLayoutSizeFitCache () {
    JSLockDeclare(_lock);
}

@property (nonatomic, strong) NSMutableDictionary *cacheDictionary;

@end

@implementation JSLayoutSizeFitCache

- (instancetype)init {
    if (self = [super init]) {
        JSLockInit(_lock)
        _cacheDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Base

- (BOOL)containsKey:(id<NSCopying>)key {
    if (key) {
        JSAddLock(_lock);
        BOOL contains = [self.cacheDictionary.allKeys containsObject:key];
        JSUnLock(_lock);
        return contains;
    }
    return false;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    if (key && object) {
        JSAddLock(_lock);
        [self.cacheDictionary setObject:object forKey:key];
        JSUnLock(_lock);
    }
}

- (nullable id)objectForKey:(id<NSCopying>)key {
    if (key) {
        JSAddLock(_lock);
        id value = [self.cacheDictionary objectForKey:key];
        JSUnLock(_lock);
        return value;
    }
    return nil;
}

#pragma mark - Remove

- (void)removeObjectForKey:(id<NSCopying>)key {
    JSAddLock(_lock);
    [self.cacheDictionary removeObjectForKey:key];
    JSUnLock(_lock);
}

- (void)removeAllObjects {
    JSAddLock(_lock);
    [self.cacheDictionary removeAllObjects];
    JSUnLock(_lock);
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
