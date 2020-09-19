//
//  ITTestHeaderFooterView.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import "ITTestHeaderFooterView.h"
#import <Masonry.h>

@implementation ITTestHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    }
    return self;
}

- (void)updateViewWithData:(id)data inSection:(NSInteger)section {
    NSMutableString *label = [NSMutableString string];
    NSString *text = @"IT之家8月12日消息近期华为消费者业务CEO余承东在中国信息化百人会2020年峰会上表示华为倡议从根技术做起打造新生态";
    //获取一个随机整数范围在：[0,100]包括0，包括100
    NSInteger index = section;
    for (int i = 0; i < section + 100; i++) {
        NSString *temp = [text substringWithRange:NSMakeRange(index, 1)];
        [label appendString:temp];
    }
    self.nameLabel.text = label;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

@end
