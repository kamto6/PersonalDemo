//
//  TKFutureTradeStatusBar.m
//  TKApp
//
//  Created by thinkive on 16/8/5.
//  Copyright © 2016年 姚元丰. All rights reserved.
//

#import "TKFtStatusBar.h"
#import "NSString+TKFtCommon.h"

//定时器间隔时间
static CGFloat const MessageDuration = 1;
////动画时间
//static CGFloat const AnimationDuration = 0.5;
////动画消失时间
//static CGFloat const DismissDuration = 0.1;

//全局的窗口
static UIWindow *_window;
//定时器
static NSTimer *_timer;

static NSInteger  _time;

static UILabel *_stateLable,*_contentLable;

static UISwipeGestureRecognizer *_swipe;

static UITapGestureRecognizer *_tap;

@implementation TKFtStatusBar


/**
 显示窗口创建
 */
+ (void)showWindow
{
    if (!_window) {
        _window = [[UIWindow alloc] init];
        [_window addCssClass:@".ftSelectBgColor"];
        _window.windowLevel = UIWindowLevelAlert;
        
        _stateLable = [[UILabel alloc]init];
//        _stateLable.adjustsFontSizeToFitWidth = YES;
        _stateLable.textAlignment = NSTextAlignmentLeft;
        [_stateLable addCssClass:@".ftMainTextColor"];
        _stateLable.font = [UIFont ftk750AdaptationFont:10];
        [_window addSubview:_stateLable];
        
        _contentLable = [[UILabel alloc]init];
        _contentLable.adjustsFontSizeToFitWidth = YES;
        _contentLable.textAlignment = NSTextAlignmentLeft;
        [_contentLable addCssClass:@".ftMainTextColor"];
        _contentLable.font = [UIFont ftk750AdaptationFont:16];
        [_window addSubview:_contentLable];
    }
    
    CGFloat windowH = 0;
    CGRect frame;
    
    BOOL isTKQhHqLandscapeChartCtl = [self isTKQhHqLandscapeChartCtl];
    if (isTKQhHqLandscapeChartCtl)
    {
        windowH = 64;
        _window.transform = CGAffineTransformMakeRotation(M_PI_2);
        frame = CGRectMake(TKFT_SCREEN_WIDTH - windowH, 0, windowH, TKFT_SCREEN_HEIGHT);
    }else{
        windowH = ISIPHONEX ? 88 : 64;
        frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, windowH);
        _window.transform = CGAffineTransformIdentity;
    }
    
    [_window refreshCssAndSubViewsCss];
    
   
    //添加轻扫、点按手势
    if (!_swipe) {
        _swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDuration)];
        _swipe.direction = UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionRight;
    }
    if (![_window.gestureRecognizers containsObject:_swipe]) {
        [_window addGestureRecognizer:_swipe];
    }
    
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDuration)];
    }
    if (![_window.gestureRecognizers containsObject:_tap]) {
        [_window addGestureRecognizer:_tap];
    }
    
    
    // 动画
    if (_window.hidden == YES || isTKQhHqLandscapeChartCtl) {
        _window.frame = frame;
        _window.hidden = NO;
        _window.alpha = 1;
    }
}

/**
 显示下单下拉框
 
 @param msgDic 需要显示的信息
 */
