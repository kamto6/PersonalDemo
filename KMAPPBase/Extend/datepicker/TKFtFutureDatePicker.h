//
//  TKFtFutureDatePicker.h
//  TKApp_HL
//
//  Created by thinkive on 2017/8/26.
//  Copyright © 2017年 liubao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKFtFutureDatePickerDelegate <NSObject>

@optional
-(void)datePickerDoDateConfirmWithDateString:(NSString *)dateString;

@end

@interface TKFtFutureDatePicker : UIView
/** 初始化时间，格式yyyy/MM/dd */
@property (nonatomic,copy) NSString *showTimeStr;
@property (nonatomic,weak) id<TKFtFutureDatePickerDelegate>delegate;
/**
 * date 格式为yyyyMMdd
 */
-(instancetype)initWithStartDate:(NSString *)date;
/**
 同步显示字符串
 
 @param timeStr 显示字符串
 */
-(void)freshTimeStr:(NSString *)timeStr;

@end

