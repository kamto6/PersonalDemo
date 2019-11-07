//
//  RDBaseViewController.m
//  Reindeer
//
//  Created by Sword. on 1/29/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import "RDBaseViewController.h"

#import "RDLoadingActivityView.h"
#import "RDCustonLoadingView.h"
#import "RDHintView.h"
//#import "MWPhotoBrowser.h"  pod 'MWPhotoBrowser' 去掉该第三方库
#import "RDImageModel.h"
#import "RDSceneryModel.h"
#import "RDUserModel.h"

#import "RDAlertView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#import "RDSceneryModel.h"
#import "RDPOIDataModel.h"
#import "RDPOIDetailViewController.h"
#import "PhotoPickerBrowserViewController.h"
#import "RDNoNetworkBgView.h"
#import "URLConnectionTool.h"
#import "UIBarButtonItem+addition.h"

static NSInteger indicatorCounter = 0;
static RDCustonLoadingView *_loadingView = nil;
static RDNoNetworkBgView   *_noNetworkBgView = nil;

@interface RDBaseViewController ()
{
    RDSceneryModel          *_didBrowseingImageScenery;
    NSMutableArray          *_photos;
   
}
@end

@implementation RDBaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoading) name:RKObjectRequestOperationDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoading) name:RKObjectRequestOperationDidFinishNotification object:nil];
    
    DATA_ENV.isHideHUD = FALSE;
    indicatorCounter = 0;
    
    //屏幕右滑返回手势响应区离屏幕左间距
    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 100;

    if (URL_NET_TOOL.noNetworkFailureBlock) {
        URL_NET_TOOL.noNetworkFailureBlock = nil;
    }

    _viewIsFirstWiilAppear = TRUE;
    [self setupNavigationItems];
   
    if(USE_DUMMPY_DATA) {
        [self loadDummpyData];
    }
    else {
        [self loadData];
    }
    [self setUIElementsFontWhenAwakeFromNIb];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    if (![self.navigationController.viewControllers.firstObject isKindOfClass:[self class]]) {
        if (_loadingView.superview) {
            [_loadingView hide];
            indicatorCounter = 0;
        }
    }
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    [[SDImageCache sharedImageCache] clearMemory];
    
}

#pragma mark - Public Methods
- (void)goBackToLastVC {
    
    
    if([self respondsToSelector:@selector(presentingViewController)]) {
        if (self.presentingViewController) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        if (self.parentViewController.presentedViewController) {
            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back
{
    
    [_loadingView hide];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (DATA_ENV.isPushAtlasVc) {
         [self.navigationController popViewControllerAnimated:TRUE];
        return;
    }
    if(self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
    }
    else if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:TRUE];
    }    
}

- (void)loadDummpyData
{
    SHOULDOVERRIDE_M(@"WKSBaseViewController", NSStringFromClass([self class]), @"子类必须重写loadDummpyData方法来生成假数据，保持数据加载流程一致");
}

- (void)registerCells
{
}

- (void)setUIElementsFontWhenAwakeFromNIb
{
    SHOULDOVERRIDE_M(@"WKSBaseViewController", NSStringFromClass([self class]), @"子类必须重写loadData方法来加载需要的数据，保持数据加载流程一致");
}

- (void)loadData
{
    SHOULDOVERRIDE_M(@"WKSBaseViewController", NSStringFromClass([self class]), @"子类必须重写loadData方法来加载需要的数据，保持数据加载流程一致");
}

- (void)setupNavigationItems
{
    if (IOS7_OR_LATER) {
//        UIImage *navBg = [UIImage imageNamed:@"navbar_bg"];
//        [self.navigationController.navigationBar setBackgroundImage:navBg forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
        self.extendedLayoutIncludesOpaqueBars = FALSE;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    else {
        //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.navigationController.viewControllers.count > 1) {
//        if (@available(iOS 11.0, *)) {
//            
//            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"btn_back" highIcon:@"btn_back" target:self action:@selector(back)];
//        }else{
//            
//            [self leftItemImage:@"btn_back" target:self action:@selector(back)];
//        }
        [self leftItemImage:@"btn_back" target:self action:@selector(back)];
    }
    //去掉底部黑线
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        
        NSArray *list=self.navigationController.navigationBar.subviews;
        
        for (id obj in list) {
            
            if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
                //10.0系统字段改变了
                UIView *view = (UIView *)obj;
                for (id obj2 in view.subviews) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *image = (UIImageView *)obj2;
                        image.hidden = TRUE;
                    }
                }
            }
            else{
               
                if ([obj isKindOfClass:[UIImageView class]]) {
                    
                    UIImageView *imageView=(UIImageView *)obj;
                    
                    NSArray *list2=imageView.subviews;
                    
                    for (id obj2 in list2) {
                        
                        if ([obj2 isKindOfClass:[UIImageView class]]) {
                            
                            UIImageView *imageView2=(UIImageView *)obj2;
                            
                            imageView2.hidden=YES;
                            
                        }
                        
                    }
                    
                }
             }
        
        }
        
    }

}

