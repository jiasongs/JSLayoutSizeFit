//
//  UIView+JSLayoutSizeFit_Private.h
//  Pods
//
//  Created by jiasong on 2021/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JSLayoutSizeFit_Private)

@property (nullable, nonatomic, weak) __kindof UITableViewCell *js_realTableViewCell;

@property (nonatomic, assign) BOOL js_fromTemplateView;
@property (nullable, nonatomic, readonly) __kindof UIView *js_templateContentView;
@property (nullable, nonatomic, weak) NSLayoutConstraint *js_widthConstraint;
@property (nullable, nonatomic, weak) NSLayoutConstraint *js_heightConstraint;

- (void)js_addFenceConstraintIfNeeded;

- (void)js_addWidthConstraintIfNeeded;
- (void)js_removeWidthConstraintIfNeeded;

- (void)js_addHeightConstraintIfNeeded;
- (void)js_removeHeightConstraintIfNeeded;

@end

NS_ASSUME_NONNULL_END
