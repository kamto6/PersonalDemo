//
//  TKFtNavigationItem.h
//  TKApp_HL
//
//  Created by thinkive on 2017/5/25.
//  Copyright © 2017年 liubao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKFtNavigationItem : NSObject


/**
 *  @author yyf, 17-04
 *
 *  @brief  自定返回一张图片的范湖按钮
 *
 *  触发事件
 *  触发对象
 *  返回的方法名
 */
+ (NSArray *)doBarButtonItemIcon:(NSString *)imageName
                       addTarget:(id)target
                          action:(SEL)action;


/**
 *  @author yyf, 17-04
 *
 *  @brief  创建导航栏TitleView
 *
 *  导航栏标题
 */
+(UILabel *)doNavTitleViewWithTitleStr:(NSString *)titleStr;


/**
 *  @author yyf, 17-04
 *
 *  @brief  创建分割按钮
 *
 *  尺寸
 */
+ (UIBarButtonItem *)spaceButtonItemWithWidth:(CGFloat)width;

/**
 *  @author yyf, 17-04
 *
 *  @brief  导航栏右侧按钮
 *
 *  触发事件
 *  触发对象
 *  返回的方法名
 */
+ (NSArray *)doRightBarButtonItemIcon:(NSString *)imageName
                            addTarget:(id)target
                               action:(SEL)action;

@end
