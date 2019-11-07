//
//  YYView.h
//  testKeyBoard
//
//  Created by thinkive on 2017/2/26.
//  Copyright © 2017年 com.thinkive.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKFtToolBar;
@protocol TKFtToolBarDelegate <NSObject>
@optional
-(void)toolBarHide:(TKFtToolBar *)toolBar;
@end

@interface TKFtToolBar : UIView

@property (nonatomic,copy) NSString * contentString;
@property (nonatomic,weak) id<TKFtToolBarDelegate> delegate;

@end
