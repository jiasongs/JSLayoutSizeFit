//
//  NSIndexPath+JSLayoutSizeFitKey.m
//  JSLayoutSizeFit
//
//  Created by jiasong on 2020/9/3.
//  Copyright © 2020 RuanMei. All rights reserved.
//

#import "NSIndexPath+JSLayoutSizeFitKey.h"

@implementation NSIndexPath (JSLayoutSizeFitKey)

- (NSString *)js_sizeFitCacheKey {
    NSInteger row = self.item != NSNotFound ? self.item : self.row;
    return [NSString stringWithFormat:@"section:%@|row:%@", @(self.section), @(row)];
}

@end
