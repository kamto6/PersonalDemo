//
//  TKFtTooltipView.h
//  TKApp
//
//  Created by thinkive on 2018/3/14.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TKFtTooltipViewType) {
    TKFtTooltipViewTypeSingle = 0,//仅确认按钮
    TKFtTooltipViewTypeDouble = 1,//确认、取消按钮
};

typedef NS_ENUM(NSInteger, TKFtTooltipAlignmentType) {
    TKFtTooltipAlignmentTypeLeft = 0,//左对齐
    TKFtTooltipAlignmentTypeRight = 1,//右对齐
    TKFtTooltipAlignmentTypeCenter = 2,//中对齐
};

typedef NS_ENUM(NSInteger, TKFtTipOrientationType) {
    TKFtTipOrientationTypeLand = 0,//横屏
    TKFtTipOrientationTypePortrait = 1,//竖屏
};


@protocol TKFtTooltipViewTypeDelegate <NSObject>

@optional
/** 确认按钮代理事件 */
-(void)futureTradeTransferTooltipViewClickConfirm;
/** 取消按钮代理事件 */
-(void)futureTradeTransferTooltipViewClickCancel;
@end

@interface TKFtTooltipView : UIView

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *clickConfirmText;//设置确认按钮标题文字
@property(nonatomic,copy)NSString *cancelText;//设置取消按钮标题文字
@property(nonatomic,assign) NSInteger tipHubNum;//提示值
@property(nonatomic,assign) BOOL isShowTipHub;//是否显示提示值
@property(nonatomic,assign) TKFtTooltipAlignmentType alignmentType;//对齐方式
@property(nonatomic,assign) TKFtTipOrientationType orientationType;//对齐方式
@property(nonatomic,weak)id<TKFtTooltipViewTypeDelegate>delegate;
@property (nonatomic, copy) void (^futureTradeTransferTooltipViewClickConfirm)(void);
@property (nonatomic, copy) void (^futureTradeTransferTooltipViewClickCancel)(void);

/**
 *  title   表头内容
 *  content 内容
 *  type    类型
 *
 *  @return 实例
 */
-(instancetype)initWithTitle:(NSString *)title withContent:(NSString *)content withStyle:(TKFtTooltipViewType)type;


-(instancetype)initWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles withContent:(NSString *)content withStyle:(TKFtTooltipViewType)type;

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
