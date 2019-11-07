//
//  TKFtShowHandBackView.h
//  TKApp_HL
//
//  Created by thinkive on 2017/5/8.
//  Copyright © 2017年 liubao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKFtShowHandBackViewDelegate <NSObject>

@optional
//确认按钮代理事件
-(void)doHandBackClickConfirm;
//取消按钮代理事件
-(void)doHandBackClickCancel;
@end
@interface TKFtShowHandBackView : UIView
@property (nonatomic,copy) NSString *content;//内容
@property (nonatomic,weak) id<TKFtShowHandBackViewDelegate>delegate;


/**
 *  @author 陈智坤
 *
 *  @brief 实例方法
 *
 *  title   表头内容
 *  content 内容
 *  type    类型
 *
 *  @return 实例
 */
-(instancetype)initWithContent:(NSString *)content;

/**
 *  @author 刘贝, 16-10-25 12:10:15
 *
 *  @brief 显示视图
 */
-(void)show;

/**
 *  @author 刘贝, 16-10-25 12:10:22
 *
 *  @brief 隐藏视图
 */
-(void)hide;

@end
