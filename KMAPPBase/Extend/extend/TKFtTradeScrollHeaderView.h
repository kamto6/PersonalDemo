//
//  TKFtTradeScrollHeaderView.h
//  TKApp_HL
//
//  Created by thinkive on 2017/3/20.
//  Copyright © 2017年 com.thinkive.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKFtTradeScrollHeaderViewDelegate <NSObject>
@optional
//headerView横向滚动事件代理
- (void)doScrollViewDidHeaderScroll:(UIScrollView *)scrollView;

@end

@interface TKFtTradeScrollHeaderView : UIView

@property (nonatomic,strong) NSString *notificationName;//通知名
@property (nonatomic,assign) CGPoint contentOffSet;//获取当前的偏移量
@property (nonatomic, weak ) id<TKFtTradeScrollHeaderViewDelegate>delegate;

//初始化
-(instancetype)initWithTitles:(NSArray *)titles andWidthArray:(NSMutableArray *)widthArray nameLabelWidth:(CGFloat)nameLabelWidth nameLabelFont:(CGFloat)font;
//初始化
-(instancetype)initWithTitles:(NSArray *)titles andWidthArray:(NSMutableArray *)widthArray nameLabelWidth:(CGFloat)nameLabelWidth nameLabelFont:(CGFloat)font menuType:(TKFtTradeOperationMenuType)type;

//设置滚动位移值

-(void)doSetUpHeaderContOffex:(UIScrollView *)scrollView;

- (instancetype)initWithTradeOperationMenuType:(TKFtTradeOperationMenuType)type;

@end
