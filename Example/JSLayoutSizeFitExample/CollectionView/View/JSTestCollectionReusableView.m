//
//  JSTestCollectionReusableView.m
//  JSLayoutSizeFitExample
//
//  Created by jiasong on 2020/9/19.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import "JSTestCollectionReusableView.h"
#import <Masonry.h>
#import <QMUIKit.h>

@implementation JSTestCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(10).priorityHigh();
            make.right.equalTo(self.mas_right).offset(-10).priorityHigh();
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
    }
    return self;
}

- (void)updateViewWithData:(NSDictionary *)data atIndexPath:(NSIndexPath *)atIndexPath {
    self.nameLabel.text = [data objectForKey:@"content"];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

@end
