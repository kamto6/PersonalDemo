//
//  UIFont+TKFtFont.m
//  TKApp
//
//  Created by thinkive on 2018/3/14.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "UIFont+TKFtFont.h"

@implementation UIFont (TKFtFont)

/**
 *  @author yyf, 17-04
 *
 *  @brief  设置搜索工具栏字体大小
 *
 *  字体大小
 */
+(UIFont *)ftsetFtToolBarFontOfFont:(CGFloat)font
{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:font * ft750Scale];
}


/**
 *  @author yyf, 17-04
 *
 *  @brief  普通字体
 *
 *  font
 */
+(UIFont *)ftk750AdaptationFont:(CGFloat)font
{
    
    return [UIFont systemFontOfSize:font * ft750Scale];
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  粗体字体
 *
 *  font
 */
+(UIFont *)ftk750AdaptationBoldFont:(CGFloat)font
{
    return [UIFont boldSystemFontOfSize:font * ft750Scale];
}

@end
