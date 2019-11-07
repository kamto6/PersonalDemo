//
//  DateUtil.h
//  ZHJCalendar
//
//  Created by huajian zhou on 12-4-12.
//  Copyright (c) 2012年 Sword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJDateUtil : NSObject
//判断是否是闰年
+ (BOOL)isLeapYear:(NSInteger)year;
/*
 * @abstract caculate number of days by specified month and current year
 * @paras year range between 1 and 12
 */
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month;
/*
 * @abstract caculate number of days by specified month and year
 * @paras year range between 1 and 12
 */
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger) year;

+ (NSInteger)getCurrentYear;

+ (NSInteger)getCurrentMonth;

+ (NSInteger)getCurrentDay;

+ (NSInteger)getYearWithDate:(NSDate*)date;

+ (NSInteger)getMonthWithDate:(NSDate*)date;

+ (NSInteger)getDayWithDate:(NSDate*)date;

+ (NSDate*)dateSinceNowWithInterval:(NSInteger)dayInterval;

@end
