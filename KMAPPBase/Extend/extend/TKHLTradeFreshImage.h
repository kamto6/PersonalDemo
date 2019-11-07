//
//  TKFutureTradeFreshImage.h
//  TKApp
//
//  Created by thinkive on 16/8/20.
//  Copyright © 2016年 姚元丰. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TKHLTradeFreshImagedelegate <NSObject>
@optional
/**
 *  @author yyf, 16-09-29 17:09:39
 *
 *  @brief  刷新当前页回调
 */
-(void)doFreshData;
@end
@interface TKHLTradeFreshImage : UIView

@property (nonatomic,weak) id <TKHLTradeFreshImagedelegate> delegate;

+(TKHLTradeFreshImage *)shareInstance;
/**
 *  @author yaoyf, 16-08-20 16:08:09
 *
 *  @brief  停止动画
 */
-(void)stopAnimate;

/**
 *  @author yaoyf, 16-08-20 16:08:09
 *
 *  @brief  开始动画
 */
-(void)startAnimate;
@end
