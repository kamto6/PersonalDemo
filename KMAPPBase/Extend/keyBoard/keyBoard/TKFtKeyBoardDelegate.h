//
//  TKKeyBoardDelegate.h
//  TKStockKeyBoardDemo
//
//  Created by liupm on 15-3-17.
//  Copyright (c) 2015年 liupm. All rights reserved.
//
#import <UIKit/UIKit.h>


/**
 键盘类型
 */
typedef enum
{
    TKFtKeyBoardTypeNumber = 0,//数字
    TKFtKeyBoardTypePrice  = 1,//价格
    TKFtKeyBoardTypeDecimal  = 2,//小数点
    TKFtKeyBoardTypeParameter  = 3,//超价参数
    TKFtKeyBoardTypeBack  = 4,//回撤
    TKFtKeyBoardTypeNSuperPrice  = 5,//无超价输入键盘
    TKFtKeyBoardTypeChoose  = 6,//自选股输入键盘
    TKFtKeyBoardTypeDecimalPlusMinus  = 7,//小数点 正负号
    
    TKFtKeyBoardTypeWarnPrice  = 8,//预警价格
    TKFtKeyBoardTypeWarnVolume  = 9,//预警数量
    
    TKFtKeyBoardTypeCloudCondition //云条件单
    
}TKFtKeyBoardType;


@protocol TKFtKeyBoardDelegate <NSObject>

@optional


/**
 追加字符

 @param charStr 需要追加的字符
 */
- (void)appendChar:(NSString *)charStr;

/**
 退格删除字符
 */
- (void)deleteChar;

/**
 清空值
 */
-(void)clearValue;

/**
 点击确定
 */
-(void)doConfirm;

/**
 其他键

 @param charStr 其他键
 */
-(void)doOtherChar:(NSString *)charStr;

/**
 加
 */
- (void)plusNumber;

/**
 减
 */
- (void)minusNumber;

/**
 修改正负号
 */
- (void)plusOrMinusChange;

/**
 选中标题
 
 @param index 标题下标
 @param titleStr 标题
 */
-(void)didSelectItemAtIndex:(NSInteger )index titleStr:(NSString *)titleStr;

@end
