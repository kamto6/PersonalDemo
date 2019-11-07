//
//  TKFtSegmentedControl.m
//  TKFtSDK
//
//  Created by 揭康伟 on 2019/10/18.
//  Copyright © 2019 com.thinkive.www. All rights reserved.
//

#import "TKFtSegmentedControl.h"

@implementation TKFtSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        //基础框架已适配
////#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0  //编译时会编译到，在Xcode10还是.selectedSegmentTintColor报错
//#ifdef __IPHONE_13_0   //没有定义就不会被编译到，但在xcode10编译的包在iPhone11不会生效这个更改
//
//        /*
//         升级Xcode11之后，用Xcode11编译出的库在Xcode10出现了"___isPlatformVersionAtLeast", referenced from:的编译错误。解决办法：
//
//         在报错方法中去掉使用的@available()
//
//         如果你的 SDK 需要适配旧版本的 Xcode，那么需要避开此方法
//         */
//        if (KSystemVersion >= 13.0) {
//            BOOL isHTFCStyle = [TKFtEnvHelp shareInstance].ftPlatform == FT_CURRRNT_APP_PLAT_HTFC &&![TKFtConfig instance].isFutureTradeCloudApp;
//            BOOL isTheme1 = [[TKThemeManager shareInstance].theme isEqualToString:@"theme1"];
//            UIColor *selectColor;
//            if (isHTFCStyle) {
//                selectColor = isTheme1?TKFT_HEXCOLOR(0XF82C3C):TKFT_HEXCOLOR(0XDA2222);
//            }else{
//                selectColor = isTheme1?TKFT_HEXCOLOR(0XFF5656):TKFT_HEXCOLOR(0XDA2222);
//            }
////警告的地方，右键，reveal in log，可以找到警告对应的标示符
//            #pragma clang diagnostic push
//            #pragma clang diagnostic ignored"-Wunguarded-availability-new"
//
//            self.selectedSegmentTintColor = selectColor;
//
//            #pragma clang diagnostic pop
//
////            [self performSelector:@selector(setSelectedSegmentTintColor:) withObject:selectColor];
//
////            if (@available(iOS 13.0, *)) {
//            //去掉这个判断，会有setSelectedSegmentTintColor:' is only available on iOS 13.0 or newer警告，如果修改target版本支持13，也会取消此警告
////            }
//        }
//#else
//#endif
        
    }
    return self;
}

@end
