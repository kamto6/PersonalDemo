//
//  TKFtSettlementDataView.m
//  TKApp_HL
//
//  Created by thinkive on 2017/5/11.
//  Copyright © 2017年 liubao. All rights reserved.
//

#import "TKFtDateTipView.h"
#import "TKFtDateHelp.h"
#import "TKFtDayDatePicker.h"
#import "TKFtMonthDatePicker.h"
#import "TKFtFutureDatePicker.h"


@interface TKFtDateTipView ()<TKFtMonthDatePickerDelegate,TKFtDayDatePickerDelegate,TKFtFutureDatePickerDelegate>
@property (nonatomic,strong) UIWindow *backWindow;
@property (nonatomic,strong) TKFtDayDatePicker  *dayDatePicker;
@property (nonatomic,strong) TKFtMonthDatePicker *monthDatePicker;
@property (nonatomic,strong) TKFtFutureDatePicker *futureDatePicker;
@property (nonatomic,assign) TKFtDateType type;
@property (nonatomic,copy) NSString *showTimeStr;//初始化时间，yyyy/MM/dd或yyyy/MM

@property (nonatomic,copy) NSString *startDate;

@end

@implementation TKFtDateTipView


-(instancetype)initWithFrame:(CGRect)frame andStyle:(TKFtDateType)type
{
    _type = type;
    self = [self init];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andStyle:(TKFtDateType)type andStartDate:(NSString *)date
{
    _type = type;
    _startDate = [date copy];
    self = [self init];
    return self;
}

-(void)initUI
{
    self.frame = CGRectMake(0, 0, TKFT_SCREEN_WIDTH, TKFT_SCREEN_HEIGHT);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    
    if (_type == TKFtDateTypeDay)
    {
        [self addSubview:self.dayDatePicker];
        [_dayDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(ft750AdaptationWidth(240));
        }];
        NSString *tradeDate = [TKFtUserinfo shareInstance].TradingDay;
        _showTimeStr = [TKFtDateHelp doConversionTimeFormatWithString:tradeDate];

    }else if (_type == TKFtDateTypeMonth)
    {
        [self addSubview:self.monthDatePicker];
        [_monthDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(ft750AdaptationWidth(240));
        }];
        NSString *tradeDate = [TKFtUserinfo shareInstance].TradingDay;
        NSString *string = [TKFtDateHelp doConversionTimeFormatWithString:tradeDate];
        _showTimeStr = [TKFtDateHelp doConverMonthDateWithString:string];

    }else if (_type == TKFtDateTypeFuture)
    {
        [self addSubview:self.futureDatePicker];
        [_futureDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(ft750AdaptationWidth(240));
        }];
        NSString *tradeDate = [TKFtUserinfo shareInstance].TradingDay;
        _showTimeStr = [TKFtDateHelp doConversionTimeFormatWithString:tradeDate];
    }
}

#pragma mark - TKFtDateViewdelegate

/**
 *  @author yyf, 17-04
 *
 *  @brief  确认
 *
 *  时间值
 */
-(void)datePickerDoDateConfirmWithDateString:(NSString *)dateString
{
    if ([TKStringHelper isNotEmpty:dateString])
    {
        _showTimeStr = dateString;
        NSString *tempStr = [TKFtDateHelp doConversionZeroWithString:dateString];
        if ([self.delegate respondsToSelector:@selector(doDataClickConfirmWithTimeString:)]) {
            [self.delegate doDataClickConfirmWithTimeString:tempStr];
        }
    }
    
    [self hide];
}

#pragma mark - help method

-(void)layerAnimationMakeWithUp:(BOOL)up{
    [self.layer removeAllAnimations];
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    if (up == YES) {
        colorAnimation.duration = 0.3;
        colorAnimation.fromValue = (__bridge id _Nullable)([TKFT_HEXColor(0x000000, 0) CGColor]);
        colorAnimation.toValue = (__bridge id _Nullable)([TKFT_HEXColor(0x000000, 0.3) CGColor]);
    }else{
        colorAnimation.duration = 0.15;
        colorAnimation.fromValue = (__bridge id _Nullable)([TKFT_HEXColor(0x000000, 0.3) CGColor]);
        colorAnimation.toValue = (__bridge id _Nullable)([TKFT_HEXColor(0x000000, 0) CGColor]);
    }
    
    
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:colorAnimation forKey:@"colorAnimation"];
    
}

