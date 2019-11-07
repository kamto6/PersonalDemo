//
//  TKFtDayDatePicker.m
//  TKApp_HL
//
//  Created by thinkive on 2017/7/15.
//  Copyright © 2017年 liubao. All rights reserved.
//

#import "TKFtFutureDatePicker.h"
#import "TKFtDateHelp.h"

@interface TKFtFutureDatePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) NSMutableArray *curMontharr;//当前月
@property (nonatomic,strong) NSMutableArray *curDayarr;//当前日
@property (nonatomic,strong) NSMutableArray *yeararr;
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
@property (nonatomic,strong) NSString *startDate;

@end

@implementation TKFtFutureDatePicker

-(instancetype)initWithStartDate:(NSString *)date
{
    _startDate = [date copy];
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _backView = [[UIView alloc]init];
        _backView.frame = CGRectMake(0, 0, TKFT_SCREEN_WIDTH, ft750AdaptationWidth(40));
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
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.showsSelectionIndicator = YES;
        [_picker addCssClass:@".ftPickerBgColor"];
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
        
        [self setPickerViewInitialValue];
    }
    return self;
}

/**
 初始化
 */
-(void)setPickerViewInitialValue
{
    
    _yeararr = [NSMutableArray array];
    NSString *string = [self getTradingDay];
    if (_startDate.length>0) {
        string = _startDate;
    }
    _dateString = [TKFtDateHelp doConversionTimeFormatWithString:string];
    if (_dateString) {
        _dateLabel.attributedText = [self changStringColorWith:_dateString];
    }
    
    if (string.length < 8) return;
    
    NSString *year = [string substringWithRange:NSMakeRange(0, 4)];
    NSString *mouth = [string substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [string substringWithRange:NSMakeRange(6, 2)];
    
   
    NSInteger yearInt = year.integerValue;
    for (NSInteger i = yearInt; i <= yearInt + 7; i++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",i];
        [_yeararr addObject:yearStr];
    }
    
    NSInteger tempMouth = mouth.intValue;
    NSInteger dayLength = [TKFtDateHelp getCurrentMonthDays:string];
    
    for (NSInteger i = tempMouth; i <= 12; i++)
    {
        [self.curMontharr addObject:[NSString stringWithFormat:@"%02ld月",i]];
    }
    
    for (NSInteger i = day.intValue; i <= dayLength; i++)
    {
        [self.curDayarr addObject:[NSString stringWithFormat:@"%02ld日",i]];
    }
    
}

- (void)setShowTimeStr:(NSString *)showTimeStr
{
    _showTimeStr = showTimeStr;
    if (showTimeStr.length< 8) return;
    _dateLabel.attributedText = [self changStringColorWith:_showTimeStr];
    if ([_showTimeStr rangeOfString:@"/"].location != NSNotFound) {
        NSArray *dateArray = [_showTimeStr componentsSeparatedByString:@"/"];
        if (dateArray.count == 3) {
            
            NSString *year = dateArray[0];
            NSString *mouth = dateArray[1];
            NSString *day = dateArray[2];
            //年
            NSString *tempStr = [NSString stringWithFormat:@"%@年",year];
            NSInteger yearRow = [_yeararr indexOfObject:tempStr];
            
            NSString *tradeDate = [self getTradingDay];
            if (tradeDate.length < 8) return;
            //月
            NSString *tradeYear = [tradeDate substringWithRange:NSMakeRange(0, 4)];
            NSString *tradeMonth = [tradeDate substringWithRange:NSMakeRange(4, 2)];
            
            [self.curMontharr removeAllObjects];
            
            NSInteger mouthStartIndex = ([year isEqualToString:tradeYear])?tradeMonth.integerValue:1;
            for (; mouthStartIndex <= 12; mouthStartIndex++) {
                NSString *tempStr = [NSString stringWithFormat:@"%02ld月",mouthStartIndex];
                [self.curMontharr addObject:tempStr];
            }
            NSString *tempMouthStr = [NSString stringWithFormat:@"%02ld月",mouth.integerValue];
            NSInteger mouthRow = [self.curMontharr indexOfObject:tempMouthStr];
            
            //日
            NSString *tradeDay = [tradeDate substringWithRange:NSMakeRange(6, 2)];
            
            NSInteger dayLength = [TKFtDateHelp getMonthDaysWithYear:year.integerValue month:mouth.integerValue];
            
            NSInteger dayStartIndex = (year.integerValue ==  tradeYear.integerValue&&mouth.integerValue == tradeMonth.integerValue)?tradeDay.integerValue:1;
            
            [self.curDayarr removeAllObjects];
            
            for (; dayStartIndex <= dayLength; dayStartIndex++) {
                NSString *tempStr = [NSString stringWithFormat:@"%02ld日",dayStartIndex];
                [self.curDayarr addObject:tempStr];
            }
            
            NSString *tempDayStr = [NSString stringWithFormat:@"%02ld日",day.integerValue];
            NSInteger dayRow = [self.curDayarr indexOfObject:tempDayStr];
            
            //刷新component
            [_picker reloadComponent:1];
            [_picker reloadComponent:2];
            //刷新row
            [_picker selectRow:yearRow inComponent:0 animated:NO];
            [_picker selectRow:mouthRow inComponent:1 animated:NO];
            [_picker selectRow:dayRow inComponent:2 animated:NO];
        }
    }
    
    
}




#pragma mark - event method

/**
 确认
 */
-(void)doDateConfirm
{
    if ([_delegate respondsToSelector:@selector(datePickerDoDateConfirmWithDateString:)])
    {
        [_delegate datePickerDoDateConfirmWithDateString:_dateString];
    }
}

#pragma mark - privite method

/**
 同步显示字符串
 
 @param timeStr 显示字符串
 */
-(void)freshTimeStr:(NSString *)timeStr
{
    NSString *string = [self getTradingDay];
    _dateString = [TKFtDateHelp doConversionTimeFormatWithString:string];
    _dateLabel.attributedText = [self changStringColorWith:_dateString];
}
/**
 * 获取交易日期
 */
- (NSString *)getTradingDay{
    if ([TKFtEnvHelp shareInstance].ftCounter == FT_COUNTER_HS) {
        return [TKFtUserinfo shareInstance].HSTradingDay;
    }else{
        return [TKFtUserinfo shareInstance].TradingDay;;
    }
}
/**
 转换时间字符串颜色
 
 @param string 时间字符串
 @return 颜色时间字符串
 */
-(NSAttributedString *)changStringColorWith:(NSString *)string
{
    NSString *dateStr = [TKFtDateHelp doConversionYearMounthdayWithString:string];
    if (dateStr) {
        NSString *newSring = [@"日期选择：" stringByAppendingString:dateStr];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:newSring];
        [attStr addAttribute:NSForegroundColorAttributeName value:[[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftMiddleTextColor"].textColor range:NSMakeRange(0, 5)];
        [attStr addAttribute:NSForegroundColorAttributeName value:[[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftMainTextColor"].textColor range:NSMakeRange(5, dateStr.length-5)];
        return attStr;
    }else{
        return nil;
    }
    
}


#pragma mark - PickerView Datadelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    NSInteger count = 0;
    if (_yeararr.count) {
        count ++;
    }
    if (_curMontharr.count) {
        count ++;
    }
    if (_curDayarr.count) {
        count ++;
    }
    return count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _yeararr.count;
    }else if (component == 1){
        return self.curMontharr.count;
    }else{
        return self.curDayarr.count;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *mycom1 = [[UILabel alloc] init];
    mycom1.textAlignment = NSTextAlignmentCenter;
    [mycom1 addCssClass:@".ftDefaultTextColor"];
    mycom1.backgroundColor = [UIColor clearColor];
    mycom1.frame = CGRectMake(0, 0, TKFT_SCREEN_WIDTH/3.0, 50);
    [mycom1 setFont:[UIFont ftk750AdaptationFont:16]];
    if (component == 0) {
        mycom1.text = [NSString stringWithFormat:@"%@",[_yeararr objectAtIndex:row]];
    }else if (component == 1){
        mycom1.text = self.curMontharr[row];
    }else{
        mycom1.text = self.curDayarr[row];
    }
    return mycom1;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return TKFT_SCREEN_WIDTH/3.0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    int rowy = (int)[_picker selectedRowInComponent:0];
    if (component == 0)
    {
        [self setCurrentMontharrWithSelectRow:row];
        [_picker reloadComponent:1];
        [_picker selectRow:0 inComponent:1 animated:NO];
        
        [self setCurrentDayarrWithSelectRow:row];
        [_picker reloadComponent:2];
        [_picker selectRow:0 inComponent:2 animated:NO];
        
        
    }
    if (component == 1)
    {
        [self setCurrentDayarrWithSelectRow:row];
        
        [_picker reloadComponent:2];
        [_picker selectRow:0 inComponent:2 animated:NO];
    }
    
    int rowm = (int)[_picker selectedRowInComponent:1];
    int rowd = (int)[_picker selectedRowInComponent:2];
    
    NSString *dayStr = self.curDayarr[rowd];
    NSString *monthStr = self.curMontharr[rowm];
    NSString *yearStr = [_yeararr objectAtIndex:rowy];
    
    NSString *day = [dayStr substringToIndex:dayStr.length -1];
    NSString *month = [monthStr substringToIndex:monthStr.length -1];
    NSString *year = [yearStr substringToIndex:yearStr.length - 1];
    
    _dateString = [NSString stringWithFormat:@"%@/%@/%@",year,month,day];
    _dateLabel.attributedText = [self changStringColorWith:_dateString];
}

#pragma mark - privite method

/**
 设置月数组
 
 @param selectRow 选中月
 */
-(void)setCurrentMontharrWithSelectRow:(NSInteger)selectRow
{
    int tempRow = (int)[_picker selectedRowInComponent:0];
    NSInteger selectYear = [[_yeararr objectAtIndex:tempRow] intValue];
    int tradeYear = [[_yeararr firstObject] intValue];
    
    NSString *tradeDay = [self getTradingDay];
    if (_startDate.length>0) {
        tradeDay = _startDate;
    }
    if (tradeDay.length >=6) {
        NSString *mouth = [tradeDay substringWithRange:NSMakeRange(4, 2)];
        NSInteger mouthInt = mouth.integerValue;
        
        [self.curMontharr removeAllObjects];
        
        NSInteger startIndex = (selectYear == tradeYear)?mouthInt:1;
        for (; startIndex <= 12; startIndex++) {
            NSString *tempStr = [NSString stringWithFormat:@"%02ld月",startIndex];
            [self.curMontharr addObject:tempStr];
        }
    }
}

/**
 设置日
 
 @param selectRow 选择行
 */
-(void)setCurrentDayarrWithSelectRow:(NSInteger)selectRow
{
    int tempRow = (int)[_picker selectedRowInComponent:0];
    NSInteger selectYear = [[_yeararr objectAtIndex:tempRow] intValue];
    int tradeYear = [[_yeararr firstObject] intValue];
    
    int tempMouthRow = (int)[_picker selectedRowInComponent:1];
    NSInteger selectMouth = [[self.curMontharr objectAtIndex:tempMouthRow] intValue];
    
    NSString *tradeDay = [self getTradingDay];
    if (!tradeDay || tradeDay.length < 8) return;
    if (_startDate.length>0) {
        tradeDay = _startDate;
    }
    NSString *mouth = [tradeDay substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [tradeDay substringWithRange:NSMakeRange(6, 2)];
    NSInteger mouthInt = mouth.integerValue;
    
    NSInteger dayLength = [TKFtDateHelp getMonthDaysWithYear:selectYear month:selectMouth];
    
    NSInteger startIndex = (selectYear == tradeYear&&selectMouth == mouthInt)?day.integerValue:1;
    
    [self.curDayarr removeAllObjects];
    
    for (; startIndex <= dayLength; startIndex++) {
        NSString *tempStr = [NSString stringWithFormat:@"%02ld日",startIndex];
        [self.curDayarr addObject:tempStr];
    }
    
}

#pragma mark - setter and getter

/**
 *  @author yyf, 17-04
 *
 *  @brief  当前日数组
 *
 *
 */
-(NSMutableArray *)curDayarr
{
    if (!_curDayarr) {
        _curDayarr= [NSMutableArray array];
    }
    
    return _curDayarr;
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  当前月数组
 *
 */
-(NSMutableArray *)curMontharr
{
    if (!_curMontharr) {
        _curMontharr = [NSMutableArray array];
    }
    
    return _curMontharr;
}



@end
