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
#import <JSLayoutSizeFit.h>

@implementation JSTestCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.js_useFrameLayout = YES;
        
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.frame = CGRectMake(10, 10, self.qmui_width - 10 * 2, self.qmui_height - 10 * 2);
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = [self.nameLabel sizeThatFits:CGSizeMake(size.width - 10 * 2, 0)];
    return CGSizeMake(resultSize.width, resultSize.height + 10 * 2);
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
