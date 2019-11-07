//
//  TKFuturesTradeBarKeyBoard.h
//  testKeyBoard
//
//  Created by thinkive on 2017/2/26.
//  Copyright © 2017年 com.thinkive.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKFtKeyBoardDelegate.h"

@interface TKFtPriceKeyBoard : UIView
@property (nonatomic, weak) UITextField *intPutLabel;

@property (nonatomic, weak) id <TKFtKeyBoardDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame Type:(TKFtKeyBoardType)type;

- (void)hidden;

@end
