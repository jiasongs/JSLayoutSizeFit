//
//  UIScrollView+JSLayoutSizeFit.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import <UIKit/UIKit.h>
@class JSLayoutSizeFitCache;

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (JSLayoutSizeFit)

@property (nonatomic, readonly) JSLayoutSizeFitCache *js_rowSizeFitCache;
@property (nonatomic, readonly) JSLayoutSizeFitCache *js_sectionSizeFitCache;

- (__kindof UIView *)js_makeTemplateViewIfNecessaryWithViewClass:(Class)viewClass;
- (nullable __kindof UIView *)js_templateViewForViewClass:(Class)viewClass;

@end

NS_ASSUME_NONNULL_END
