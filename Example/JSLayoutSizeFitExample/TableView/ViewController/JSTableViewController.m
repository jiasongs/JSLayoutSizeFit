//
//  JSTableViewController.m
//  JSLayoutSizeFitExample
//
//  Created by jiasong on 2020/9/19.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import "JSTableViewController.h"
#import <QMUIKit.h>
#import <Masonry.h>
#import <JSLayoutSizeFit.h>
#import "ITTestTableViewCell.h"
#import "ITTestHeaderFooterView.h"

@interface JSTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NavigationContentTop);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView qmui_scrollToTopForce:true animated:true];
    NSString *dataPath = [NSBundle.mainBundle pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (array) {
        [self.dataSource addObjectsFromArray:array];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = [self.dataSource objectAtIndex:section];
    NSArray *array = [dic objectForKey:@"likeList"];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = [self.dataSource objectAtIndex:section];
    return [tableView js_fittingHeightForHeaderFooterViewClass:ITTestHeaderFooterView.class
                                                  contentWidth:tableView.qmui_width ? : JSLayoutSizeFitAutomaticDimension
                                                    cacheByKey:@(section)
                                                 configuration:^(__kindof ITTestHeaderFooterView * _Nonnull headerFooterView) {
        [headerFooterView updateViewWithData:dic inSection:section];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:@"likeList"];
    return [tableView js_fittingHeightForCellClass:ITTestTableViewCell.class
                                      contentWidth:tableView.qmui_width ? : JSLayoutSizeFitAutomaticDimension
                                        cacheByKey:indexPath.js_sizeFitCacheKey
                                     configuration:^(__kindof ITTestTableViewCell *cell) {
        [cell updateCellWithData:[array objectAtIndex:indexPath.row] atIndexPath:indexPath];
    }];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ITTestHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(ITTestHeaderFooterView.class)];
    NSDictionary *dic = [self.dataSource objectAtIndex:section];
    [headerFooterView updateViewWithData:dic inSection:section];
    return headerFooterView;
}

- (ITTestTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ITTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ITTestTableViewCell.class) forIndexPath:indexPath];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:@"likeList"];
    [cell updateCellWithData:[array objectAtIndex:indexPath.row] atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
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
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaInsetsConstantForDeviceWithNotch.bottom, 0);
        [_tableView registerClass:ITTestTableViewCell.class forCellReuseIdentifier:NSStringFromClass(ITTestTableViewCell.class)];
        [_tableView registerClass:ITTestHeaderFooterView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(ITTestHeaderFooterView.class)];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
