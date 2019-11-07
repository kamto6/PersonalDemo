//
//  TKFtUIAdapter.h
//  TKApp
//
//  Created by thinkive on 2018/3/14.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#ifndef TKFtUIAdapter_h
#define TKFtUIAdapter_h

#pragma mark - 特殊宽度定义

#define FT_NAME_LABEL_WIDTH [@"棉花1903-" sizeWithAttributes:@{NSFontAttributeName:[UIFont ftk750AdaptationFont:16]}].width+1
#define FT_BIG_FT_NAME_LABEL_WIDTH [@"m1807-C-3600" sizeWithAttributes:@{NSFontAttributeName:[UIFont ftk750AdaptationFont:16]}].width+1

#pragma mark - 以375屏幕宽做适配

#define ft750Scale (TKFT_SCREEN_WIDTH/375.0)

#define ft750AdaptationFont(size) ([UIFont ftk750AdaptationFont:size * ft750Scale])
#define ft750AdaptationBoldFont(size) ([UIFont ftk750AdaptationBoldFont:size * ft750Scale])
#define ft750AdaptationWidth(a) (a * ft750Scale)

#pragma mark - 屏幕宽高

/* 屏幕宽高 */
#define TKFT_SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define TKFT_SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height


///* 是否是 iPhoneX系列*/
//#define TKFT_IS_IPhoneX_All (TKFT_SCREEN_HEIGHT == 812 || TKFT_SCREEN_HEIGHT == 896)
///** iPhoneX安全区高度 */
//#define TKFt_BOTTOM_SAFE_HEIGHT (TKFT_IS_IPhoneX_All?34:0)

#pragma mark - 颜色
/** 颜色 */
#define TKFTRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TKFTRandomCOLOR TKFTRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),1)
/** 16进制颜色 */
#define TKFT_HEXColor(hexValue,alphaValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue]
#define TKFT_HEXCOLOR(hexValue)  TKFT_HEXColor(hexValue,1)


/*
 #define TKFTConvertColorToRGB(color) \
 ({ \
 NSArray *array = nil; \
 NSInteger numComponents = CGColorGetNumberOfComponents(color.CGColor);\
 if (numComponents == 4) { \
 const CGFloat *components = CGColorGetComponents(color.CGColor); \
 array = @[@((int)(components[0] * 255)), @((int)(components[1] * 255)), @((int)(components[2] * 255))]; \
 } \
 array; \
 })\
 */

#pragma mark - 获取交易bundle图片
/** 获取框架图片 */
#define TKFtGetBundleImageName(a) [NSString stringWithFormat:@"%@/%@",TKFtBundleName,a]


#pragma mark - 恒生

//开关打开颜色
#define SWITCH_ONTINTCOLOR [TKUIHelper colorWithHexString:@"#FF5656"]
//图层线条
#define LAYER_COLOR [TKUIHelper colorWithHexString:@"#DDDDDD"]
//红色
#define RED_TEXT_COLOR [TKUIHelper colorWithHexString:@"#FF5656"]
//白色
#define WHITE_COLOR [TKUIHelper colorWithHexString:@"#FFFFFF"]

//深灰
#define DEPTH_GRAY_TEXT_COLOR [TKUIHelper colorWithHexString:@"#666666"]





#endif /* TKFtUIAdapter_h */
