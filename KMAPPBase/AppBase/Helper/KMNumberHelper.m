//
//  KMNumberHelper.m
//  KMAppBase
//
//  Created by 揭康伟 on 2017/09/21.
//  Copyright © 2017 kamto. All rights reserved.
//

#import "KMNumberHelper.h"

@implementation KMNumberHelper

/**
 *  格式化小数 xxxxxx.xx，四舍五入
 *
 *  @param doubleValue  浮点数
 *  @param decimal 保留小数点位
 *  @param fillZero  是否不足补0
 *
 *  @return 格式化的字符串
 */
+(NSString *)formatRoundNumber:(double)doubleValue decimal:(NSInteger)decimal fillZero:(BOOL)fillZero
{
    //    doubleValue = round(doubleValue * pow(10, decimal))/pow(10, decimal);
    //    NSNumber *number = @(doubleValue);
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:doubleValue];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    if (fillZero)
    {
        NSMutableString *formatterString = [NSMutableString stringWithString:@"0."];
        for (NSInteger i = 0; i < decimal; ++i) {
            [formatterString appendString:@"0"];
        }
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setPositiveFormat:formatterString];
        return [formatter stringFromNumber:roundedOunces];
    }else
    {
        return [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
}

/**
 *  格式化小数 xxxxxx.xx，不四舍五入
 *
 *  @param doubleValue  浮点数
 *  @param decimal 保留小数点位
 *  @param fillZero  是否不足补0
 *
 *  @return 格式化的字符串
*/
+(NSString *)formatNumber:(double)doubleValue decimal:(NSInteger)decimal fillZero:(BOOL)fillZero
{
//    doubleValue = truncf(doubleValue * pow(10, decimal))/pow(10, decimal);
//    NSNumber *number = @(doubleValue);
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:doubleValue];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    if (fillZero)
    {
        NSMutableString *formatterString = [NSMutableString stringWithString:@"0."];
        for (NSInteger i = 0; i < decimal; ++i) {
            [formatterString appendString:@"0"];
        }
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setPositiveFormat:formatterString];
        return [formatter stringFromNumber:roundedOunces];
    }else
    {
        return [NSString stringWithFormat:@"%@",roundedOunces];
    }
}

/**
 *  清除小数后面 0
 *
 *  @param doubleValue  浮点数
 *
 *  @return 格式化的字符串
*/
+(NSString * )formatNumberWithZeroClear:(double)doubleValue
{
   return [NSString stringWithFormat:@"%@",@(doubleValue)];
}

/**
 *  格式化小数 xxxx.xx% 例如0.01 = 1%
 *
 *  @param doubleValue  浮点数
 *  @param decimal 保留小数点位
 *  @param isRound  是否四舍五入
 *
 *  @return 格式化的字符串
*/
+(NSString *)formatPerNumber:(double)doubleValue decimal:(NSInteger)decimal isRound:(BOOL)isRound
{
    NSString *perNumStr;
    if (isRound)
    {
        perNumStr = [self formatRoundNumber:doubleValue*100 decimal:decimal fillZero:YES];
    }else
    {
        perNumStr = [self formatNumber:doubleValue*100 decimal:decimal fillZero:YES];
    }
    
    return [NSString stringWithFormat:@"%@%@",perNumStr,@"%"];
}

/**
 *  格式化小数 xxxx.xxx 例如xxxx.xxx  = x.xxx.xxx
 *
 *  @param doubleValue  浮点数
 *  @param decimal 保留小数点位，四舍五入
 *  @param isRound  是否四舍五入
 *  @return 格式化的字符串
*/
+(NSString *)formatMoneyNumber:(double)doubleValue decimal:(NSInteger)decimal isRound:(BOOL)isRound
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:isRound?NSRoundPlain:NSRoundDown scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:doubleValue];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSMutableString *formatterString = [NSMutableString stringWithString:@",###."];
    for (NSInteger i = 0; i < decimal; ++i) {
        [formatterString appendString:@"0"];
    }
    [formatter setPositiveFormat:formatterString];
    
    return [formatter stringFromNumber:roundedOunces];
}


@end
