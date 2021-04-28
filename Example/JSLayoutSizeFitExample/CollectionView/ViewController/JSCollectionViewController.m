//
//  JSCollectionViewController.m
//  JSLayoutSizeFitExample
//
//  Created by jiasong on 2020/9/19.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import "JSCollectionViewController.h"
#import <QMUIKit.h>
#import <Masonry.h>
#import <JSLayoutSizeFit.h>
#import "JSTestCollectionViewCell.h"
#import "JSTestCollectionReusableView.h"

@interface JSCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JSCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NavigationContentTop);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    NSString *dataPath = [NSBundle.mainBundle pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (array) {
        [self.dataSource addObjectsFromArray:array];
    }
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [collectionView js_fittingSizeForReusableViewClass:JSTestCollectionReusableView.class contentWidth:collectionView.qmui_width - 20 cacheByKey:@(section) configuration:^(__kindof UICollectionReusableView * _Nonnull reusableView) {
        NSDictionary *dic = [self.dataSource objectAtIndex:section];
        [reusableView updateViewWithData:dic atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView js_fittingSizeForReusableViewClass:JSTestCollectionViewCell.class cacheByKey:indexPath.js_sizeFitCacheKey configuration:^(__kindof JSTestCollectionViewCell * _Nonnull reusableView) {
        NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.section];
        NSArray *array = [dic objectForKey:@"likeList"];
        [reusableView updateCellWithData:[array objectAtIndex:indexPath.row] atIndexPath:indexPath];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dic = [self.dataSource objectAtIndex:section];
    NSArray *array = [dic objectForKey:@"likeList"];
    return array.count;
}

- (JSTestCollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JSTestCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(JSTestCollectionReusableView.class) forIndexPath:indexPath];
        NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.section];
        [headerView updateViewWithData:dic atIndexPath:indexPath];
        return headerView;
    }
    return nil;
}

- (JSTestCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSTestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(JSTestCollectionViewCell.class) forIndexPath:indexPath];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:@"likeList"];
    [cell updateCellWithData:[array objectAtIndex:indexPath.row] atIndexPath:indexPath];
    return cell;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = nil;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:JSTestCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(JSTestCollectionViewCell.class)];
        [_collectionView registerClass:JSTestCollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(JSTestCollectionReusableView.class)];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
