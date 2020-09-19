//
//  JSTestCollectionViewCell.m
//  JSLayoutSizeFitExample
//
//  Created by jiasong on 2020/9/19.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import "JSTestCollectionViewCell.h"
#import <Masonry.h>
#import <QMUIKit.h>

@implementation JSTestCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleButton];
        [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
//            make.width.lessThanOrEqualTo(@(375));
//            make.height.equalTo(@(40));
        }];
    }
    return self;
}

- (void)updateCellWithData:(NSDictionary *)data atIndexPath:(NSIndexPath *)atIndexPath {
//    [self.titleButton setTitle:[data objectForKey:@"likeId"] forState:UIControlStateNormal];
    [self.titleButton setTitle:[data objectForKey:@"content"] forState:UIControlStateNormal];
}

- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [[UIButton alloc] init];
        _titleButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_titleButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _titleButton.layer.borderWidth = 1;
        _titleButton.layer.borderColor = UIColor.blackColor.CGColor;
        _titleButton.titleLabel.numberOfLines = 0;
    }
    return _titleButton;
}

@end
