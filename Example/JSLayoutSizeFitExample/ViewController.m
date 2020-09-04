//
//  ViewController.m
//  JSLayoutSizeFitExample
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import "ViewController.h"
#import <QMUIKit.h>
#import <Masonry.h>
#import <JSLayoutSizeFit.h>
#import "ITTestTableViewCell.h"
#import "ITTestHeaderFooterView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView qmui_scrollToTopForce:true animated:true];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [tableView js_heightForHeaderFooterViewClass:ITTestHeaderFooterView.class contentWidth:0 cacheByKey:@(section) configuration:^(__kindof ITTestHeaderFooterView * _Nonnull headerFooterView) {
        [headerFooterView updateViewWithData:@{} inSection:section];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView js_heightForCellClass:ITTestTableViewCell.class contentWidth:0 cacheByKey:indexPath.js_sizeFitCacheKey configuration:^(__kindof ITTestTableViewCell *cell) {
        [cell updateCellWithData:@{} atIndexPath:indexPath];
    }];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ITTestHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(ITTestHeaderFooterView.class)];
    [headerFooterView updateViewWithData:@{} inSection:section];
    return headerFooterView;
}

- (ITTestTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ITTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ITTestTableViewCell.class) forIndexPath:indexPath];
    [cell updateCellWithData:@{} atIndexPath:indexPath];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        /// 需要设置为0，否则在iOS 11.0之后会产生跳动的问题
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInset = UIEdgeInsetsMake(StatusBarHeight, 0, SafeAreaInsetsConstantForDeviceWithNotch.bottom, 0);
        [_tableView registerClass:ITTestTableViewCell.class forCellReuseIdentifier:NSStringFromClass(ITTestTableViewCell.class)];
        [_tableView registerClass:ITTestHeaderFooterView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(ITTestHeaderFooterView.class)];
    }
    return _tableView;
}

@end
