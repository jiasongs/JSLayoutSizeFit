//
//  UIView+JSLayoutSizeFit.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import "UIView+JSLayoutSizeFit.h"
#import "UIView+JSLayoutSizeFit_Private.h"
#import "JSCoreKit.h"

CGFloat const JSLayoutSizeFitAutomaticDimension = -1000;

@implementation UIView (JSLayoutSizeFit)

JSSynthesizeBOOLProperty(js_isUseFrameLayout, setJs_useFrameLayout)
JSSynthesizeBOOLProperty(js_fromTemplateView, setJs_fromTemplateView)
JSSynthesizeIdWeakProperty(js_widthConstraint, setJs_widthConstraint)
JSSynthesizeIdWeakProperty(js_heightConstraint, setJs_heightConstraint)

- (BOOL)js_isFromTemplateView {
    return self.js_fromTemplateView;
}

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
    if (self.js_heightConstraint) {
        [self removeConstraint:self.js_heightConstraint];
    }
    if (!self.js_widthConstraint) {
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1
                                                                            constant:0];
        if (@available(iOS 10.2, *)) {
            if (!self.superview) {
                return;
            }
            widthConstraint.priority = UILayoutPriorityRequired - 1;
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                toItem:self.superview
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0
                                                                              constant:0];
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                 toItem:self.superview
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0
                                                                               constant:0];
            NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                   toItem:self.superview
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1.0
                                                                                 constant:0];
            NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                               attribute:NSLayoutAttributeRight
                                                                               relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                  toItem:self.superview
                                                                               attribute:NSLayoutAttributeRight
                                                                              multiplier:1.0
                                                                                constant:0];
            [self.superview addConstraints:@[topConstraint, leftConstraint, rightConstraint, bottomConstraint]];
        }
        [self addConstraint:widthConstraint];
        self.js_widthConstraint = widthConstraint;
    }
}

- (void)js_addWidthConstraintIfNeeded {
    if (self.js_heightConstraint) {
        [self removeConstraint:self.js_heightConstraint];
    }
    if (!self.js_widthConstraint) {
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1
                                                                            constant:0];
        [self addConstraint:widthConstraint];
        self.js_widthConstraint = widthConstraint;
    }
}

- (void)js_addHeightConstraintIfNeeded {
    if (self.js_widthConstraint) {
        [self removeConstraint:self.js_widthConstraint];
    }
    if (!self.js_heightConstraint) {
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1
                                                                             constant:0];
        [self addConstraint:heightConstraint];
        self.js_heightConstraint = heightConstraint;
    }
}

@end
