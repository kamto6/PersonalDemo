//
//  TKFtChooseKeyBoard.h
//  TKFtSDK
//
//  Created by thinkive on 2018/5/31.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKFtKeyBoardDelegate.h"

@interface TKFtChooseKeyBoard : UIView

@property(nonatomic,weak) id<TKFtKeyBoardDelegate>delegate;

/**
 键盘弹起，接到数据刷新界面
 
 @param freshData 自选股数据
 @param instrumentName 合约名称
 */
-(void)freshChooseView:(NSMutableArray *)freshData instrumentName:(NSString *)instrumentName;

@end
