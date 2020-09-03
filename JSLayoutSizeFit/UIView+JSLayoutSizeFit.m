//
//  UIView+JSLayoutSizeFit.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import "UIView+JSLayoutSizeFit.h"
#import "JSCommonDefines.h"

@implementation UIView (JSLayoutSizeFit)

JSSynthesizeBOOLProperty(js_isTemplateLayoutView, setJs_isTemplateLayoutView)
JSSynthesizeBOOLProperty(js_enforceFrameLayout, setJs_enforceFrameLayout)
JSSynthesizeIdStrongProperty(js_widthFenceConstraint, setJs_widthFenceConstraint)

@end
