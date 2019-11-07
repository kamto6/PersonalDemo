//
//  TKFtMonthDatePicker.m
//  TKApp_HL
//
//  Created by thinkive on 2017/7/15.
//  Copyright © 2017年 liubao. All rights reserved.
//

#import "TKFtMonthDatePicker.h"
#import "TKFtDateHelp.h"

@interface TKFtMonthDatePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) NSMutableArray *yeararr;//年份
@property (nonatomic,strong) UIPickerView *picker;


@property (nonatomic,strong) UILabel  *dateLabel;//日期标签
@property (nonatomic,strong) UIButton *confirmButton;//确定按钮
@property (nonatomic,strong) UIDatePicker *datePicker;//选择器
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSDate *date;//日期
@property (nonatomic, strong) NSString *dateString;//日期字符
@property (nonatomic,strong) UIView  *ruleLine1; //分割线1
@property (nonatomic,strong) UIView  *ruleLine2; //分割线2
@property (nonatomic,strong) UIView  *backView;//背景底图

@property (nonatomic, assign) int year;  //年
@property (nonatomic, assign) int month; //月
@property (nonatomic,assign) int tempMouth;//实时月份
@property (nonatomic,assign) int mouthLength;//月份长度

@end

@implementation TKFtMonthDatePicker

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _backView = [[UIView alloc]init];
        [_backView addCssClass:@".ftPickerTopViewBgColor"];
        [self addSubview:_backView];
        
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.centerY = _backView.centerY;
        [_dateLabel addCssClass:@".ftMainTextColor"];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.font = [UIFont ftk750AdaptationFont:14];
        _dateLabel.text = @"日期选择：";
        [_backView addSubview:_dateLabel];
        
        NSString *textColorStr = [TKFtColourHelp getftUpRedTextColor];
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont ftk750AdaptationFont:14];
        [_confirmButton addCssClass:textColorStr];
        [_confirmButton addTarget:self action:@selector(doDateConfirm) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_confirmButton];
        
        _ruleLine2 = [[UIView alloc]init];
        [_ruleLine2 addCssClass:@".ftSeparateLine"];
        [_backView addSubview:_ruleLine2];
        
        _picker = [[UIPickerView alloc] init];
        [_picker addCssClass:@".ftPickerBgColor"];
        _picker.delegate  = self;
        _picker.dataSource = self;
        _picker.showsSelectionIndicator = YES;
        [self addSubview:_picker];
        
        if (TKFT_SCREEN_HEIGHT < 568) {
            _backView.frame = CGRectMake(0, 0, TKFT_SCREEN_WIDTH, 40);
            _dateLabel.frame = CGRectMake(15, 0, TKFT_SCREEN_WIDTH/2, 40);
            _confirmButton.frame = CGRectMake(TKFT_SCREEN_WIDTH-135, 0, 120, 40);
            _confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0,-80);
            _ruleLine2.frame = CGRectMake(0, 39.5, TKFT_SCREEN_WIDTH, 0.5);
            _picker.frame = CGRectMake(0, CGRectGetMaxY(_backView.frame), TKFT_SCREEN_WIDTH, 200);
        }else{
            _backView.frame = CGRectMake(0, 0, TKFT_SCREEN_WIDTH, ft750AdaptationWidth(40));
            _dateLabel.frame = CGRectMake(ft750AdaptationWidth(15), 0, TKFT_SCREEN_WIDTH/2, ft750AdaptationWidth(40));
            _confirmButton.frame = CGRectMake(TKFT_SCREEN_WIDTH-ft750AdaptationWidth(135), 0, ft750AdaptationWidth(120), ft750AdaptationWidth(40));
            _confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0,-ft750AdaptationWidth(80));
            _ruleLine2.frame = CGRectMake(0, ft750AdaptationWidth(39.5), TKFT_SCREEN_WIDTH, ft750AdaptationWidth(0.5));
            _picker.frame = CGRectMake(0, CGRectGetMaxY(_backView.frame), TKFT_SCREEN_WIDTH, ft750AdaptationWidth(200));
        }
        
        _yeararr = [NSMutableArray array];
        
        [self setPickerViewInitialValue];
    }
    return self;
}

#pragma mark - help method
/**
 *  @author yyf, 16-11
 *
 *  @brief  确认
 */
-(void)doDateConfirm
{
    if ([_delegate respondsToSelector:@selector(datePickerDoDateConfirmWithDateString:)])
    {
        [_delegate datePickerDoDateConfirmWithDateString:_dateString];
    }
}

