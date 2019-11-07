//
//  TKFtNSuperPriceKeyBoard.h
//  TKApp
//
//  Created by thinkive on 2018/2/3.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKFtKeyBoardDelegate.h"

@interface TKFtNSuperPriceKeyBoard : UIView

@property (nonatomic, weak) UITextField *intPutLabel;

@property (nonatomic, weak) id <TKFtKeyBoardDelegate> delegate;

- (void)hidden;

@end
