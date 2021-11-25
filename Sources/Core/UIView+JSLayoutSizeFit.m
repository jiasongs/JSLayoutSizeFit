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

@end
