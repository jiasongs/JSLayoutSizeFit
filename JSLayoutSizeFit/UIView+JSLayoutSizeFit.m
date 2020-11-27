//
//  UIView+JSLayoutSizeFit.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import "UIView+JSLayoutSizeFit.h"
/// JSCoreKit
#import "JSCoreCommonDefines.h"

CGFloat const JSLayoutSizeFitAutomaticDimension = -1000;

@interface UIView (__JSLayoutSizeFit)

@property (nullable, nonatomic, weak, readwrite) NSLayoutConstraint *js_fenceConstraint;

@end

@implementation UIView (JSLayoutSizeFit)

JSSynthesizeBOOLProperty(js_enforceFrameLayout, setJs_enforceFrameLayout)
JSSynthesizeBOOLProperty(js_isFromTemplateView, setJs_fromTemplateView)
JSSynthesizeIdWeakProperty(js_fenceConstraint, setJs_fenceConstraint)

- (nullable __kindof UIView *)js_templateContentView {
    UIView *contentView = nil;
    if ([self isKindOfClass:UITableViewCell.class]) {
        contentView = [(UITableViewCell *)self contentView];
    } else if ([self isKindOfClass:UITableViewHeaderFooterView.class]) {
        contentView = [(UITableViewHeaderFooterView *)self contentView];
    } else if ([self isKindOfClass:UICollectionViewCell.class]) {
        contentView = [(UICollectionViewCell *)self contentView];
    }
    return contentView;
}

- (void)js_addFenceConstraintIfNeeded {
    if (!self.js_fenceConstraint) {
        NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        if (@available(iOS 10.2, *)) {
            if (self.superview) {
                widthFenceConstraint.priority = UILayoutPriorityRequired - 1;
                NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
                NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
                NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
                NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
                [self.superview addConstraints:@[topConstraint, leftConstraint, rightConstraint, bottomConstraint]];
            }
        }
        [self addConstraint:widthFenceConstraint];
        self.js_fenceConstraint = widthFenceConstraint;
    }
}

@end
