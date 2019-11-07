//
//  TKFtHUD.h
//  TKFtSDK
//
//  Created by 揭康伟 on 2018/10/24.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKFtHUD: UIView
/* 提示框宽度 */
@property (nonatomic, assign) CGFloat layerViewWidth;
/** 是否点击背景弹框消失 */
@property (nonatomic, assign) BOOL isClickMaskDisapper;

- (void)showLoading:(NSString *)text;

- (void)hideLoading;

@end
