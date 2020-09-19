//
//  JSTestCollectionReusableView.h
//  JSLayoutSizeFitExample
//
//  Created by jiasong on 2020/9/19.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSTestCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *nameLabel;

- (void)updateViewWithData:(id)data atIndexPath:(NSIndexPath *)atIndexPath;

@end

NS_ASSUME_NONNULL_END
