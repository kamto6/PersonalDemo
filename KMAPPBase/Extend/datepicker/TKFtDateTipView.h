//
//  TKFutureTradeTransferPasswordInputView.h
//  TKApp
//
//  Created by 陈智坤 on 8/17/16.
//  Copyright © 2016 姚元丰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TKFtDateType) {
    TKFtDateTypeDay = 0,//年月日
    TKFtDateTypeMonth = 1,//年月
    TKFtDateTypeFuture = 2,//未来
};


@protocol TKFtDateTipViewDelegate <NSObject>

@optional
//确认按钮代理事件
-(void)doDataClickConfirmWithTimeString:(NSString *)timeString;

@end

@interface TKFtDateTipView : UIView
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,weak)id<TKFtDateTipViewDelegate>delegate;

/**
 实例方法

 @param frame 范围大小
 @param type 内容
 @return 类型
 */
-(instancetype)initWithFrame:(CGRect)frame andStyle:(TKFtDateType)type;

/**
 * date 格式为yyyyMMdd
 */
-(instancetype)initWithFrame:(CGRect)frame andStyle:(TKFtDateType)type andStartDate:(NSString *)date;

/**
 显示视图
 */
-(void)show;

/**
 同步展示时间

 @param str 展示时间 yyyy/MM/dd
 */
-(void)showWithDateString:(NSString *)dateStr;


/**
 隐藏视图
 */
-(void)hide;

@end
