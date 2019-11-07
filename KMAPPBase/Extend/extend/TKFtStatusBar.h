//
//  TKFutureTradeStatusBar.h
//  TKApp
//
//  Created by thinkive on 16/8/5.
//  Copyright © 2016年 姚元丰. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TKFtStatusBar : NSObject
/**
 *  @author yaoyf, 16-08-05 10:08:52
 *
 *  @brief 显示普通信息
 *  msg   文字
 *  image 图片
 */
+(void)showMessage:(NSDictionary *)msgDic;

/**
 *  @author yyf, 16-08-27 13:08:39
 *
 *  @brief @brief 隐藏
 */
+ (void)hide;

@end
