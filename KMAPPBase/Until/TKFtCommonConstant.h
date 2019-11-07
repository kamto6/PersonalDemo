//
//  TKFtCommonConstant.h
//  TKFtSDK
//
//  Created by 揭康伟 on 2018/10/19.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 枚举

typedef NS_ENUM(NSInteger, TKFtProductClassType)
{
    TKFtProductClassTypeQH = 1,//期货
    TKFtProductClassTypeQQ = 2 //期权
};



#pragma mark - Other

extern NSString *const BundleName;


#pragma mark - Notication Definition



#pragma mark - 消息号及功能号


#pragma mark - 屏蔽服务器错误提示


#pragma mark - 宏

#define TKFT_INDEXPATH_EQUAL(a,b) ([a compare:b] == NSOrderedSame) ? YES : NO


/** 弱引用 */
#define TKFtWeakSelf(weakSelf) __weak __typeof(self) weakSelf = self
#define TKFtWeakClass(weakClass, class) __weak __typeof(class) weakClass = class
#define TKFtWeakObj(var) __weak __typeof(var) weak##var = var
//#define TKFtWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
/** 强引用 */
#define TKFtStrongSelf(strongSelf) __strong __typeof(self) strongSelf = weakSelf

#define KSystemVersion [[UIDevice currentDevice] systemVersion].floatValue

//#ifndef dispatch_main_async_safe
//#define dispatch_main_async_safe(block)\
//if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
//block();\
//} else {\
//dispatch_async(dispatch_get_main_queue(), block);\
//}
//#endif
// 日志输出
//#ifdef DEBUG
//#define TKFTLog(...) NSLog(__VA_ARGS__)
//#else
//#define TKFTLog(...)
//#endif

@interface TKFtCommonConstant : NSObject

@end

