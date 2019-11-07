//
//  TKFtNetworkStateTipView.m
//  TKApp
//
//  Created by thinkive on 2018/3/15.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "TKFtNetworkStateTipView.h"

@interface TKFtNetworkStateTipView()

@property(nonatomic,strong)UIImageView *stateImageView;

@end

@implementation TKFtNetworkStateTipView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        self.userInteractionEnabled = NO;
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.frame = frame;
    [super willMoveToSuperview:newSuperview];
    [newSuperview bringSubviewToFront:self];
}

-(void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }
}


-(void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    CGFloat x = self.frame.size.width - 15 - 18;
    CGFloat y = (self.frame.size.height - 18)/2.0;
    _stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, 18, 18)];
    [_stateImageView addCssClass:@".ftAbnormalNetwork"];
    [self addSubview:_stateImageView];
    
}

-(void)hiddenView
{
    [_stateImageView addCssClass:@".ftNormalNetwork"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}


@end
