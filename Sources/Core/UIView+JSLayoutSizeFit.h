//
//  UIView+JSLayoutSizeFit.h
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JSLayoutSizeFit)

@property (nonatomic, assign, readonly) BOOL js_isFromTemplateView;
@property (nonatomic, assign, getter=js_isUseFrameLayout) BOOL js_useFrameLayout;

@end

NS_ASSUME_NONNULL_END
