//
//  UIButton+Additions.m
//  Reindeer
//
//  Created by Sword on 4/4/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import "UIButton+Additions.h"

@implementation UIButton(Additions)
+ (UIButton*)buttonWithTitle:(NSString*)title font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = backgroundColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateHighlighted];
    button.titleLabel.font = font;
//    [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
    return button;
}

+ (UIButton*)buttonWithTitle:(NSString*)title font:(UIFont*)font textColor:(UIColor*)textColor highlightTextColor:(UIColor*)highlightTextColor backgroundColor:(UIColor*)backgroundColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = backgroundColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitleColor:highlightTextColor forState:UIControlStateHighlighted];
    button.titleLabel.font = font;
//    button.layer.borderWidth = 0.5;
//    button.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [button.titleLabel setNumberOfLines:0];
//    [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
    return button;
}

@end
