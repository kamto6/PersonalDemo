//
//  TKFtToast.h
//  TKFtSDK
//
//  Created by 揭康伟 on 2018/10/25.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//
/**
 _toast = [[TKFtToast alloc]initContentView:self.view type:TKFtToastPositionBottom];
 _toast.layerViewWidth = 140;
 [_toast showContent:@"测试，仅供测试"];
 **/
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger,TKFtToastPosition){
    TKFtToastPositionTop,
    TKFtToastPositionCenter,
    TKFtToastPositionBottom
};

@interface TKFtToast : NSObject
/* 点击屏幕 loading提示框消失，默认点击不消失 */
@property (nonatomic, assign) BOOL isClickDisappear;
/* 提示框停留时间，默认为2s*/
@property (nonatomic, assign) NSInteger timeInterval;
/* 提示框宽度，可以不设置，默认180*/
@property (nonatomic, assign) CGFloat layerViewWidth;
/* 提示框背景颜色，可以不设置，默认灰色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/* 提示框字体颜色，可以不设置，默认白色 */
@property (nonatomic, strong) UIColor *contentTextColor;
/** 提示框字体大小，可以不设置，默认14 */
@property (nonatomic,assign) NSInteger contentTextFontSize;
/** 提示框底部间距 ，可以不设置，默认20*/
@property (nonatomic,assign) CGFloat contentLabelBottom;
/** 提示框左右间距，只对showContent有效，可以不设置，默认20 */
@property (nonatomic,assign) CGFloat contentLabelLeft;
/** 提示框自定义位置y坐标，只对showContent有效，可以不设置 */
@property (nonatomic,assign) CGFloat containViewCustomY;
/** 提示框居中显示，自适应宽度，显示一行，默认NO */
@property (nonatomic, assign) BOOL isAdaptiveWidth;

- (instancetype)initContentView:(UIView *)view;
- (instancetype)initContentView:(UIView *)view position:(TKFtToastPosition)position;

- (void)showLoading:(NSString *)text;

- (void)showContent:(NSString *)content;

- (void)showContent:(NSString *)content position:(TKFtToastPosition)position;

- (void)hide;

@end

