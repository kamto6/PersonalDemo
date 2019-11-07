//
//  KMNumberHelper.h
//  KMAppBase
//
//  Created by 揭康伟 on 2017/09/21.
//  Copyright © 2017 kamto. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KMNumberHelper : NSObject

/**
 *  格式化小数 xxxxxx.xx，四舍五入
 *
 *  @param doubleValue  浮点数
 *  @param decimal 保留小数点位，四舍五入
 *  @param fillZero  是否不足补0
 *
 *  @return 格式化的字符串
*/
+(NSString *)formatRoundNumber:(double)doubleValue decimal:(NSInteger)decimal fillZero:(BOOL)fillZero;

/**
 *  格式化小数 xxxxxx.xx，不四舍五入
 *
 *  @param doubleValue  浮点数
 *  @param decimal 保留小数点位
 *  @param fillZero  是否不足补0
 *
 *  @return 格式化的字符串
*/
+(NSString *)formatNumber:(double)doubleValue decimal:(NSInteger)decimal fillZero:(BOOL)fillZero;

/**
 *  清除小数后面 0
 *
 *  @param doubleValue  浮点数
 *
 *  @return 格式化的字符串
*/
+(NSString * )formatNumberWithZeroClear:(double)doubleValue;

/**
 *  格式化小数 xxxx.xx% 例如0.01 = 1%
 *
 *  @param doubleValue  浮点数
 *  @param decimal 保留小数点位，不四舍五入
 *  @param isRound  是否四舍五入
 *
 *  @return 格式化的字符串
*/
+(NSString *)formatPerNumber:(double)doubleValue decimal:(NSInteger)decimal isRound:(BOOL)isRound;


/**
 *  格式化小数 xxxx.xxx 例如xxxx.xxx  = x.xxx.xxx
 *
 *  @param doubleValue  浮点数
 *  @param decimal 保留小数点位，四舍五入
 *  @param isRound  是否四舍五入
 *
 *  @return 格式化的字符串
*/
+(NSString *)formatMoneyNumber:(double)doubleValue decimal:(NSInteger)decimal isRound:(BOOL)isRound;


@end

