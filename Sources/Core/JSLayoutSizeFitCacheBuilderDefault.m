//
//  JSLayoutSizeFitCacheBuilderDefault.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2022/10/17.
//

#import "JSLayoutSizeFitCacheBuilderDefault.h"
#import "JSLayoutSizeFitCache.h"
#import "UIScrollView+JSLayoutSizeFit_Private.h"

@interface JSLayoutSizeFitCacheBuilderDefault ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, JSLayoutSizeFitCache *> *allSizeFitCaches;

@end

@implementation JSLayoutSizeFitCacheBuilderDefault

- (JSLayoutSizeFitCache *)fittingCacheInView:(__kindof UIView *)view {
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
    
    JSLayoutSizeFitCache *cache = [self.allSizeFitCaches objectForKey:key];
    if (!cache) {
        cache = [[JSLayoutSizeFitCache alloc] init];
        [self.allSizeFitCaches setObject:cache forKey:key];
    }
    return cache;
}

- (void)invalidateFittingCacheForCacheKey:(id<NSCopying>)cacheKey inView:(__kindof UIView *)view {
    [self.allSizeFitCaches enumerateKeysAndObjectsUsingBlock:^(NSString *key, JSLayoutSizeFitCache *value, BOOL *stop) {
        [value removeObjectForKey:cacheKey];
    }];
}

- (void)invalidateAllFittingCacheInView:(__kindof UIView *)view {
    [self.allSizeFitCaches removeAllObjects];
}

#pragma mark - Getter

- (NSMutableDictionary<NSString *, JSLayoutSizeFitCache *> *)allSizeFitCaches {
    if (!_allSizeFitCaches) {
        _allSizeFitCaches = [NSMutableDictionary dictionary];
    }
    return _allSizeFitCaches;
}

@end
