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
JSSynthesizeIdWeakProperty(js_realTableViewCell, setJs_realTableViewCell)
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
    [self js_removeHeightConstraintIfNeeded];
    if (self.js_widthConstraint == nil) {
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1
                                                                            constant:0];
        if (@available(iOS 10.2, *)) {
            if (self.superview != nil) {
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
        }
        [self addConstraint:widthConstraint];
        self.js_widthConstraint = widthConstraint;
    }
}

- (void)js_addWidthConstraintIfNeeded {
    [self js_removeHeightConstraintIfNeeded];
    if (self.js_widthConstraint == nil) {
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

- (void)js_removeWidthConstraintIfNeeded {
    if (self.js_widthConstraint != nil) {
        [self removeConstraint:self.js_widthConstraint];
        self.js_widthConstraint = nil;
    }
}

- (void)js_addHeightConstraintIfNeeded {
    [self js_removeWidthConstraintIfNeeded];
    if (self.js_heightConstraint == nil) {
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

- (void)js_removeHeightConstraintIfNeeded {
    if (self.js_heightConstraint != nil) {
        [self removeConstraint:self.js_heightConstraint];
        self.js_heightConstraint = nil;
    }
}

@end
