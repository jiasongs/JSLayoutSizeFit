//
//  ITTestTableViewCell.m
//  ITHomeClient
//
//  Created by jiasong on 2020/9/1.
//  Copyright © 2020 ruanmei. All rights reserved.
//

#import "ITTestTableViewCell.h"
#import <Masonry.h>
#import <QMUIKit.h>

@implementation ITTestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10).priorityHigh();
        }];
    }
    return self;
}

- (void)updateCellWithData:(id)data atIndexPath:(NSIndexPath *)atIndexPath {
    NSMutableString *label = [NSMutableString string];
    NSString *text = @"IT之家8月12日消息近期华为消费者业务CEO余承东在中国信息化百人会2020年峰会上表示华为倡议从根技术做起打造新生态";
    //获取一个随机整数范围在：[0,100]包括0，包括100
    NSInteger index = atIndexPath.row;
    for (int i = 0; i < atIndexPath.row + 100; i++) {
        NSString *temp = [text substringWithRange:NSMakeRange(index, 1)];
        [label appendString:temp];
    }
    self.titleLabel.text = label;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.qmui_shouldShowDebugColor = true;
    }
    return _headerImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
    }
    return _timeLabel;
}

- (UILabel *)commentCountLabel {
    if (!_commentCountLabel) {
        _commentCountLabel = [[UILabel alloc] init];
    }
    return _commentCountLabel;
}

@end
