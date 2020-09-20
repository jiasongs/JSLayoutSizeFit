//
//  ITTestTableViewCell.h
//  ITHomeClient
//
//  Created by jiasong on 2020/9/1.
//  Copyright © 2020 ruanmei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITTestTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *commentCountLabel;

- (void)updateCellWithData:(id)data atIndexPath:(NSIndexPath *)atIndexPath;

@end

NS_ASSUME_NONNULL_END