- (AppDelegate*)appDelegate
{
    return [AppDelegate getAppDelegate];
}

- (void)showLoading
{

     if (DATA_ENV.isHideHUD){
        
    }
    else{
        
        
    if (indicatorCounter <= 0) {
         indicatorCounter++;
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (!_loadingView) {
                _loadingView = [RDCustonLoadingView loadFromXib];
                
            }
            [_loadingView showInView:[UIApplication sharedApplication].keyWindow withHintMessage:nil];
        });
    }
    else {
         indicatorCounter++;
    }
  }
}

- (void)showErrorInfo:(NSError*)error
{
    [RDHintView hintWithMessage:[error localizedDescription] inView:self.navigationController.view disappearDelay:0.5];
}

- (void)hideLoading
{
    
    if (DATA_ENV.isHideHUD){
        
    }
    else{

    indicatorCounter--;
    if (indicatorCounter <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingView hide];
        });
    }
    }
}
- (void)hideLoadingView{

    if (_loadingView.superview) {
        [_loadingView removeFromSuperview];
    }
    [[UIApplication sharedApplication].keyWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[RDCustonLoadingView class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    [[_loadingView viewForView:[UIApplication sharedApplication].keyWindow].subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[RDCustonLoadingView class]]) {
            [obj removeFromSuperview];
        }
    }];
}
- (void)sceneryImageBrowser:(RDSceneryModel*)scenery index:(NSInteger)index
{
    
    //由于部分页面如酒店详情图片相对于window的frame有异差，这里先获得，未发现原因
    NSMutableArray * rectArray = [@[] mutableCopy];
    for (RDImageModel *imageModel in scenery.images) {
        CGRect rectInWindow = [imageModel.toView.superview convertRect:imageModel.toView.frame toView:[UIApplication sharedApplication].keyWindow];
        [rectArray addObject:[NSValue valueWithCGRect:rectInWindow]];
    }
    
    _photos = [NSMutableArray arrayWithArray:scenery.images];
    PhotoPickerBrowserViewController * pickerBrower = [[PhotoPickerBrowserViewController alloc]init];
    pickerBrower.photos = _photos;
    pickerBrower.rectArray = rectArray;
    pickerBrower.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self presentViewController:pickerBrower animated:FALSE completion:nil];
    
    
    /*
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    if (_didBrowseingImageScenery != scenery || ![_didBrowseingImageScenery.sceneryId isEqualToString:scenery.sceneryId]) {
        [_photos removeAllObjects];
        for(RDImageModel *imageInfo in scenery.images) {
            NSString * originalImageUrl = [imageInfo.originalImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:originalImageUrl]];
            [_photos addObject:photo];
        }
    }
    
    // Create browser
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.title = scenery.name?:@"";
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:index];
    
    RDBaseNavigationController *nc = [[RDBaseNavigationController alloc] initWithRootViewController:browser];
    [self presentViewController:nc animated:YES completion:nil];
     
     */
}

- (void)SeeOrigialImageBrowser:(RDSceneryModel*)scenery index:(NSInteger)index scrollToIndex:(void(^)(NSInteger page))block{
    
    PhotoPickerBrowserViewController * pickerBrower = [[PhotoPickerBrowserViewController alloc]init];
    pickerBrower.photos = scenery.images;
    pickerBrower.type = UIViewShowTypeBrower;
    pickerBrower.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    pickerBrower.didScrollPageBlock = block;
    //pickerBrower.modalTransitionStyle
   // [self presentViewController:pickerBrower animated:TRUE completion:nil];
    [self.navigationController pushViewController:pickerBrower animated:TRUE];
}


- (void)sceneryImageBrowser:(RDSceneryModel*)scenery index:(NSInteger)index naviHeight:(CGFloat)naviHeight scrollToIndex:(void(^)(NSInteger page))block{
    
    //由于部分页面如酒店详情图片相对于window的frame有异差，这里先获得，未发现原因
    NSMutableArray * rectArray = [@[] mutableCopy];
    for (RDImageModel *imageModel in scenery.images) {
        CGRect rectInWindow = [imageModel.toView.superview convertRect:imageModel.toView.frame toView:[UIApplication sharedApplication].keyWindow];
        
        [rectArray addObject:[NSValue valueWithCGRect:rectInWindow]];
    }
    _photos = [@[] mutableCopy];
    for (RDImageModel *image in scenery.images) {
        [_photos addObject:[image copy]];
    }
   //_photos = [scenery.images copy];
//    NSValue * firstValue = [rectArray firstObject];
//    NSLog(@"firstFrame：%@",NSStringFromCGRect(firstValue.CGRectValue));
    
    PhotoPickerBrowserViewController * pickerBrower = [[PhotoPickerBrowserViewController alloc]init];
    pickerBrower.photos = _photos;
    pickerBrower.rectArray = rectArray;
    pickerBrower.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    pickerBrower.didScrollPageBlock = block;
    pickerBrower.naviHeight = naviHeight;
    [self presentViewController:pickerBrower animated:FALSE completion:nil];
    
}


