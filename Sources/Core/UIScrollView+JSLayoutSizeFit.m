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

- (__kindof UIView *)js_makeTemplateViewIfNecessaryWithViewClass:(Class)viewClass {
    NSAssert([viewClass isSubclassOfClass:UIView.class], @"viewClass必须为UIView类或者其子类");
    
    NSString *viewClassString = NSStringFromClass(viewClass);
    
    if ([self.js_allTemplateViews.allKeys containsObject:viewClassString]) {
        return [self js_templateViewForViewClass:viewClass];
    } else {
        __kindof UIView *templateView = nil;
        NSString *nibPath = [[NSBundle bundleForClass:viewClass] pathForResource:viewClassString ofType:@"nib"];
        if (nibPath) {
            templateView = [[NSBundle bundleForClass:viewClass] loadNibNamed:viewClassString owner:nil options:nil].firstObject;
        } else {
            templateView = [[viewClass alloc] initWithFrame:CGRectZero];
        }
        templateView.js_fromTemplateView = YES;
        
        NSAssert(templateView, @"生成失败, 需要查找原因");
        [self.js_allTemplateViews setObject:templateView forKey:viewClassString];
        
        return templateView;
    }
}

- (nullable __kindof UIView *)js_templateViewForViewClass:(Class)viewClass {
    NSAssert([viewClass isSubclassOfClass:UIView.class], @"viewClass必须为UIView类或者其子类");
    
    NSString *viewClassString = NSStringFromClass(viewClass);
    return [self.js_allTemplateViews objectForKey:viewClassString];
}

#pragma mark - getter

- (CGSize)js_validContentSize {
    UIEdgeInsets contentInset = self.contentInset;
    if (@available(iOS 11.0, *)) {
        contentInset = self.insetsLayoutMarginsFromSafeArea ? self.safeAreaInsets : self.adjustedContentInset;
    }
    
    CGFloat contentWidth = (self.js_width ? : self.superview.js_width) ? : self.window.bounds.size.width;
    contentWidth = contentWidth - JSUIEdgeInsetsGetHorizontalValue(contentInset);
    
    CGFloat contentHeight = (self.js_height ? : self.superview.js_height) ? : self.window.bounds.size.height;
    contentHeight = contentHeight - JSUIEdgeInsetsGetVerticalValue(contentInset);
    
    return CGSizeMake(MAX(contentWidth, 0), MAX(contentHeight, 0));
}

- (JSLayoutSizeFitCache *)js_rowSizeFitCache {
    CGSize contentSize = self.js_validContentSize;
    NSString *key = NSStringFromCGSize(contentSize);
    JSLayoutSizeFitCache *cache = [self.js_allRowSizeFitCaches objectForKey:key];
    if (!cache) {
        cache = [[JSLayoutSizeFitCache alloc] init];
        [self.js_allRowSizeFitCaches setObject:cache forKey:key];
    }
    return cache;
}

- (JSLayoutSizeFitCache *)js_sectionSizeFitCache {
    CGSize contentSize = self.js_validContentSize;
    NSString *key = NSStringFromCGSize(contentSize);
    JSLayoutSizeFitCache *cache = [self.js_allSectionSizeFitCaches objectForKey:key];
    if (!cache) {
        cache = [[JSLayoutSizeFitCache alloc] init];
        [self.js_allSectionSizeFitCaches setObject:cache forKey:key];
    }
    return cache;
}

- (NSMutableDictionary<NSString *, JSLayoutSizeFitCache *> *)js_allRowSizeFitCaches {
    NSMutableDictionary *keyCahces = objc_getAssociatedObject(self, _cmd);
    if (!keyCahces) {
        keyCahces = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, keyCahces, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return keyCahces;
}

- (NSMutableDictionary<NSString *, JSLayoutSizeFitCache *> *)js_allSectionSizeFitCaches {
    NSMutableDictionary *keyCahces = objc_getAssociatedObject(self, _cmd);
    if (!keyCahces) {
        keyCahces = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, keyCahces, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return keyCahces;
}

- (NSMutableDictionary *)js_allTemplateViews {
    NSMutableDictionary *templateViews = objc_getAssociatedObject(self, _cmd);
    if (!templateViews) {
        templateViews = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, templateViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return templateViews;
}

@end
