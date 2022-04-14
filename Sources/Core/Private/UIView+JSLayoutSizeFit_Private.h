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
@property (nullable, nonatomic, readonly) __kindof UIView *js_templateContentView;
@property (nonatomic, strong, readonly) NSMapTable<NSIndexPath *, __kindof UITableViewCell *> *js_allRealTableViewCells;

- (CGSize)js_templateSizeThatFits:(CGSize)size;

- (void)js_setRealTableViewCell:(__kindof UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (nullable __kindof UITableViewCell *)js_realTableViewCellForIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
