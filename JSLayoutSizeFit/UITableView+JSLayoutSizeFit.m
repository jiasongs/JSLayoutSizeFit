//
//  UITableView+JSLayoutSizeFit.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import "UITableView+JSLayoutSizeFit.h"
#import <objc/runtime.h>
#import "JSLayoutSizeFitCache.h"
#import "UIView+JSLayout.h"
#import "UIView+JSLayoutSizeFit.h"

@interface UITableView (__JSLayoutSizeFit)

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, JSLayoutSizeFitCache *> *js_allRowSizeFitCaches;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, JSLayoutSizeFitCache *> *js_allSectionSizeFitCaches;
@property (nonatomic, strong) NSMutableDictionary<NSString *, __kindof UIView *> *js_templateViews;

@end

@implementation UITableView (JSLayoutSizeFit)

#pragma mark - UITableViewCell

- (CGFloat)js_heightForCellClass:(Class)cellClass
                   configuration:(ConfigurationCell)configuration {
    return [self js_heightForCellClass:cellClass
                          contentWidth:0
                            cacheByKey:nil
                         configuration:configuration];
}

- (CGFloat)js_heightForCellClass:(Class)cellClass
                      cacheByKey:(nullable id)key
                   configuration:(ConfigurationCell)configuration {
    return [self js_heightForCellClass:cellClass
                          contentWidth:0
                            cacheByKey:key
                         configuration:configuration];
}

- (CGFloat)js_heightForCellClass:(Class)cellClass
                    contentWidth:(CGFloat)contentWidth
                   configuration:(ConfigurationCell)configuration {
    return [self js_heightForCellClass:cellClass
                          contentWidth:contentWidth
                            cacheByKey:nil
                         configuration:configuration];
}

- (CGFloat)js_heightForCellClass:(Class)cellClass
                    contentWidth:(CGFloat)contentWidth
                      cacheByKey:(nullable id)key
                   configuration:(ConfigurationCell)configuration {
    if (![cellClass isSubclassOfClass:UITableViewCell.class]) {
        NSAssert(false, @"cellClass必须是UITableViewCell类或者其子类");
    }
    return [self __js_heightForViewClass:cellClass
                            contentWidth:contentWidth
                              cacheByKey:key
                           configuration:configuration];
}

#pragma mark - UITableViewHeaderFooterView

- (CGFloat)js_heightForHeaderFooterViewClass:(Class)viewClass
                               configuration:(ConfigurationHeaderFooter)configuration {
    return [self js_heightForHeaderFooterViewClass:viewClass
                                      contentWidth:0
                                        cacheByKey:nil
                                     configuration:configuration];
}

- (CGFloat)js_heightForHeaderFooterViewClass:(Class)viewClass
                                  cacheByKey:(nullable id)key
                               configuration:(ConfigurationHeaderFooter)configuration {
    return [self js_heightForHeaderFooterViewClass:viewClass
                                      contentWidth:0
                                        cacheByKey:key
                                     configuration:configuration];
}

- (CGFloat)js_heightForHeaderFooterViewClass:(Class)viewClass
                                contentWidth:(CGFloat)contentWidth
                               configuration:(ConfigurationHeaderFooter)configuration {
    return [self js_heightForHeaderFooterViewClass:viewClass
                                      contentWidth:contentWidth
                                        cacheByKey:nil
                                     configuration:configuration];
}

- (CGFloat)js_heightForHeaderFooterViewClass:(Class)viewClass
                                contentWidth:(CGFloat)contentWidth
                                  cacheByKey:(nullable id)key
                               configuration:(ConfigurationHeaderFooter)configuration {
    if (![viewClass isSubclassOfClass:UITableViewHeaderFooterView.class]) {
        NSAssert(false, @"cellClass必须是UITableViewHeaderFooterView类或者其子类");
    }
    return [self __js_heightForViewClass:viewClass
                            contentWidth:contentWidth
                              cacheByKey:key
                           configuration:configuration];
}

#pragma mark - 通用

- (CGFloat)__js_heightForViewClass:(Class)viewClass
                      contentWidth:(CGFloat)contentWidth
                        cacheByKey:(nullable id)key
                     configuration:(void(^)(__kindof UIView *))configuration {
    JSLayoutSizeFitCache *fitCache = [viewClass isSubclassOfClass:UITableViewCell.class] ? self.js_rowHeightFitCache : self.js_sectionHeightFitCache;
    if (key && [fitCache containsKey:key]) {
        return [fitCache CGFloatForKey:key];
    }
    __kindof UIView *templateView = [self __js_templateViewForClass:viewClass];
    if (configuration) {
        configuration(templateView);
    }
    CGFloat height = [self __js_systemFittingHeightForTemplateView:templateView contentWidth:contentWidth ? : [self js_containerWidth]];
    if (key) {
        [fitCache setCGFloat:height forKey:key];
    }
    return height;
}

#pragma mark - 生成一个模板

