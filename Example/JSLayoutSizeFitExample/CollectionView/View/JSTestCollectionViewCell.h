//
//  JSTestCollectionViewCell.h
//  JSLayoutSizeFitExample
//
//  Created by jiasong on 2020/9/19.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSTestCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *titleButton;

- (void)updateCellWithData:(id)data atIndexPath:(NSIndexPath *)atIndexPath;

@end

NS_ASSUME_NONNULL_END
