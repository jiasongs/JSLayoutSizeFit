//
//  JSLayoutSizeFitCacheBuilder.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2022/10/17.
//

#import "JSLayoutSizeFitCacheBuilder.h"
#import "JSLayoutSizeFitCacheDictionary.h"
#import "UIScrollView+JSLayoutSizeFit_Private.h"

@interface JSLayoutSizeFitCacheBuilder ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, JSLayoutSizeFitCacheDictionary *> *allSizeFitCaches;

@end

@implementation JSLayoutSizeFitCacheBuilder

- (BOOL)containsCacheKey:(id<NSCopying>)cacheKey inView:(__kindof UIView *)view {
    JSLayoutSizeFitCacheDictionary *cache = [self _fittingValueCacheInView:view];
    return [cache containsKey:cacheKey];
}

- (nullable id)valueForCacheKey:(id<NSCopying>)cacheKey inView:(__kindof UIView *)view {
    JSLayoutSizeFitCacheDictionary *cache = [self _fittingValueCacheInView:view];
    return [cache objectForKey:cacheKey];
}

- (void)setValue:(id)value forCacheKey:(id<NSCopying>)cacheKey inView:(__kindof UIView *)view {
    JSLayoutSizeFitCacheDictionary *cache = [self _fittingValueCacheInView:view];
    [cache setObject:value forKey:cacheKey];
}

- (void)invalidateValueForCacheKey:(id<NSCopying>)cacheKey inView:(__kindof UIView *)view {
    [self.allSizeFitCaches enumerateKeysAndObjectsUsingBlock:^(NSString *key, JSLayoutSizeFitCacheDictionary *value, BOOL *stop) {
        [value removeObjectForKey:cacheKey];
    }];
}

- (void)invalidateAllValueInView:(__kindof UIView *)view {
    [self.allSizeFitCaches removeAllObjects];
}

#pragma mark - Private

- (JSLayoutSizeFitCacheDictionary *)_fittingValueCacheInView:(__kindof UIView *)view {
    NSString *key = nil;
    if ([view isKindOfClass:UITableView.class]) {
        UITableView *tableView = view;
        key = @(tableView.js_validViewSize.width).stringValue;
    } else if ([view isKindOfClass:UICollectionView.class]) {
        UICollectionView *collectionView = view;
        if ([collectionView.collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
            UICollectionViewScrollDirection scrollDirection = [(UICollectionViewFlowLayout *)collectionView.collectionViewLayout scrollDirection];
            if (scrollDirection == UICollectionViewScrollDirectionVertical) {
                key = @(collectionView.js_validViewSize.width).stringValue;
            } else if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                key = @(collectionView.js_validViewSize.height).stringValue;
            }
        }
    } else if ([view isKindOfClass:UIScrollView.class]) {
        UIScrollView *scrollView = view;
        key = NSStringFromCGSize(scrollView.js_validViewSize);
    }
    if (!key) {
        key = NSStringFromCGSize(view.bounds.size);
    }
    
    JSLayoutSizeFitCacheDictionary *cache = [self.allSizeFitCaches objectForKey:key];
    if (!cache) {
        cache = [[JSLayoutSizeFitCacheDictionary alloc] init];
        [self.allSizeFitCaches setObject:cache forKey:key];
    }
    return cache;
}

- (NSMutableDictionary<NSString *, JSLayoutSizeFitCacheDictionary *> *)allSizeFitCaches {
    if (!_allSizeFitCaches) {
        _allSizeFitCaches = [NSMutableDictionary dictionary];
    }
    return _allSizeFitCaches;
}

@end