#pragma mark - privatd method

-(void)show
{
    _backWindow.hidden = NO;
    [self layerAnimationMakeWithUp:YES];
    [self.backWindow addSubview:self];
    
    if (_type == TKFtDateTypeDay)
    {
        if ([TKStringHelper isNotEmpty:_showTimeStr] && _startDate.length == 0) {
            self.dayDatePicker.showTimeStr = _showTimeStr;
        }
        
        [self.dayDatePicker.superview layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [_dayDatePicker mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom).offset(-ft750AdaptationWidth(220));
            }];
        }];
    }else if(_type == TKFtDateTypeMonth)
    {
        if ([TKStringHelper isNotEmpty:_showTimeStr] && _startDate.length == 0) {
            self.monthDatePicker.showTimeStr = _showTimeStr;
        }

        [self.monthDatePicker.superview layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [_monthDatePicker mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom).offset(-ft750AdaptationWidth(220));
            }];
        }];
    }else if(_type == TKFtDateTypeFuture)
    {
        if ([TKStringHelper isNotEmpty:_showTimeStr] && _startDate.length == 0) {
            self.futureDatePicker.showTimeStr = _showTimeStr;
        }
        [self.futureDatePicker.superview layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [_futureDatePicker mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom).offset(-ft750AdaptationWidth(220));
            }];
        }];
    }
}

- (void)showWithDateString:(NSString *)dateStr
{
    _showTimeStr = dateStr;
    [self show];
}


-(void)hide
{
    [self layerAnimationMakeWithUp:NO];
    
    if (_type == TKFtDateTypeDay)
    {
        [UIView animateWithDuration:0.15 animations:^{
            [_dayDatePicker mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom);
            }];
            [self.dayDatePicker.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [_backWindow resignKeyWindow];
            _backWindow.hidden = YES;
        }];
    }else if(_type == TKFtDateTypeMonth)
    {
        [UIView animateWithDuration:0.15 animations:^{
            [_monthDatePicker mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom);
            }];
            [self.monthDatePicker.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [_backWindow resignKeyWindow];
            _backWindow.hidden = YES;
        }];
    }else if(_type == TKFtDateTypeFuture)
    {
        [UIView animateWithDuration:0.15 animations:^{
            [_futureDatePicker mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom);
            }];
            [self.futureDatePicker.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            [_backWindow resignKeyWindow];
            [self removeFromSuperview];
            _backWindow.hidden = YES;
        }];
    }
    
    
}

#pragma mark - setter and getter

-(UIWindow *)backWindow
{
    if (!_backWindow) {
        _backWindow=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel=UIWindowLevelAlert;
        [_backWindow becomeKeyWindow];
        [_backWindow makeKeyAndVisible];
    }
    return _backWindow;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  月
 */
-(TKFtMonthDatePicker *)monthDatePicker
{
    if (!_monthDatePicker) {
        _monthDatePicker = [[TKFtMonthDatePicker alloc]init];
        _monthDatePicker.delegate = self;
    }
    return _monthDatePicker;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  日
 */
-(TKFtDayDatePicker *)dayDatePicker
{
    if (!_dayDatePicker) {
        _dayDatePicker = [[TKFtDayDatePicker alloc]init];
        _dayDatePicker.delegate = self;
    }
    return _dayDatePicker;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  未来交易日
 */
-(TKFtFutureDatePicker *)futureDatePicker
{
    if (!_futureDatePicker) {
        if (_startDate.length>0) {
            _futureDatePicker = [[TKFtFutureDatePicker alloc]initWithStartDate:_startDate];
        }
        else
        {
            _futureDatePicker = [[TKFtFutureDatePicker alloc]init];
        }
        
        _futureDatePicker.delegate = self;
    }
    return _futureDatePicker;
}

@end

