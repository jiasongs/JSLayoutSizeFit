//
//  UIScrollView+JSLayoutSizeFit.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import "UIScrollView+JSLayoutSizeFit.h"
#import "UIScrollView+JSLayoutSizeFit_Private.h"
#import "JSCoreKit.h"
#import "JSLayoutSizeFitCache.h"
#import "UIView+JSLayoutSizeFit_Private.h"
#import "UIView+JSLayoutSizeFit.h"

@implementation UIScrollView (JSLayoutSizeFit)

#pragma mark - 生成模板View

- (__kindof UIView *)js_templateViewForViewClass:(Class)viewClass {
    NSString *viewClassString = NSStringFromClass(viewClass);
    __kindof UIView *templateView = [self.js_templateViews objectForKey:viewClassString];
    if (!templateView) {
        NSString *nibPath = [[NSBundle bundleForClass:viewClass] pathForResource:viewClassString ofType:@"nib"];
        if (nibPath) {
            templateView = [[NSBundle bundleForClass:viewClass] loadNibNamed:viewClassString owner:nil options:nil].firstObject;
        } else {
            templateView = [[viewClass alloc] initWithFrame:CGRectZero];
        }
        templateView.js_fromTemplateView = YES;
        [self.js_templateViews setObject:templateView forKey:viewClassString];
    }
    return templateView;
}

#pragma mark - getter

- (CGFloat)js_templateContainerWidth {
    CGFloat contentWidth = (self.js_width ? : self.superview.js_width) ? : JSCoreHelper.applicationSize.width;
    UIEdgeInsets contentInset = self.contentInset;
    if (@available(iOS 11.0, *)) {
        contentInset = self.adjustedContentInset;
        if (self.insetsLayoutMarginsFromSafeArea) {
            contentInset.left = self.safeAreaInsets.left;
            contentInset.right = self.safeAreaInsets.right;
        }
    }
    contentWidth = contentWidth - (contentInset.left + contentInset.right);
    return contentWidth;
}

- (JSLayoutSizeFitCache *)js_rowSizeFitCache {
    CGFloat containerWidth = self.js_templateContainerWidth;
    JSLayoutSizeFitCache *cache = [self.js_allRowSizeFitCaches objectForKey:@(containerWidth)];
    if (!cache) {
        cache = [[JSLayoutSizeFitCache alloc] init];
        [self.js_allRowSizeFitCaches setObject:cache forKey:@(containerWidth)];
    }
    return cache;
}

- (JSLayoutSizeFitCache *)js_sectionSizeFitCache {
    CGFloat containerWidth = self.js_templateContainerWidth;
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
    NSMutableDictionary *templateViews = objc_getAssociatedObject(self, _cmd);
    if (!templateViews) {
        templateViews = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, templateViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return templateViews;
}

@end
