//
//  TKFtStoplossSheetView.h
//  TKApp_HL
//
//  Created by thinkive on 2017/6/1.
//  Copyright © 2017年 liubao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKFtSheetView;
@protocol TKFtSheetViewDelegate<NSObject>

@optional
-(void)sheetViewClickWithActionSheet:(TKFtSheetView *)actionSheet selectedTitle:(NSString *)selectedTitle;
-(void)sheetViewClickCancellWithActionSheet:(TKFtSheetView *)actionSheet;

@end
@interface TKFtSheetView : UIView
@property(nonatomic,weak) id <TKFtSheetViewDelegate> delegate;
//默认取消按钮颜色
@property(nonatomic,strong) UIColor *cancelDefaultColor;
//默认选项按钮颜色
@property(nonatomic,strong) UIColor *optionDefaultColor;
//现在的标题
@property(nonatomic,strong) NSString *selectedTitle;



//创建标题形式ActionSheet
+(instancetype)ActionSheetWithTitleArray:(NSArray *)titleArray  andTitleColorArray:(NSArray *)colors delegate:(id<TKFtSheetViewDelegate>)delegate;

//创建图片形式ActionSheet
+(instancetype)ActionSheetWithImageArray:(NSArray *)imgArray delegate:(id<TKFtSheetViewDelegate>)delegate;

//显示sheetView
-(void)showSheetView;
//隐藏sheetView
-(void)hide;

@end

