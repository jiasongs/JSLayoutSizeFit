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
#import <JSLayoutSizeFit.h>
#import <MPITextKit.h>

@implementation ITTestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10).priorityHigh();
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10).priorityHigh();
        }];
//        [self.contentView addSubview:self.titleButton];
//        [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView.mas_top).offset(10);
//            make.left.equalTo(self.contentView.mas_left).offset(10);
//            make.right.equalTo(self.contentView.mas_right).offset(-10);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10).priorityHigh();
//        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)updateCellWithData:(NSDictionary *)data atIndexPath:(NSIndexPath *)atIndexPath {
    NSDictionary *linkerInfo = [data objectForKey:@"likerInfo"];
    NSString *title = [NSString stringWithFormat:@"%@-%@-%@-%@", [linkerInfo objectForKey:@"userId"],[linkerInfo objectForKey:@"nickName"],[data objectForKey:@"likeId"],[data objectForKey:@"content"]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setFirstLineHeadIndent:0];
    [paragraphStyle setLineSpacing:8];
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName: paragraphStyle,
        NSForegroundColorAttributeName: UIColor.labelColor
    };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"傲丝度hi奥斯迪耦合剂不isad坏事户撒都我安徽搜的和阿萨德能加速的帮你加\n%@", title] attributes:attributes];
    NSInteger length = MIN(30, attributedString.length);
    NSDictionary *attributes1 = @{
        NSFontAttributeName: [UIFont systemFontOfSize:20],
        NSForegroundColorAttributeName: UIColor.labelColor
    };
    [attributedString setAttributes:attributes1 range:NSMakeRange(0, length)];
    NSDictionary *attributes2 = @{
        NSFontAttributeName: [UIFont systemFontOfSize:16],
        NSForegroundColorAttributeName: UIColor.labelColor
    };
    [attributedString setAttributes:attributes2 range:NSMakeRange(length, attributedString.length - length)];
    self.titleLabel.attributedText = attributedString;
//    [self.titleButton setTitle:title forState:UIControlStateNormal];
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize {
    return [super systemLayoutSizeFittingSize:targetSize];
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    CGSize zz = [super systemLayoutSizeFittingSize:targetSize withHorizontalFittingPriority:horizontalFittingPriority verticalFittingPriority:verticalFittingPriority];
    return zz;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.qmui_shouldShowDebugColor = YES;
    }
    return _headerImageView;
}

- (MPILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MPILabel alloc] init];
        if (@available(iOS 13.0, *)) {
            _titleLabel.textColor = UIColor.labelColor;
        }
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.titleLabel.numberOfLines = 0;
        if (@available(iOS 13.0, *)) {
            [_titleButton setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
        } else {
            [_titleButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        }
    }
    return _titleButton;
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
