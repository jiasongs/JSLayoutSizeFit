//
//  UIScrollView+JSLayoutSizeFit_Private.h
//  Pods
//
//  Created by jiasong on 2021/1/13.
//

#import <UIKit/UIKit.h>
@class JSLayoutSizeFitCache;

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (JSLayoutSizeFit_Private)

@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, JSLayoutSizeFitCache *> *js_allRowSizeFitCaches;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, JSLayoutSizeFitCache *> *js_allSectionSizeFitCaches;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, __kindof UIView *> *js_allTemplateViews;
@property (nonatomic, assign, readonly) CGFloat js_templateContainerWidth;

@end

NS_ASSUME_NONNULL_END
