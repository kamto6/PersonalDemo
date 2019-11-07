//
//  TKFtMonthDatePicker.h
//  TKApp_HL
//
//  Created by thinkive on 2017/7/15.
//  Copyright © 2017年 liubao. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol TKFtMonthDatePickerDelegate <NSObject>

@optional
-(void)datePickerDoDateConfirmWithDateString:(NSString *)dateString;

@end

@interface TKFtMonthDatePicker : UIView
/** 初始化时间，格式yyyy/MM/dd */
@property (nonatomic,copy) NSString *showTimeStr;
@property (nonatomic,weak) id<TKFtMonthDatePickerDelegate>delegate;

@end

