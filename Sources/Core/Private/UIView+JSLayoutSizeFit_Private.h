//
//  UIView+JSLayoutSizeFit_Private.h
//  Pods
//
//  Created by jiasong on 2021/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JSLayoutSizeFit_Private)

@property (nonatomic, assign) BOOL js_fromTemplateView;
@property (nullable, nonatomic, weak) __kindof UITableViewCell *js_realTableViewCell;
@property (nullable, nonatomic, readonly) __kindof UIView *js_templateContentView;

@end

NS_ASSUME_NONNULL_END
