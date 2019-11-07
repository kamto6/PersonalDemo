//
//  UIButton+Additions.h
//  Reindeer
//
//  Created by Sword on 4/4/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton(Additions)

+ (UIButton*)buttonWithTitle:(NSString*)title font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor;

+ (UIButton*)buttonWithTitle:(NSString*)title font:(UIFont*)font textColor:(UIColor*)textColor highlightTextColor:(UIColor*)highlightTextColor backgroundColor:(UIColor*)backgroundColor;

@end
