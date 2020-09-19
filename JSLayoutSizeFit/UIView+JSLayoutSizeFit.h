//
//  UIView+JSLayoutSizeFit.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN CGFloat const JSLayoutSizeFitInvalidDimension;

@interface UIView (JSLayoutSizeFit)

@property (nonatomic, assign) BOOL js_enforceFrameLayout;
@property (nullable, nonatomic, readonly) __kindof UIView *js_templateContentView;
@property (nullable, nonatomic, readonly) NSLayoutConstraint *js_widthFenceConstraint;

- (void)js_addWidthFenceConstraintIfNeeded;

@end

NS_ASSUME_NONNULL_END