+ (void)showMessage:(NSDictionary *)msgDic
{
    _time = 3;
    // 显示窗口
    [self showWindow];
    
    NSString *contentStr = [msgDic getStringWithKey:@"content"];
    NSString *stateStr = [msgDic getStringWithKey:@"state"];
    
    
    if ([TKStringHelper isEmpty:contentStr] && [TKStringHelper isNotEmpty:stateStr])
    {
        CGFloat y = ISIPHONEX ? 15 : 0;
        if ([self isTKQhHqLandscapeChartCtl])
        {
            y = 0;
        }
        
        _stateLable.hidden = YES;
        //        CGRect rect = _window.frame;
        //        rect.origin.x = 15;
        //        rect.origin.y = y;
        _contentLable.frame = CGRectMake(15, y, TKFT_SCREEN_WIDTH - 15, 64);
        _contentLable.text = stateStr;
    }else if([TKStringHelper isNotEmpty:contentStr] && [TKStringHelper isEmpty:stateStr])
    {
        CGFloat y = ISIPHONEX ? 15 : 0;
        if ([self isTKQhHqLandscapeChartCtl])
        {
            y = 0;
        }
        _stateLable.hidden = YES;
        //        CGRect rect = _window.frame;
        //        rect.origin.x = 15;
        //        rect.origin.y = y;
        _contentLable.frame = CGRectMake(15, y, TKFT_SCREEN_WIDTH - 15, 64);
        _contentLable.text = contentStr;
        
    }else
    {
        CGFloat y = 16;
        CGFloat contentLablex = 15;
        y = ISIPHONEX ? 40 : 16;
        
        if ([self isTKQhHqLandscapeChartCtl])
        {
            y = 16;
        }
        NSString *string = @"委托失败";
        UIFont *font = [UIFont ftk750AdaptationFont:16.f];
        NSDictionary *attributDic = @{NSFontAttributeName:font};
        CGFloat height = [string sizeWithAttributes:attributDic].height;
        
        _contentLable.frame = CGRectMake(contentLablex , y, TKFT_SCREEN_WIDTH - contentLablex, height);
        CGFloat stateLabley = CGRectGetMaxY(_contentLable.frame) + 8;
        _stateLable.frame = CGRectMake(contentLablex, stateLabley, TKFT_SCREEN_WIDTH - contentLablex, 15);
        
        _stateLable.hidden = NO;
        _stateLable.text = stateStr;
        _contentLable.text = contentStr;
        
    }
    
    if (!_timer) {
        //定时器
        _timer = [NSTimer timerWithTimeInterval:MessageDuration target:self selector:@selector(judgeMessageWidowHide) userInfo:nil repeats:YES];
        
        NSRunLoop *runLoop = [NSRunLoop mainRunLoop];
        [runLoop addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}


/**
 定时器时间判断
 */
+ (void)judgeMessageWidowHide
{
    _time --;
    if (_time <= 0)
    {
        [_timer invalidate];
        _timer = nil;
        [self hide];
    }
}


/**
 隐藏
 */
+ (void)hide
{
    _window.hidden = YES;
    //    [UIView animateWithDuration:DismissDuration animations:^{
    //        _window.alpha = 0;
    //    } completion:^(BOOL finished) {
    //        if (_time <= 0 && _window.alpha == 0) {
    //            _window.hidden = YES;
    //        }
    //    }];
}


/**
 上滑隐藏
 */
+ (void)swipeDuration
{
    [_timer invalidate];
    _timer = nil;
    
    CGRect frame = _window.frame;
    frame.origin.y =  - frame.size.height;
    _window.frame = frame;
    _window.alpha = 0;
    _window.hidden = YES;
}

/**
 是否是行情横屏控制器
 
 @return 是否
 */
+(BOOL)isTKQhHqLandscapeChartCtl
{
    UIViewController *vc1 = [[TKAppEngine shareInstance].rootViewCtr getViewCtrlByName:@"TKQhHqDetailsLandscapeRootCtl_Name"];
    UIViewController *currentVC = [TKAppEngine shareInstance].rootViewCtr.currentViewCtrl;
    BOOL isTKQhHqLandscapeChartCtl = [NSStringFromClass([currentVC class]) isEqualToString:@"TKQhHqLandscapeChartCtl"]|[NSStringFromClass([vc1 class]) isEqualToString:@"TKQhHqLandscapeChartCtl"];
    return isTKQhHqLandscapeChartCtl;
}

/**
 * 适应报单副标题文字
 */
+(void)adapteStateLabel:(NSString *)stateStr
{
    CGFloat stateLabelWidth = CGRectGetWidth(_stateLable.frame);
    NSInteger font = 10;
    for (; font >=8; font -- ) {
        CGFloat textWidth  = [stateStr widthWithFont:[UIFont ftk750AdaptationFont:font] lineHeight:15];
        if (textWidth<stateLabelWidth) {
            break;
        }
    }
    _stateLable.font = [UIFont ftk750AdaptationFont:10];
}
@end

