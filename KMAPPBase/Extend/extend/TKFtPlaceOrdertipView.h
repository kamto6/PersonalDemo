//
//  TKFutureTradeTransferPasswordInputView.h
//  TKApp
//
//  Created by 陈智坤 on 8/17/16.
//  Copyright © 2016 姚元丰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TKFtPlaceOrdertipViewType) {
    TKFtPlaceOrdertipViewTypeSingle = 0,//仅确认按钮
    TKFtPlaceOrdertipViewTypeDouble = 1,//确认、取消按钮
};

typedef NS_ENUM(NSInteger, TKFtPlaceOrderOrientationType) {
    TKFtPlaceOrderOrientationTypeLand = 0,//横屏
    TKFtPlaceOrderOrientationTypePortrait = 1,//竖屏
};

//确认按钮
typedef void(^TipViewConfirm)(void);
//取消按钮
typedef void(^TipViewCancel)(void);

@protocol TKFtPlaceOrdertipViewTypeDelegate <NSObject>

@optional
//确认按钮代理事件
-(void)doPlaceOrdertClickConfirm;
//取消按钮代理事件
-(void)doPlaceOrdertClickCancel;
@end

@interface TKFtPlaceOrdertipView : UIView
@property (nonatomic,copy) NSString *title;//标题
@property (nonatomic,copy) NSString *content;//内容
@property (nonatomic,copy) NSString *clickConfirmText;//设置确认按钮标题文字
@property (nonatomic,copy) NSString *cancelText;//设置取消按钮标题文字
@property (nonatomic,assign) CGFloat lineSpacing;//行距
@property (nonatomic,weak) id<TKFtPlaceOrdertipViewTypeDelegate>delegate;
@property(nonatomic,assign) TKFtPlaceOrderOrientationType orientationType;//对齐方式

//点击合约查询按钮
@property(nonatomic,copy)TipViewConfirm tipViewConfirmBlock;

//点击合约查询按钮
@property(nonatomic,copy)TipViewCancel  tipViewCancelBlock;


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
-(instancetype)initWithTitle:(NSString *)title withContent:(NSString *)content withStyle:(TKFtPlaceOrdertipViewType)type;

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

/**
 *  @author 刘贝, 16-10-25 12:10:18
 *
 *  @brief 自定义设置取消.确认按钮文字颜色--注意：此方法最好放在"show"方法后实现
 *
 *  confirmColor 确认
 *  cancelColor  取消
 */
- (void)doSetUpConfirm:(UIColor *)confirmColor withCancel:(UIColor *)cancelColor;

@end
