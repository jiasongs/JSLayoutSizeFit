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

- (JSLayoutSizeFitCache *)fittingCacheForContainerView:(__kindof UIView *)containerView {
    NSString *key = nil;
    if ([containerView isKindOfClass:UITableView.class]) {
        UITableView *tableView = containerView;
        key = @(tableView.js_validViewSize.width).stringValue;
    } else if ([containerView isKindOfClass:UICollectionView.class]) {
        UICollectionView *collectionView = containerView;
        if ([collectionView.collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
            UICollectionViewScrollDirection scrollDirection = [(UICollectionViewFlowLayout *)collectionView.collectionViewLayout scrollDirection];
            if (scrollDirection == UICollectionViewScrollDirectionVertical) {
                key = @(collectionView.js_validViewSize.width).stringValue;
            } else if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                key = @(collectionView.js_validViewSize.height).stringValue;
            }
        }
    } else if ([containerView isKindOfClass:UIScrollView.class]) {
        UIScrollView *scrollView = containerView;
        key = NSStringFromCGSize(scrollView.js_validViewSize);
    }
    if (!key) {
        key = NSStringFromCGSize(containerView.bounds.size);
    }

    JSLayoutSizeFitCache *cache = [self.allSizeFitCaches objectForKey:key];
    if (!cache) {
        cache = [[JSLayoutSizeFitCache alloc] init];
        [self.allSizeFitCaches setObject:cache forKey:key];
    }
    return cache;
}

- (void)invalidateFittingCacheForCacheKey:(id<NSCopying>)cacheKey {
    [self.allSizeFitCaches enumerateKeysAndObjectsUsingBlock:^(NSString *key, JSLayoutSizeFitCache *value, BOOL *stop) {
        [value removeObjectForKey:cacheKey];
    }];
}

- (void)invalidateAllFittingCache {
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
