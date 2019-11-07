//
//  NSString+TKFtCommon.h
//  TKFtSDK
//
//  Created by 揭康伟 on 2018/11/5.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TKFtCommon)

#pragma mark -
/** 获取字符串高度 */
- (CGFloat)heightWithFont:(UIFont*)font lineWidth:(NSInteger)lineWidth;
/** 获取字符串宽度 */
- (CGFloat)widthWithFont:(UIFont*)font lineHeight:(NSInteger)lineHeight;


@end
