//
//  TKFtDayDatePicker.h
//  TKApp_HL
//
//  Created by thinkive on 2017/7/15.
//  Copyright © 2017年 liubao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKFtDayDatePickerDelegate <NSObject>

@optional
-(void)datePickerDoDateConfirmWithDateString:(NSString *)dateString;

@end

@interface TKFtDayDatePicker : UIView
/** 初始化时间，格式yyyy/MM/dd */
@property (nonatomic,copy) NSString *showTimeStr;
@property (nonatomic,weak) id<TKFtDayDatePickerDelegate>delegate;

@end