//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
//{
//    return [_photos count];
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
//{
//    return _photos[index];
//}



- (void)gotoPOIDetail:(id)poiData dateStr:(NSString *)fromDateStr index:(NSIndexPath *)index fromType:(RDViewFromType)fromType{
    NSString *sourceId;
    if ([poiData isKindOfClass:[RDSceneryModel class]]) {
        RDSceneryModel *scenery = poiData;
        sourceId = scenery.sceneryId;
    }else if ([poiData isKindOfClass:[RDPOIDataModel class]]){
        RDPOIDataModel *model = poiData;
        sourceId = model.poiId;
    }
    if (sourceId) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RDNewHome" bundle:nil];
        RDPOIDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([RDPOIDetailViewController class])];
        detailVc.indexPath = index;
        detailVc.poiData = poiData;
        detailVc.sourceId = sourceId;
        detailVc.detailPlanFromDateStr = fromDateStr;
        detailVc.fromType = fromType;
        detailVc.hidesBottomBarWhenPushed = TRUE;
        [self.navigationController pushViewController:detailVc animated:TRUE];
    }
}
- (void)gotoPOIDetail:(id)poiData dateStr:(NSString *)fromDateStr index:(NSIndexPath *)index fromType:(RDViewFromType)fromType Block:(void(^)(id data))block{
    
    NSString *sourceId;
    if ([poiData isKindOfClass:[RDSceneryModel class]]) {
        RDSceneryModel *scenery = poiData;
        sourceId = scenery.sceneryId;
    }else if ([poiData isKindOfClass:[RDPOIDataModel class]]){
        RDPOIDataModel *model = poiData;
        sourceId = model.poiId;
    }
    if (sourceId) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RDNewHome" bundle:nil];
        RDPOIDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([RDPOIDetailViewController class])];
        detailVc.indexPath = index;
        detailVc.poiData = poiData;
        detailVc.sourceId = sourceId;
        detailVc.detailPlanFromDateStr = fromDateStr;
        detailVc.fromType = fromType;
        detailVc.hidesBottomBarWhenPushed = TRUE;
        detailVc.finishPublishPictureBlock = block;
        [self.navigationController pushViewController:detailVc animated:TRUE];
    }

}
- (void)setUserInteractionEnabled:(BOOL)UserInteractionEnabled{
    self.view.userInteractionEnabled = UserInteractionEnabled;
}
- (void)showAlertView:(NSString *)message {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSInteger alertTag = 1120;
    RDAlertView *alertView = (RDAlertView *)[keyWindow viewWithTag:alertTag];
    if (!alertView) {
        alertView = [RDAlertView loadFromXib];
        alertView.messageLabel.text = message;
        alertView.tag = alertTag;
        [alertView showInView:keyWindow disappearDelay:2.0 hiddenCancelButton:TRUE];
        
    }
}
- (void)showMakePlanError{
    [self showMakePlanError:nil];
}
- (void)showMakePlanError:(NSString *)message
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSInteger alertTag = 1150;
    RDAlertView *alertView = (RDAlertView *)[keyWindow viewWithTag:alertTag];
    if (!alertView) {
        alertView = [RDAlertView loadFromXib];
        if (message) {
            alertView.messageLabel.text = message;
        }else{
           alertView.messageLabel.text = [RDUtils localizableString:@"rd_server_error_message"];
        }
    
        alertView.tag = alertTag;
        [alertView showInView:keyWindow];
        
    }

}
- (void)showMakePlanMessage:(NSAttributedString *)message{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSInteger alertTag = 1180;
    RDAlertView *alertView = (RDAlertView *)[keyWindow viewWithTag:alertTag];
    if (!alertView) {
        alertView = [RDAlertView loadFromXib];
        alertView.messageLabel.attributedText = message;
        alertView.tag = alertTag;
        [alertView showInView:keyWindow];
        
    }
}

- (void)alertShowWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    
    [alertView show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertView dismissWithClickedButtonIndex:0 animated:TRUE];
        
    });
    
}

- (void)showNoNetworkView:(UIViewController *)viewController tableView:(UIView *)tableView off:(CGFloat)off{
    
    [self hideLoadingView];
    if ([tableView isKindOfClass:[PullTableView class]]) {
        PullTableView * pullTableView = (PullTableView *)tableView;
        [pullTableView setRefreshViewHidden:TRUE];
        [pullTableView setLoadMoreViewHidden:TRUE];
    }
    if (!_noNetworkBgView) {
        _noNetworkBgView = [RDNoNetworkBgView loadFromXib];
    }
    if (_noNetworkBgView.baseVc) {
        [self removeNoNetworkView];
    }
    if (!_noNetworkBgView.superview) {
        [_noNetworkBgView showInView:viewController tableView:tableView off:off];
         
    }
    
    
}
- (void)removeNoNetworkView{
    if (_noNetworkBgView) {
        [_noNetworkBgView remove];
    }
    
}
@end
