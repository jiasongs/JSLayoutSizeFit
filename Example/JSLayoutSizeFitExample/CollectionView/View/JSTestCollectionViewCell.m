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
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)updateCellWithData:(NSDictionary *)data atIndexPath:(NSIndexPath *)atIndexPath {
    //    [self.titleLabel setTitle:[data objectForKey:@"likeId"] forState:UIControlStateNormal];
    //    [self.titleLabel setTitle:[data objectForKey:@"content"] forState:UIControlStateNormal];
    //    self.titleLabel.text = [data objectForKey:@"content"];
    self.titleLabel.text = [data objectForKey:@"likeId"];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.layer.borderWidth = 1;
        _titleLabel.layer.borderColor = UIColor.blackColor.CGColor;
        _titleLabel.numberOfLines = 0;
        _titleLabel.preferredMaxLayoutWidth = CGFLOAT_MAX;
    }
    return _titleLabel;
}

@end
