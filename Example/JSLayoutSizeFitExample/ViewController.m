//
//  ViewController.m
//  JSLayoutSizeFitExample
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import "ViewController.h"
#import "JSTableViewController.h"
#import "JSCollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray<QMUIStaticTableViewCellData *> *data = @[
        ({
            QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
            d.identifier = 1;
            d.text = @"TableView";
            d.height = 60;
            d.didSelectTarget = self;
            d.didSelectAction = @selector(handleDisclosureIndicatorCellEvent:);
            d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
            d;
        }),
        ({
            QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
            d.identifier = 2;
            d.text = @"CollectionView";
            d.height = 60;
            d.didSelectTarget = self;
            d.didSelectAction = @selector(handleDisclosureIndicatorCellEvent:);
            d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
            d;
        })
    ];
    QMUIStaticTableViewCellDataSource *dataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:@[data]];
    // 把数据塞给 tableView 即可
    self.tableView.qmui_staticCellDataSource = dataSource;
}

- (void)handleDisclosureIndicatorCellEvent:(QMUIStaticTableViewCellData *)cellData {
    if (cellData.identifier == 1) {
        [self.navigationController pushViewController:JSTableViewController.new animated:true];
    } else if (cellData.identifier == 2) {
        [self.navigationController pushViewController:JSCollectionViewController.new animated:true];
    }
}

@end
