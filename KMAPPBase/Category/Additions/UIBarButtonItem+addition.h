//
//  UIBarButtonItem+addition.h
//  Reindeer
//
//  Created by 揭康伟 on 2017/11/17.
//  Copyright © 2017年 Sword. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (addition)
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;
@end


@interface BackView:UIView

@property(nonatomic,strong)UIButton *btn;

@end
