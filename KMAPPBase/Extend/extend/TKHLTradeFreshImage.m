//
//  TKFutureTradeFreshImage.m
//  TKApp
//
//  Created by thinkive on 16/8/20.
//  Copyright © 2016年 姚元丰. All rights reserved.
//

#import "TKHLTradeFreshImage.h"

@interface TKHLTradeFreshImage ()
@property(nonatomic,strong)UIImageView * imgview;//图片
@end

@implementation TKHLTradeFreshImage

+(TKHLTradeFreshImage *)shareInstance
{
    static TKHLTradeFreshImage *chooseCahc =nil;
    @synchronized(self) {
        if (!chooseCahc) {
            chooseCahc = [[TKHLTradeFreshImage alloc]init];
        }
    }
    return chooseCahc;
}

-(void)layoutSubviews
{
    _imgview = [[UIImageView alloc] init];
    _imgview.frame = self.bounds;
    if ([TKFtEnvHelp shareInstance].ftPlatform == FT_CURRRNT_APP_PLAT_HTFC&&![TKFtConfig instance].isFutureTradeCloudApp) {
        [_imgview addCssClass:@".ftTardeFressh"];
    }else{
        [_imgview addCssClass:@".ftRefreshSelected"];
    }
    [self addSubview:_imgview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(transfomeData)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
    monkeyAnimation.duration = 0.3f;
    monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    monkeyAnimation.cumulative = NO;
    monkeyAnimation.removedOnCompletion = NO; //No Remove
    monkeyAnimation.repeatCount = FLT_MAX;
    [_imgview.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
    [_imgview stopAnimating];
    // 加载动画 但不播放动画
    _imgview.layer.speed = 0.0;
    [super layoutSubviews];
}

/**
 *  @author yaoyf, 16-08-20 16:08:09
 *
 *  @brief  开始动画
 */
-(void)startAnimate
{
    _imgview.layer.speed = 1.0;
    _imgview.layer.beginTime = 0.0;
    CFTimeInterval pausedTime = [_imgview.layer timeOffset];
    CFTimeInterval timeSincePause = [_imgview.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    _imgview.layer.beginTime = timeSincePause;
}

/**
 *  @author yaoyf, 16-08-20 16:08:09
 *
 *  @brief  停止动画
 */
-(void)stopAnimate
{
    CFTimeInterval pausedTime = [_imgview.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    _imgview.layer.speed = 0.0;
    _imgview.layer.timeOffset = pausedTime;
}

/**
 *  @author yaoyf, 16-08-22 11:08:31
 *
 *  @brief 点击图片刷新数据
 */
-(void)transfomeData
{
    if ([self.delegate respondsToSelector:@selector(doFreshData)]) {
        [self.delegate doFreshData];
    }
}
@end
