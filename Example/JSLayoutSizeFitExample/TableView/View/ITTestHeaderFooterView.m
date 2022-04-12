//
//  ITTestHeaderFooterView.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import "ITTestHeaderFooterView.h"
#import <Masonry.h>
#import <QMUIKit.h>
#import <JSLayoutSizeFit.h>

@implementation ITTestHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.js_useFrameLayout = YES;
        
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.frame = CGRectMake(10, 10, self.contentView.qmui_width - 10 * 2, self.contentView.qmui_height - 10 * 2);
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = [self.nameLabel sizeThatFits:CGSizeMake(size.width - 10 * 2, 0)];
    return CGSizeMake(resultSize.width, resultSize.height + 10 * 2);
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
