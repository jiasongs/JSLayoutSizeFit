//
//  UIView+JSLayoutSizeFit.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JSLayoutSizeFit)

@property (nonatomic, assign) BOOL js_enforceFrameLayout;
@property (nonatomic, strong) NSLayoutConstraint *js_widthFenceConstraint;
@property (nonatomic, readonly, nullable) __kindof UIView *js_templateContentView;

@end

NS_ASSUME_NONNULL_END
