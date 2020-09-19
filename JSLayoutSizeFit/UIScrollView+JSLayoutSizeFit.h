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
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, __kindof UIView *> *js_templateViews;
@property (nonatomic, assign, readonly) CGFloat js_templateContainerWidth;

- (__kindof UIView *)js_templateViewForViewClass:(Class)viewClass;

@end

NS_ASSUME_NONNULL_END
