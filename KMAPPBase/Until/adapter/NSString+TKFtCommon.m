//
//  NSString+TKFtCommon.m
//  TKFtSDK
//
//  Created by 揭康伟 on 2018/11/5.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import "NSString+TKFtCommon.h"

@implementation NSString (TKFtCommon)

- (NSInteger)numberOfLinesWithFont:(UIFont*)font
                     withLineWidth:(NSInteger)lineWidth
{
    CGFloat height = [self heightWithFont:font lineWidth:lineWidth];
    NSInteger lines = height / (font.ascender - font.descender);
    return lines;
}

- (CGFloat)heightWithFont:(UIFont*)font lineWidth:(NSInteger)lineWidth;
{
    CGSize size;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        size = [self boundingRectWithSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                              attributes:@{NSFontAttributeName:font}
                                 context:nil].size;
    } else {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [self sizeWithFont:font
               constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                   lineBreakMode:NSLineBreakByTruncatingTail];
#pragma clang diagnostic pop
    }
    return size.height;
    
}

- (CGFloat)widthWithFont:(UIFont*)font lineHeight:(NSInteger)lineHeight;
{
    CGSize size;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        size = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, lineHeight)
                                 options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:@{NSFontAttributeName:font}
                                 context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [self sizeWithFont:font
               constrainedToSize:CGSizeMake(CGFLOAT_MAX, lineHeight)
                   lineBreakMode:NSLineBreakByTruncatingTail];
#pragma clang diagnostic pop
    }
    return size.width;
}

@end