- (__kindof UIView *)__js_templateViewForClass:(Class)viewClass {
    NSString *viewClassString = NSStringFromClass(viewClass);
    __kindof UIView *templateView = [self.js_templateViews objectForKey:viewClassString];
    if (!templateView) {
        NSString *nibPath = [[NSBundle mainBundle] pathForResource:viewClassString ofType:@"nib"];
        if (nibPath) {
            templateView = [NSBundle.mainBundle loadNibNamed:viewClassString owner:nil options:nil].firstObject;
        } else {
            templateView = [[viewClass alloc] initWithFrame:CGRectZero];
        }
        templateView.js_isTemplateLayoutView = true;
        [self.js_templateViews setObject:templateView forKey:viewClassString];
    }
    return templateView;
}

#pragma mark - 计算高度

- (CGFloat)__js_systemFittingHeightForTemplateView:(__kindof UIView *)templateView contentWidth:(CGFloat)contentWidth {
    NSAssert(contentWidth != 0, @"contentWidth不能为0!");
    UIView *contentView = nil;
    if ([templateView isKindOfClass:UITableViewCell.class]) {
        contentView = [(UITableViewCell *)templateView contentView];
    } else if ([templateView isKindOfClass:UITableViewHeaderFooterView.class]) {
        contentView = [(UITableViewHeaderFooterView *)templateView contentView];
    }
    if (templateView.js_width != contentWidth) {
        templateView.js_width = contentWidth;
    }
    if (contentView.js_width != contentWidth) {
        contentView.js_width = contentWidth;
    }
    CGFloat fittingHeight = 0;
    if (templateView.js_enforceFrameLayout) {
        fittingHeight = [templateView sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MIN)].height;
    } else {
        if (!contentView.js_widthFenceConstraint) {
            contentView.js_widthFenceConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentWidth];
            if (@available(iOS 10.2, *)) {
                contentView.js_widthFenceConstraint.priority = UILayoutPriorityRequired - 1;
                NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
                NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:contentView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
                NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
                NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
                [templateView addConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
            }
            [contentView addConstraint:contentView.js_widthFenceConstraint];
        }
        if (contentView.js_widthFenceConstraint.constant != contentWidth) {
            contentView.js_widthFenceConstraint.constant = contentWidth;
            [contentView setNeedsUpdateConstraints];
        }
        fittingHeight = [(contentView ? : templateView) systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    /// 分割线
    if ([templateView isKindOfClass:UITableViewCell.class] && self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingHeight += 1.0 / UIScreen.mainScreen.scale;
    }
    return fittingHeight;
}

- (CGFloat)js_containerWidth {
    CGFloat contentWidth = (self.js_width ? : self.superview.js_width) ? : CGRectGetWidth(UIScreen.mainScreen.bounds);
    UIEdgeInsets contentInset = self.contentInset;
    if (@available(iOS 11.0, *)) {
        contentInset = self.adjustedContentInset;
    }
    contentWidth = contentWidth - (contentInset.left + contentInset.right);
    return contentWidth;
}

#pragma mark - 懒加载

- (JSLayoutSizeFitCache *)js_rowHeightFitCache {
    CGFloat containerWidth = [self js_containerWidth];
#if TARGET_OS_MACCATALYST
    containerWidth = 0;
#endif
    JSLayoutSizeFitCache *cache = [self.js_allRowSizeFitCaches objectForKey:@(containerWidth)];
    if (!cache) {
        cache = [[JSLayoutSizeFitCache alloc] init];
        [self.js_allRowSizeFitCaches setObject:cache forKey:@(containerWidth)];
    }
    return cache;
}

- (JSLayoutSizeFitCache *)js_sectionHeightFitCache {
    CGFloat containerWidth = [self js_containerWidth];
#if TARGET_OS_MACCATALYST
    containerWidth = 0;
#endif
    JSLayoutSizeFitCache *cache = [self.js_allSectionSizeFitCaches objectForKey:@(containerWidth)];
    if (!cache) {
        cache = [[JSLayoutSizeFitCache alloc] init];
        [self.js_allSectionSizeFitCaches setObject:cache forKey:@(containerWidth)];
    }
    return cache;
}

- (NSMutableDictionary<NSNumber *, JSLayoutSizeFitCache *> *)js_allRowSizeFitCaches {
    NSMutableDictionary *keyCahces = objc_getAssociatedObject(self, _cmd);
    if (!keyCahces) {
        keyCahces = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, keyCahces, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return keyCahces;
}

- (NSMutableDictionary<NSNumber *, JSLayoutSizeFitCache *> *)js_allSectionSizeFitCaches {
    NSMutableDictionary *keyCahces = objc_getAssociatedObject(self, _cmd);
    if (!keyCahces) {
        keyCahces = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, keyCahces, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return keyCahces;
}

- (NSMutableDictionary *)js_templateViews {
    NSMutableDictionary *templateCells = objc_getAssociatedObject(self, _cmd);
    if (!templateCells) {
        templateCells = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, templateCells, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return templateCells;
}

@end
