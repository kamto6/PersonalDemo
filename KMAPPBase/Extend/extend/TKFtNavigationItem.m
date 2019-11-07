//
//  TKFtNavigationItem.m
//  TKApp_HL
//
//  Created by thinkive on 2017/5/25.
//  Copyright © 2017年 liubao. All rights reserved.
//

#import "TKFtNavigationItem.h"

@implementation TKFtNavigationItem


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
                          action:(SEL)action
{
    
    NSMutableArray *barArray = [NSMutableArray array];
    [barArray addObject:[self spaceButtonItemWithWidth:-16]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    if(IOS11_OR_LATER){
        btn.imageEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
    }
    if ([TKFtEnvHelp shareInstance].ftPlatform == FT_CURRRNT_APP_PLAT_HTFC&&![TKFtConfig instance].isFutureTradeCloudApp) {
        imageName = @".ftTardeBack";
    }else{
        imageName = @".ftNavLeftBacK";
    }
    
    [btn addCssClass:imageName];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [barArray addObject:[[UIBarButtonItem alloc] initWithCustomView:btn]];
    return [barArray mutableCopy];
}

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
                          action:(SEL)action
{
    NSMutableArray *barArray = [NSMutableArray array];
    [barArray addObject:[self spaceButtonItemWithWidth:16]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    if(IOS11_OR_LATER){
        btn.imageEdgeInsets =UIEdgeInsetsMake(0, 20,0, 0);
    }
    [btn addCssClass:imageName];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [barArray addObject:[[UIBarButtonItem alloc] initWithCustomView:btn]];
    return [barArray copy];
}


/**
 *  @author yyf, 17-04
 *
 *  @brief  创建导航栏TitleView
 *
 *  导航栏标题
 */
+(UILabel *)doNavTitleViewWithTitleStr:(NSString *)titleStr
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(0, 0, 100, 40);
    titleLabel.text = titleStr;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if ([TKFtEnvHelp shareInstance].ftPlatform == FT_CURRRNT_APP_PLAT_HTFC&&![TKFtConfig instance].isFutureTradeCloudApp) {
        [titleLabel addCssClass:@".ftNaveTextColor"];
    }else{
        [titleLabel addCssClass:@".ftDefaultTextColor"];
    }
    return titleLabel;
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  创建分割按钮
 *
 *  尺寸
 */
+ (UIBarButtonItem *)spaceButtonItemWithWidth:(CGFloat)width
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = width;
    return negativeSpacer;
}

@end
