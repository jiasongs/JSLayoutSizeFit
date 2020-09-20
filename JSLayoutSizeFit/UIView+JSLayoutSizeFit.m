//
//  UIView+JSLayoutSizeFit.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import "UIView+JSLayoutSizeFit.h"
#import <JSCommonDefines.h>

CGFloat const JSLayoutSizeFitInvalidDimension = -1;

@interface UIView (__JSLayoutSizeFit)

@property (nullable, nonatomic, weak, readwrite) NSLayoutConstraint *js_widthFenceConstraint;

@end

@implementation UIView (JSLayoutSizeFit)

JSSynthesizeBOOLProperty(js_enforceFrameLayout, setJs_enforceFrameLayout)
JSSynthesizeBOOLProperty(js_isFromTemplateView, setJs_fromTemplateView)
JSSynthesizeIdWeakProperty(js_widthFenceConstraint, setJs_widthFenceConstraint)

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

- (void)js_addWidthFenceConstraintIfNeeded {
    if (!self.js_widthFenceConstraint) {
        NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        if (@available(iOS 10.2, *)) {
            if (self.superview) {
                widthFenceConstraint.priority = UILayoutPriorityRequired - 1;
                NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
                NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
                NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
                NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
                [self.superview addConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
            }
        }
        [self addConstraint:widthFenceConstraint];
        self.js_widthFenceConstraint = widthFenceConstraint;
    }
}

@end
