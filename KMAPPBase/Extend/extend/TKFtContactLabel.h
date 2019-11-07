//
//  TKFtContactLabel.h
//  TKFtSDK
//
//  Created by 揭康伟 on 2018/11/26.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKFtContactLabel : UIView
@property (nonatomic,strong) NSString *text;
@property (nonatomic) NSTextAlignment textAlignment;

- (instancetype)initWithFontSize:(float)fontSize;
- (instancetype)initWithFontSize:(float)fontSize leadingContraint:(CGFloat)leading trailingContraint:(CGFloat)trailing;

@end
