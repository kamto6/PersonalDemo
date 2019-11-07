//
//  UIFont+Additions.m
//  Reindeer
//
//  Created by Sword on 2/7/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//
#define IOS9 [[UIDevice currentDevice].systemVersion floatValue] >=9
#import "UIFont+Additions.h"

@implementation UIFont (Additions)

- (CGFloat)ittLineHeight
{
    return (self.ascender - self.descender);
}

+ (UIFont*)PingFangMediumFontOfSize:(CGFloat)size{
    if (IOS9) {
        return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    }else{
        return [UIFont systemFontOfSize:size];
    }
}
+ (UIFont*)PingFangRegularFontOfSize:(CGFloat)size{
    if (IOS9) {
        return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }else{
        return [UIFont systemFontOfSize:size];
    }
}
+ (UIFont*)PingFangLightFontOfSize:(CGFloat)size{
    if (IOS9) {
        return [UIFont fontWithName:@"PingFangSC-Light" size:size];
    }else{
        return [UIFont systemFontOfSize:size];
    }
}
+ (UIFont *)PingFangMediumFontOfScaleSize:(CGFloat)size{
    //基于6的比例
    size = iPoneScale*size;
    if (IOS9) {
        return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    }else{
        return [UIFont systemFontOfSize:size];
    }
}
+ (UIFont*)PingFangRegularFontOfScaleSize:(CGFloat)size{
     size = iPoneScale*size;
    if (IOS9) {
        return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }else{
        return [UIFont systemFontOfSize:size];
    }
}
+ (UIFont*)PingFangLightFontOfScaleSize:(CGFloat)size{
     size = iPoneScale*size;
    if (IOS9) {
        return [UIFont fontWithName:@"PingFangSC-Light" size:size];
    }else{
        return [UIFont systemFontOfSize:size];
    }
}

@end
