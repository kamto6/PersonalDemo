//
//  UITextField+PlaceHolder.m
//  TKFtSDK
//
//  Created by 揭康伟 on 2019/10/12.
//  Copyright © 2019年 com.thinkive.www. All rights reserved.
//

#import "UITextField+PlaceHolder.h"
#import <objc/runtime.h>

@implementation UITextField (PlaceHolder)

- (void)setFtplaceholderLabelColor:(UIColor *)ftplaceholderLabelColor
{
    objc_setAssociatedObject(self, @selector(ftplaceholderLabelColor), ftplaceholderLabelColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)ftplaceholderLabelColor
{
    return objc_getAssociatedObject(self, @selector(ftplaceholderLabelColor));
}

- (void)setFtplaceholderFont:(UIFont *)ftplaceholderFont
{
    objc_setAssociatedObject(self, @selector(ftplaceholderFont), ftplaceholderFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIFont *)ftplaceholderFont
{
     return objc_getAssociatedObject(self, @selector(ftplaceholderFont));
}
- (void)setFtplaceholder:(NSString *)ftplaceholder
{
    objc_setAssociatedObject(self, @selector(ftplaceholder), ftplaceholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (KSystemVersion < 13.0)
    {
         self.placeholder = ftplaceholder;
         if (self.ftplaceholderFont && [self.ftplaceholderFont isKindOfClass:[UIFont class]]) {
             [self setValue:self.ftplaceholderFont forKeyPath:@"_placeholderLabel.font"];
         }
         if (self.ftplaceholderLabelColor && [self.ftplaceholderLabelColor isKindOfClass:[UIColor class]]) {
             [self setValue:self.ftplaceholderLabelColor forKeyPath:@"_placeholderLabel.textColor"];
         }
     }else
     {
         if (ftplaceholder) {
             NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:ftplaceholder];
             if (self.ftplaceholderFont && [self.ftplaceholderFont isKindOfClass:[UIFont class]]) {
                 [attributedStr addAttribute:NSFontAttributeName value:self.ftplaceholderFont range:NSMakeRange(0, ftplaceholder.length)];
             }
             if (self.ftplaceholderLabelColor && [self.ftplaceholderLabelColor isKindOfClass:[UIColor class]]) {
                 [attributedStr addAttribute:NSForegroundColorAttributeName value:self.ftplaceholderLabelColor range:NSMakeRange(0, ftplaceholder.length)];
             }
             self.attributedPlaceholder = attributedStr;
         }
     }
}
- (NSString *)ftplaceholder
{
    return objc_getAssociatedObject(self, @selector(ftplaceholder));
}
@end
