//
//  RDBaseViewController.h
//  Reindeer
//
//  Created by Sword. on 1/29/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class RDSceneryModel;

typedef enum {
    RDChangeHotelFromNone = -1,
    RDChangeHotelFromEdit,
    RDChangeHotelFromMyPlan
    
}RDChangeHotelFromVC;

@interface RDBaseViewController : UIViewController

@property (nonatomic, assign) RDViewFromType fromType;
@property (nonatomic, assign) BOOL viewIsFirstWiilAppear;//页面第一次出现
//从主页或从个人页面进入该页面
@property (nonatomic, assign) BOOL  isNaviBarHidenFromHome;

@property (nonatomic ,assign) BOOL UserInteractionEnabled;
@property (nonatomic, weak) RDBaseViewController *backToViewController;
@property (nonatomic, assign) BOOL hotelDetailFromEditOrDetail;
@property (nonatomic, assign) RDChangeHotelFromVC changeHotelFromVc;

@property (nonatomic, readonly) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *userinfo;

- (void)gotoPOIDetail:(id)poiData dateStr:(NSString *)fromDateStr index:(NSIndexPath *)index fromType:(RDViewFromType)fromType;
- (void)gotoPOIDetail:(id)poiData dateStr:(NSString *)fromDateStr index:(NSIndexPath *)index fromType:(RDViewFromType)fromType Block:(void(^)(id data))block;
/*!
 * Navigation
 */
- (void)goBackToLastVC;

- (void)registerCells;
/*!
 * 设置顶部导航，子类重写此方法的时候必须调用[super setupNavigationItems]
 */
- (void)setupNavigationItems;
- (void)loadData;
/*!
 * UI开发阶段请重写这个方法生成你的假数据，真实接口的时候重写loadData方法获取数据
 */
- (void)loadDummpyData;
/*!
 * 返回到上个界面，有默认实现，子类根据需要自行确定是否需要重写此方法
 */
- (IBAction)back;

- (void)setUIElementsFontWhenAwakeFromNIb;

- (void)showErrorInfo:(NSError*)error;

- (void)hideLoading;
- (void)hideLoadingView;
- (void)showLoading;


- (void)sceneryImageBrowser:(RDSceneryModel*)scenery index:(NSInteger)index;
- (void)SeeOrigialImageBrowser:(RDSceneryModel*)scenery index:(NSInteger)index scrollToIndex:(void(^)(NSInteger page))block;
- (void)sceneryImageBrowser:(RDSceneryModel*)scenery index:(NSInteger)index naviHeight:(CGFloat)naviHeight scrollToIndex:(void(^)(NSInteger page))block;

- (void)showAlertView:(NSString *)message;

- (void)showMakePlanError;

- (void)showMakePlanError:(NSString *)message;

- (void)showMakePlanMessage:(NSAttributedString *)message;

- (void)alertShowWithTitle:(NSString *)title message:(NSString *)message;


- (void)showNoNetworkView:(UIViewController *)viewController tableView:(UIView *)tableView off:(CGFloat)off;
- (void)removeNoNetworkView;

@end