-(NSAttributedString *)changStringColorWith:(NSString *)string
{
    NSString *dataStr = [TKFtDateHelp doConversionYearMounthdayWithString:string];
    NSString *newSring = [@"日期选择：" stringByAppendingString:dataStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:newSring];
    [attStr addAttribute:NSForegroundColorAttributeName value:[[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftMiddleTextColor"].textColor range:NSMakeRange(0, 5)];
    [attStr addAttribute:NSForegroundColorAttributeName value:[[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftMainTextColor"].textColor range:NSMakeRange(5, dataStr.length-5)];
    return attStr;
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  设置时间控件初始值
 *
 */
-(void)setPickerViewInitialValue
{
    NSString *string;
    if ([TKFtEnvHelp shareInstance].ftCounter == FT_COUNTER_HS) {
        string = [TKFtUserinfo shareInstance].HSTradingDay;
    }else{
        string = [TKFtUserinfo shareInstance].TradingDay;
    }
    
    _dateString = [TKFtDateHelp doConversionTimeFormatWithString:string];
    NSString *showStr = [TKFtDateHelp doConverMonthDateWithString:_dateString];
    if (showStr) {
        _dateLabel.attributedText = [self changStringColorWith:showStr];
    }
    if (string.length >= 6) {
        NSString *year = [string substringWithRange:NSMakeRange(0, 4)];
        NSString *mouth = [string substringWithRange:NSMakeRange(4, 2)];
        NSInteger yearInt = year.integerValue;
        for (NSInteger i = yearInt - 10; i <= yearInt; i++)
        {
            NSString *yearStr = [NSString stringWithFormat:@"%ld年",i];
            [_yeararr addObject:yearStr];
        }
        
        _tempMouth = mouth.intValue;
        _mouthLength = mouth.intValue;
        
        NSInteger selectRow = _yeararr.count - 1;
        [_picker selectRow:selectRow inComponent:0 animated:YES];
        [_picker selectRow:mouth.intValue-1 inComponent:1 animated:YES];
    }
}

- (void)setShowTimeStr:(NSString *)showTimeStr{
    
    _showTimeStr = showTimeStr;
    if (showTimeStr.length<6) return;
    _dateLabel.attributedText = [self changStringColorWith:showTimeStr];
    
    if ([_showTimeStr rangeOfString:@"/"].location != NSNotFound) {
        NSArray *dateArray = [_showTimeStr componentsSeparatedByString:@"/"];
        if (dateArray.count >= 2) {

            NSString *year = dateArray[0];
            NSString *mouth = dateArray[1];
            _tempMouth = mouth.intValue;
            _mouthLength = mouth.intValue;
            
            NSInteger selectRow = year.integerValue -1;
            [_picker selectRow:selectRow inComponent:0 animated:NO];
            [_picker selectRow:mouth.intValue-1 inComponent:1 animated:NO];
        }
    }
}

#pragma mark - pickerview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return _yeararr.count;
    }
    else
    {
        return _mouthLength;
    }
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *mycom1 = [[UILabel alloc] init];
    mycom1.textAlignment = NSTextAlignmentCenter;
    [mycom1 addCssClass:@".ftDefaultTextColor"];
    mycom1.backgroundColor = [UIColor clearColor];
    mycom1.frame = CGRectMake(0, 0, TKFT_SCREEN_WIDTH/2.0, 50);
    [mycom1 setFont:[UIFont ftk750AdaptationFont:16]];
    if(component == 0)
    {
        mycom1.text = [NSString stringWithFormat:@"%@",[_yeararr objectAtIndex:row]];
    }
    else if(component == 1){
        mycom1.text = [NSString stringWithFormat:@"%02ld月",row+1];
    }
    return mycom1;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return TKFT_SCREEN_WIDTH/2.0;
}


//选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    int rowy = (int)[_picker selectedRowInComponent:0];
    NSInteger selectYear = [[_yeararr objectAtIndex:rowy] intValue];
    int lastYear = [[_yeararr lastObject] intValue];
    if(component == 0)
    {
        if (selectYear == lastYear)
        {
            _mouthLength = _tempMouth;
        }else
        {
            _mouthLength = 12;
        }
        
        [_picker reloadComponent:1];
        //        [_picker selectRow:0 inComponent:1 animated:YES];
    }
    int rowm = (int)[_picker selectedRowInComponent:1];
    _year = [[_yeararr objectAtIndex:rowy] intValue];
    _month = (int)rowm+1;
    
    _dateString = [NSString stringWithFormat:@"%d/%d",_year,_month];
    _dateLabel.attributedText = [self changStringColorWith:_dateString];
}


@end
