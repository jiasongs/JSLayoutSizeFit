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
            make.right.equalTo(self.contentView.mas_right).offset(-10).priorityHigh();
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10).priorityHigh();
        }];
    }
    return self;
}

- (void)updateViewWithData:(NSDictionary *)data inSection:(NSInteger)section {
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
