//
//  UIView+JSLayoutSizeFit.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN CGFloat const JSLayoutSizeFitAutomaticDimension;

@interface UIView (JSLayoutSizeFit)

@property (nonatomic, assign, getter=js_isUseFrameLayout) BOOL js_useFrameLayout;
@property (nonatomic, assign, getter=js_isFromTemplateView) BOOL js_fromTemplateView;
@property (nullable, nonatomic, readonly) __kindof UIView *js_templateContentView;
@property (nullable, nonatomic, readonly) NSLayoutConstraint *js_fenceConstraint;

- (void)js_addFenceConstraintIfNeeded;

@end

NS_ASSUME_NONNULL_END
