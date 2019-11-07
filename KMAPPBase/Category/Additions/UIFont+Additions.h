//
//  UIFont+Additions.h
//  Reindeer
//
//  Created by Sword on 2/7/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Additions)

- (CGFloat)ittLineHeight;

+ (UIFont*)PingFangMediumFontOfSize:(CGFloat)size;
+ (UIFont*)PingFangRegularFontOfSize:(CGFloat)size;
+ (UIFont*)PingFangLightFontOfSize:(CGFloat)size;

//文字适配
+ (UIFont *)PingFangMediumFontOfScaleSize:(CGFloat)size;
+ (UIFont*)PingFangRegularFontOfScaleSize:(CGFloat)size;
+ (UIFont*)PingFangLightFontOfScaleSize:(CGFloat)size;
@end
