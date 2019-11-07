//
//  YYTextField.m
//  testKeyBoard
//
//  Created by thinkive on 2017/2/26.
//  Copyright © 2017年 com.thinkive.www. All rights reserved.
//

#import "TKFtTextField.h"
#import "TKFtNumberKeyBoard.h"
#import "TKFtPriceKeyBoard.h"
#import "TKFtDecimalKeyBoard.h"
#import "TKFtNSuperPriceKeyBoard.h"
#import "TKFtChooseKeyBoard.h"
#import "TKFtToolBar.h"
#import "TKFtStringHelp.h"
#import "TKFtService.h"
#import "TKFtmarketBean.h"
#import "TKFtCapitalBean.h"
#import "TKFtInstrumentBean.h"
#import "TKFtDecimalPlusMinusKeyBoard.h"

//hs
#import "TKFtHsmarketBean.h"
#import "TKFtHsInstrumentBean.h"
#import "TKFtHsCapitalBean.h"
#import "TKFtHsService.h"


#define HLKEYBOARD_HEIGHT ft750AdaptationWidth(215)

@interface TKFtTextField ()<TKFtToolBarDelegate,TKFtKeyBoardDelegate,UITextFieldDelegate>

@property (nonatomic,assign) NSInteger limitLength;
@property (nonatomic,strong) TKFtToolBar *toolBar;//工具栏
@property (nonatomic,assign) BOOL isFirstEdit;//判断是否是第一次输入，第一次输入，把输入框置空
@property (nonatomic,strong) NSString *formName;//来自的模块名
@property (nonatomic,strong) TKFtService *service;
@property (nonatomic,strong) TKFtHsService *hsService;
@property (nonatomic,strong) NSDictionary *longmarDict;//客户保证金信息
@property (nonatomic,strong) NSDictionary *openMarDict;//合约手续费信息
@property (nonatomic,strong) TKFtChooseKeyBoard *chooseKeyBoard;//自选股键盘


@end

@implementation TKFtTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _limitLength = 100;
        _enableCopy = NO;
        _enableSelectAll = NO;
        _enableChoose = NO;
        [self setTintColor:[[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftMiddleTextColor"].textColor];
//        [self setValue:[[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftLightTextColor"].textColor forKeyPath:@"_placeholderLabel.textColor"];
//        [self setValue:[UIFont ftk750AdaptationFont:14] forKeyPath:@"_placeholderLabel.font"];
        self.ftplaceholderFont = [UIFont ftk750AdaptationFont:14];
        self.ftplaceholderLabelColor = [[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftLightTextColor"].textColor;
        _isFirstEdit = YES;
        //添加KVO做直接赋值改变输入框的状态
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideNotify) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (TKFtService *)service{
    if (!_service) {
        _service = [[TKFtService alloc]init];
    }
    return _service;
}
- (TKFtHsService *)hsService{
    if (!_hsService) {
        _hsService = [[TKFtHsService alloc]init];
    }
    return _hsService;
}
/**
 监听收键盘
 */
-(void)keyboardDidHideNotify
{
    _isFirstEdit = YES;
}


#pragma mark - setter and getter

/**
 设置键盘类型

 @param boardType 类型
 */
-(void)setBoardType:(TKFtKeyBoardType)boardType
{
    _boardType = boardType;
    _toolBar = [[TKFtToolBar alloc]initWithFrame:CGRectMake(0, 0, TKFT_SCREEN_WIDTH, ft750AdaptationWidth(40))];
    _toolBar.delegate = self;
    if (self.boardType == TKFtKeyBoardTypePrice || self.boardType == TKFtKeyBoardTypeCloudCondition)
    {
        CGFloat H = 205;//ft750AdaptationWidth(205);
        if (ISIPHONEX) {
            H = 205 + 34;
        }
        TKFtPriceKeyBoard *priceKeyBoard = [[TKFtPriceKeyBoard alloc]initWithFrame:CGRectMake(0, 0, TKFT_SCREEN_WIDTH, H) Type:self.boardType];
        priceKeyBoard.delegate = self;
        self.inputView = priceKeyBoard;
        self.inputAccessoryView = _toolBar;
        
    }else if(self.boardType == TKFtKeyBoardTypeNumber)
    {
        CGFloat H = 164;//ft750AdaptationWidth(184);
        if (ISIPHONEX) {
            H = 164 + 34;
        }
        TKFtNumberKeyBoard *numberKeyBoard = [[TKFtNumberKeyBoard alloc]initWithFrame:CGRectMake(0, 0, TKFT_SCREEN_WIDTH, H)];
        numberKeyBoard.delegate = self;
        self.inputView = numberKeyBoard;
        self.inputAccessoryView = _toolBar;
        
    }else if(self.boardType == TKFtKeyBoardTypeDecimal || self.boardType == TKFtKeyBoardTypeWarnPrice)
    {
        CGFloat H = 164;//ft750AdaptationWidth(184);
        if (ISIPHONEX) {
            H = 164 + 34;
        }
        TKFtDecimalKeyBoard *decimalKeyBoard = [[TKFtDecimalKeyBoard alloc]initWithFrame:CGRectMake(0, 0, TKFT_SCREEN_WIDTH, H)];
        decimalKeyBoard.delegate = self;
        self.inputView = decimalKeyBoard;
        self.inputAccessoryView = _toolBar;
        
    }else if(self.boardType == TKFtKeyBoardTypeParameter)
    {
        CGFloat H = 164;//ft750AdaptationWidth(184);
        if (ISIPHONEX) {
            H = 164 + 34;
        }
        TKFtNumberKeyBoard *numberKeyBoard = [[TKFtNumberKeyBoard alloc]initWithFrame:CGRectMake(0, 0, TKFT_SCREEN_WIDTH, H)];
        numberKeyBoard.delegate = self;
        self.inputView = numberKeyBoard;
        self.inputAccessoryView = _toolBar;
        
    }else if(self.boardType == TKFtKeyBoardTypeBack)
    {
        CGFloat H = 164;//ft750AdaptationWidth(184);
        if (ISIPHONEX) {
            H = 164 + 34;
        }
        TKFtDecimalKeyBoard *decimalKeyBoard = [[TKFtDecimalKeyBoard alloc]initWithFrame:CGRectMake(0, 0, TKFT_SCREEN_WIDTH, H)];
        decimalKeyBoard.delegate = self;
        self.inputView = decimalKeyBoard;
        self.inputAccessoryView = _toolBar;
        
    }else if(self.boardType == TKFtKeyBoardTypeNSuperPrice)
    {
        CGFloat H = 205;//ft750AdaptationWidth(205);
        if (ISIPHONEX) {
            H = 205 + 34;
        }
        TKFtNSuperPriceKeyBoard *priceKeyBoard = [[TKFtNSuperPriceKeyBoard alloc]initWithFrame:CGRectMake(0, 0, TKFT_SCREEN_WIDTH, H)];
        priceKeyBoard.delegate = self;
        self.inputView = priceKeyBoard;
        self.inputAccessoryView = _toolBar;
        
    }else if(self.boardType == TKFtKeyBoardTypeChoose)
    {
        CGFloat H = 164;//ft750AdaptationWidth(184);
        if (ISIPHONEX) {
            H = 164 + 34;
        }
        TKFtChooseKeyBoard *chooseKeyBoard = [[TKFtChooseKeyBoard alloc]initWithFrame:CGRectMake(0, 0, TKFT_SCREEN_WIDTH, H)];
        chooseKeyBoard.delegate = self;
        self.inputView = chooseKeyBoard;
        self.inputAccessoryView = _toolBar;
        self.chooseKeyBoard = chooseKeyBoard;
        
    }else if(self.boardType == TKFtKeyBoardTypeDecimalPlusMinus)
    {
        CGFloat H = 164;//ft750AdaptationWidth(184);
        if (ISIPHONEX) {
            H = 164 + 34;
        }
        TKFtDecimalPlusMinusKeyBoard *decimalKeyBoard = [[TKFtDecimalPlusMinusKeyBoard alloc]initWithFrame:CGRectMake(0, 0, TKFT_SCREEN_WIDTH, H)];
        decimalKeyBoard.delegate = self;
        self.inputView = decimalKeyBoard;
        self.inputAccessoryView = _toolBar;
        
    }
    else
    {
        TKLogDebug(@"------");
    }
    
    
}


/**
 *  @author yyf, 17-04
 *
 *  @brief  设置合约行情模型
 *
 *  @param  合约行情模型
 */
-(void)setMarketBean:(TKFtmarketBean *)marketBean
{
    _marketBean = marketBean;
    
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  设置合约信息模型
 *
 *  @param  合约信息模型
 */
-(void)setInstrumentBean:(TKFtInstrumentBean *)instrumentBean
{
    _instrumentBean = instrumentBean;
}

#pragma mark - TKFtToolBarDelegate

-(void)toolBarHide:(TKFtToolBar *)toolBar
{
    _isFirstEdit = YES;
    [self resignFirstResponder];
}


#pragma mark -  TKFtPriceKeyBoardDelegate

/**
 *  @author yyf, 17-04
 *
 *  @brief  输入价格类型
 *
 *  @param  TKFtPriceKeyBoard
 *  @param  价格类型
 */
- (void)priceKeyBoard:(TKFtPriceKeyBoard *)keyBoard didClickTileName:(NSString *)titleName
{
    //    self.text = titleName;
    [self appendChar:titleName];
}

#pragma mark -  TKFtKeyBoardDelegate

/**
 *  @author yyf, 17-04
 *
 *  @brief  追加字符
 *
 *  @param  字符
 */
-(void)appendChar:(NSString *)charStr
{
    
    if (![charStr isEqualToString:@"."])
    {
        if (_isFirstEdit == YES)
        {
            if (self.boardType == TKFtKeyBoardTypeBack)
            {
                if ([self.text hasPrefix:@"回撤 "])
                {
                    self.text = @"回撤 ";
                }
            }else
            {
                if (self.boardType == TKFtKeyBoardTypeParameter)
                {
                    //超价键盘不需要清空，原始值默认是1
                    if ([charStr isEqualToString:@"0"])
                    {
                        charStr = @"";
                        self.text = @"1";
                    }else
                    {
                        self.text = @"";
                    }
                }else
                {
                    self.text = @"";
                }
            }
            
            _isFirstEdit = NO;
        }
    }
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[\u4e00-\u9fa5]+"];
    if([predicate evaluateWithObject:self.text])
    {
        //是中文
        self.text = @"";
    }
    
    if ([predicate evaluateWithObject:charStr])
    {
        self.text = @"";
    }
    
    //手数键盘
    if(self.boardType == TKFtKeyBoardTypeNumber)
    {
        if (_inputLimitLength>0) {
            if (self.text.length >= _inputLimitLength)
            {
                return;
            }
        }
        else
        {
            if (self.text.length >= 12)
            {
                return;
            }
        }
    }
    
    //价格键盘
    if(self.boardType == TKFtKeyBoardTypePrice || self.boardType == TKFtKeyBoardTypeNSuperPrice || self.boardType == TKFtKeyBoardTypeCloudCondition)
    {
        if (self.text.length >= 30)
        {
            return;
        }
        
    }
    
    //小数点价格键盘
    if(self.boardType == TKFtKeyBoardTypeDecimal)
    {
        if (self.text.length >= 30)
        {
            return;
        }
        
    }
    //预警价格键盘 9位整数 6位小数
    if(self.boardType == TKFtKeyBoardTypeWarnPrice)
    {
        NSRange floatRange =  [self.text rangeOfString:@"."];
        if (floatRange.location != NSNotFound)
        {
            NSArray *arr = [self.text componentsSeparatedByString:@"."];
            NSString *str1 = arr[0];
            NSString *str2 = arr[1];
            
            //获取光标
            NSRange selectedRange = [self selectedRange];
            
            if (selectedRange.location<=floatRange.location)//在整数输入
            {
                if (str1.length >= 9) {
                    return;
                }
            }
            else//在小数输入
            {
                if (str2.length >= 6) {
                    return;
                }
            }
        }
        else
        {
            if (self.text.length >= 9 && ![charStr isEqualToString:@"."]) {
                return;
            }
        }
        
        if (self.text.length >= 16)
        {
            return;
        }
        
    }
    
    //涨跌幅键盘 4位整数 2位小数
    if(self.boardType == TKFtKeyBoardTypeDecimalPlusMinus)
    {
        NSRange floatRange =  [self.text rangeOfString:@"."];
        if (floatRange.location != NSNotFound)
        {
            NSArray *arr = [self.text componentsSeparatedByString:@"."];
            NSString *str1 = arr[0];
            NSString *str2 = arr[1];
            
            //获取光标
            NSRange selectedRange = [self selectedRange];
            
            if (selectedRange.location<=floatRange.location)//在整数输入
            {
                if (str1.length >= 4) {
                    return;
                }
            }
            else//在小数输入
            {
                if (str2.length >= 2) {
                    return;
                }
            }
        }
        else
        {
            if (self.text.length >= 4 && ![charStr isEqualToString:@"."]) {
                return;
            }
        }
        
        if (self.text.length >= 7)
        {
            return;
        }
        
    }
    
    //回撤键盘
    if(self.boardType == TKFtKeyBoardTypeBack)
    {
        if (self.text.length >= 33)
        {
            return;
        }
        
    }
    
    //超价输入5位
    if(self.boardType == TKFtKeyBoardTypeParameter)
    {
        if (self.text.length >= 7)
        {
            return;
        }
    }
    
    
    if ([TKStringHelper isEmpty:self.text])
    {
        //第一位是小数点，不能再输入
        if ([charStr isEqualToString:@"."])
        {
            return;
        }
    }
    
    //已经存在小数点，再次输入也不行
    NSRange floatRange =  [self.text rangeOfString:@"."];
    if (floatRange.location != NSNotFound)
    {
        if ([charStr isEqualToString:@"."])
        {
            return;
        }
    }
    
    //第一位是0的时候，第二位不能是0--9
    if ([TKStringHelper isNotEmpty:self.text])
    {
        NSString *firstPlaceStr = [self.text substringToIndex:1];
        if ([firstPlaceStr isEqualToString:@"0"] && self.text.length == 1)
        {
            if (![charStr isEqualToString:@"."])
            {
                NSInteger charStrInt = [charStr integerValue];
                if (0 <= charStrInt  && charStrInt <= 9)
                {
                    self.text = @"";
                }
            }
        }
    }
    
    
    if (self.boardType == TKFtKeyBoardTypeBack)
    {
        if ([self.text isEqualToString:@"回撤 0"])
        {
            if (![charStr isEqualToString:@"."])
            {
                self.text = @"回撤 ";
            }
            
        }
    }
    
    
    NSMutableString *valueStr = [NSMutableString stringWithFormat:@"%@",self.text];
    //获取光标
    NSRange selectedRange = [self selectedRange];
    [valueStr insertString:charStr atIndex:selectedRange.location];
    if (self.limitLength > 0 && valueStr.length > self.limitLength)
    {
        return;
    }
    self.text = valueStr;
    
    if ([self.text hasPrefix:@"回撤 "])
    {
        self.attributedText = [self creteaAttributedStringWhitstring:self.text andStartIndex:0];
    }
    //设置光标
    [self setSelectedRange:NSMakeRange(selectedRange.location + charStr.length, 0)];
    if ([_ftdelegate respondsToSelector:@selector(ftTextField:andChangeString:)])
    {
        [_ftdelegate ftTextField:self andChangeString:valueStr];
    }
    
    [self doADaptationFontWithTextString:self.text];
}



/**
 *  @author yyf, 17-04
 *
 *  @brief  删除字符
 */
- (void)deleteChar
{
    //删除字符，把第一次输入改为no
    _isFirstEdit = NO;
    
    if ([self.text hasPrefix:@"回撤 "])
    {
        self.attributedText = [self creteaAttributedStringWhitstring:self.text andStartIndex:0];
        if ([self.text isEqualToString:@"回撤 "])
        {
            return;
        }
    }
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[\u4e00-\u9fa5]+"];
    if([predicate evaluateWithObject:self.text])
    {
        //是中文
        self.text = @"0";
    }
    NSRange selectedRange = [self selectedRange];
    if (self.text.length == 0 || selectedRange.location == 0)
    {
        //清空为0后，需要应显示价格
        if ([_ftdelegate respondsToSelector:@selector(ftTextField:andChangeString:)])
        {
            NSString *priceTickeStr = [self getPriceTicke];
            NSString *tempStr = [TKFtPriceStrHelp convertPriceWithPrice:0.0 andPriceTicke:priceTickeStr];
            [_ftdelegate ftTextField:self andChangeString:tempStr];
        }
        return;
    }
    NSMutableString *valueStr = [NSMutableString stringWithFormat:@"%@",self.text];
    NSRange range = {(selectedRange.location - 1),1};
    [valueStr deleteCharactersInRange:range];
    
    //限制输入长度
    if (self.boardType == TKFtKeyBoardTypePrice || self.boardType == TKFtKeyBoardTypeNSuperPrice || self.boardType == TKFtKeyBoardTypeCloudCondition)
    {
        if ([TKStringHelper isEmpty:valueStr])
        {
            self.text = @"00";
            valueStr = [NSMutableString stringWithString:@"0"];
            selectedRange = [self selectedRange];
        }
    }else if(self.boardType == TKFtKeyBoardTypeNumber)
    {
        if ([TKStringHelper isEmpty:valueStr])
        {
            self.text = @"00";
            valueStr = [NSMutableString stringWithString:@"0"];
            selectedRange = [self selectedRange];
        }
        
    }else if(self.boardType == TKFtKeyBoardTypeDecimal || self.boardType == TKFtKeyBoardTypeDecimalPlusMinus|| self.boardType == TKFtKeyBoardTypeWarnPrice)
    {
        if ([TKStringHelper isEmpty:valueStr])
        {
            self.text = @"00";
            valueStr = [NSMutableString stringWithString:@"0"];
            selectedRange = [self selectedRange];
        }
    }else if(self.boardType == TKFtKeyBoardTypeBack)
    {
        if ([valueStr isEqualToString:@"回撤 "])
        {
            self.text = [NSString stringWithFormat:@"回撤 %@",@"00"];
            valueStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"回撤 %@",@"0"]];
            self.attributedText = [self creteaAttributedStringWhitstring:self.text andStartIndex:0];
            selectedRange = [self selectedRange];
        }
        
    }else
    {
        if ([TKStringHelper isEmpty:valueStr])
        {
            self.text = @"00";
            valueStr = [NSMutableString stringWithString:@"0"];
            selectedRange = [self selectedRange];
        }
    }
    self.text = valueStr;
    
    if ([self.text hasPrefix:@"回撤 "])
    {
        self.attributedText = [self creteaAttributedStringWhitstring:self.text andStartIndex:0];
    }
    [self setSelectedRange:NSMakeRange(selectedRange.location - 1, 0)];
    
    
    if ([_ftdelegate respondsToSelector:@selector(ftTextField:andChangeString:)])
    {
        [_ftdelegate ftTextField:self andChangeString:valueStr];
    }
    [self doADaptationFontWithTextString:self.text];
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  加
 */
- (void)plusNumber
{
    _isFirstEdit = NO;
    if (self.boardType == TKFtKeyBoardTypePrice || self.boardType == TKFtKeyBoardTypeNSuperPrice || self.boardType == TKFtKeyBoardTypeCloudCondition)
    {
        NSString *priceTickeStr = [self getPriceTicke];
        CGFloat priceTickeFloat = [priceTickeStr floatValue];
        double tempFloat = 0.0;
        double tempStr = 0.0;
        if ([TKFormatHelper isChinese:self.text])
        {
            tempStr = [self getCurrentPriceValue];
        }else
        {
            tempFloat = [self.text doubleValue];
            tempStr = tempFloat + priceTickeFloat;
        }
        
        if ([TKStringHelper isEmpty:priceTickeStr])
        {
            self.text = @"0";
        }else
        {
            NSString *newStr = [TKFtPriceStrHelp convertPriceWithPrice:tempStr andPriceTicke:priceTickeStr];
            if (newStr.length < 31)
            {
                self.text = newStr;
            }
        }
        
        if ([_ftdelegate respondsToSelector:@selector(ftTextField:andChangeString:)])
        {
            [_ftdelegate ftTextField:self andChangeString:self.text];
        }
    }else if(self.boardType == TKFtKeyBoardTypeNumber)
    {
        NSUInteger integer = [self.text integerValue];
        NSString *tempStr = [NSString stringWithFormat:@"%lu",integer + 1];
        if (_inputLimitLength>0) {
            if (tempStr.length <= _inputLimitLength)
            {
                self.text = tempStr;
            }
        }
        else
        {
            if (tempStr.length < 13)
            {
                self.text = tempStr;
            }
        }
    }else if(self.boardType == TKFtKeyBoardTypeDecimal)
    {
        NSString *priceTickeStr = [self getPriceTicke];
        CGFloat priceTickeFloat = [priceTickeStr doubleValue];
        
        double tempFloat = [self.text doubleValue];
        double plusFloat = tempFloat + priceTickeFloat;
        NSString *convertStr = nil;
        
        if ([priceTickeStr isEqualToString:@"--"])
        {
            convertStr = @"0";
        }else
        {
            convertStr = [TKFtPriceStrHelp convertPriceWithPrice:plusFloat andPriceTicke:priceTickeStr];
        }
        if (convertStr.length < 31)
        {
            self.text = convertStr;
        }
    }
    else if(self.boardType == TKFtKeyBoardTypeDecimalPlusMinus|| self.boardType == TKFtKeyBoardTypeWarnPrice)
    {
        NSString *priceTickeStr = [self getPriceTicke];
        CGFloat priceTickeFloat = [priceTickeStr doubleValue];
        
        double tempFloat = [self.text doubleValue];
        double plusFloat = tempFloat + priceTickeFloat;
        if (plusFloat > 999999999.999999 && self.boardType == TKFtKeyBoardTypeWarnPrice) {
            return;
        }
        if (plusFloat > 9999.99 && self.boardType == TKFtKeyBoardTypeDecimalPlusMinus) {
            return;
        }
        NSString *convertStr = nil;
        if ([priceTickeStr isEqualToString:@"--"])
        {
            convertStr = @"0";
        }else
        {
            convertStr = [TKFtPriceStrHelp convertPriceWithPrice:plusFloat andPriceTicke:priceTickeStr];
        }
        if (convertStr.length < 31)
        {
            self.text = convertStr;
        }
    }
    else if(self.boardType == TKFtKeyBoardTypeParameter)
    {
        NSUInteger integer = [self.text integerValue];
        NSString *tempStr = [NSString stringWithFormat:@"%lu",integer + 1];
        if (tempStr.length < 8)
        {
            self.text = tempStr;
        }
    }else if(self.boardType == TKFtKeyBoardTypeBack)
    {
        NSString *priceTickeStr = [self getPriceTicke];
        CGFloat priceTickeFloat = [priceTickeStr doubleValue];
        
        self.attributedText = [self creteaAttributedStringWhitstring:self.text andStartIndex:0];
        NSString *traceStr = [self.text substringFromIndex:3];
        double tempFloat = [traceStr doubleValue];
        double plusFloat = tempFloat + priceTickeFloat;
        NSString *convertStr = [TKFtPriceStrHelp convertPriceWithPrice:plusFloat andPriceTicke:priceTickeStr];
        if (convertStr.length < 33)
        {
            self.text = [NSString stringWithFormat:@"回撤 %@",convertStr];
        }
        self.text = [NSString stringWithFormat:@"回撤 %@",convertStr];
        self.attributedText = [self creteaAttributedStringWhitstring:self.text andStartIndex:0];
    }else
    {
        TKLogDebug(@"------");
    }
    [self doADaptationFontWithTextString:self.text];
    if ([_ftdelegate respondsToSelector:@selector(ftTextField:andPlusOrMinusString:)])
    {
        [_ftdelegate ftTextField:self andPlusOrMinusString:self.text];
    }
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  减
 */
- (void)minusNumber
{
    _isFirstEdit = NO;
    if (self.boardType == TKFtKeyBoardTypePrice || self.boardType == TKFtKeyBoardTypeNSuperPrice || self.boardType == TKFtKeyBoardTypeCloudCondition)
    {
        NSString *priceTickeStr = [self getPriceTicke];
        CGFloat priceTickeFloat = [priceTickeStr floatValue];
        double tempFloat = 0.0;
        double tempStr = 0.0;
        if ([TKFormatHelper isChinese:self.text])
        {
            tempStr = [self getCurrentPriceValue];
        }else
        {
            tempFloat = [self.text doubleValue];
            tempStr = tempFloat - priceTickeFloat;
        }
        
        if (tempStr <= 0)
        {
            tempStr = 0;
        }
        
        if ([TKStringHelper isEmpty:priceTickeStr])
        {
            self.text = @"0";
        }else
        {
            self.text = [TKFtPriceStrHelp convertPriceWithPrice:tempStr andPriceTicke:priceTickeStr];
        }
        
        if ([_ftdelegate respondsToSelector:@selector(ftTextField:andChangeString:)])
        {
            [_ftdelegate ftTextField:self andChangeString:self.text];
        }
    }else if(self.boardType == TKFtKeyBoardTypeNumber)
    {
        NSUInteger integer = [self.text integerValue];
        if (integer == 0)
        {
            return;
        }
        self.text = [NSString stringWithFormat:@"%lu",integer - 1];
    }else if(self.boardType == TKFtKeyBoardTypeDecimal|| self.boardType == TKFtKeyBoardTypeWarnPrice)
    {
        NSString *priceTickeStr = [self getPriceTicke];
        
        CGFloat priceTickeFloat = [priceTickeStr doubleValue];
        
        double tempFloat = [self.text doubleValue];
        double plusFloat = tempFloat - priceTickeFloat;
        if (plusFloat < 0)
        {
            plusFloat = 0;
        }
        NSString *convertStr = [TKFtPriceStrHelp convertPriceWithPrice:plusFloat andPriceTicke:priceTickeStr];
        self.text = convertStr;
    }
    else if(self.boardType == TKFtKeyBoardTypeDecimalPlusMinus)
    {
        NSString *priceTickeStr = [self getPriceTicke];
        
        CGFloat priceTickeFloat = [priceTickeStr doubleValue];
        
        double tempFloat = [self.text doubleValue];
        double plusFloat = tempFloat - priceTickeFloat;
        NSString *convertStr = [TKFtPriceStrHelp convertPriceWithPrice:plusFloat andPriceTicke:priceTickeStr];
        self.text = convertStr;
    }else if(self.boardType == TKFtKeyBoardTypeParameter)
    {
        NSUInteger integer = [self.text integerValue];
        if (integer == 0)
        {
            return;
        }
        self.text = [NSString stringWithFormat:@"%lu",integer - 1];
    }else if(self.boardType == TKFtKeyBoardTypeBack)
    {
        NSString *priceTickeStr = [self getPriceTicke];
        CGFloat priceTickeFloat = [priceTickeStr doubleValue];
        
        self.attributedText = [self creteaAttributedStringWhitstring:self.text andStartIndex:0];
        NSString *traceStr = [self.text substringFromIndex:3];
        double tempFloat = [traceStr doubleValue];
        double plusFloat = tempFloat - priceTickeFloat;
        if (plusFloat < 0)
        {
            plusFloat = 0;
        }
        NSString *convertStr = [TKFtPriceStrHelp convertPriceWithPrice:plusFloat andPriceTicke:priceTickeStr];
        self.text = [NSString stringWithFormat:@"回撤 %@",convertStr];
        self.attributedText = [self creteaAttributedStringWhitstring:self.text andStartIndex:0];
        
        
    }else
    {
        TKLogDebug(@"------");
    }
    
    [self doADaptationFontWithTextString:self.text];
    
    if ([_ftdelegate respondsToSelector:@selector(ftTextField:andPlusOrMinusString:)])
    {
        [_ftdelegate ftTextField:self andPlusOrMinusString:self.text];
    }
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  清除
 */
-(void)clearValue
{
    self.text = @"";
}

/**
 选中标题
 
 @param index 标题下标
 @param titleStr 标题
 */
-(void)didSelectItemAtIndex:(NSInteger )index titleStr:(NSString *)titleStr
{
    [self toolBarHide:nil];
    
    if ([_ftdelegate respondsToSelector:@selector(ftTextField:didSelectItemAtIndex:titleStr:)])
    {
        [_ftdelegate ftTextField:self didSelectItemAtIndex:index titleStr:titleStr];
    }
}
//正负号切换
-(void)plusOrMinusChange
{
    if(self.boardType == TKFtKeyBoardTypeDecimalPlusMinus)
    {
        //判断是否有负号
        double tempFloat = [self.text doubleValue];
        if (tempFloat!=0) {
            tempFloat = -tempFloat;
        }
        else return;
        
        NSString *priceTickeStr = [self getPriceTicke];
        NSString *convertStr = [TKFtPriceStrHelp convertPriceWithPrice:tempFloat andPriceTicke:priceTickeStr];
        self.text = convertStr;
        
        [self doADaptationFontWithTextString:self.text];
        
        if ([_ftdelegate respondsToSelector:@selector(ftTextField:andPlusOrMinusString:)])
        {
            [_ftdelegate ftTextField:self andPlusOrMinusString:self.text];
        }
    }
}

#pragma mark - public

-(double)getCurrentPriceValue
{
    NSString *priceTickeStr = [self getPriceTicke];

    double lastPrice = ([TKFtEnvHelp shareInstance].ftCounter == FT_COUNTER_HS)?_hsmarketBean.futu_last_price:_marketBean.LastPrice;
    if (_hsmarketBean == nil&&_marketBean) {
        lastPrice = _marketBean.LastPrice;
    }
    if (_hsmarketBean&&_marketBean == nil) {
        lastPrice = _hsmarketBean.futu_last_price;
    }
    
    NSString *longPrice = [TKFtPriceStrHelp convertPriceWithPrice:lastPrice andPriceTicke:priceTickeStr];
    return [longPrice doubleValue];
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  获取超价点位
 */
-(NSString *)getSuperPrice
{
    if ([TKFtEnvHelp shareInstance].ftCounter == FT_COUNTER_HS) {
        return _hsinstrumentBean.product_super_price;
    }else{
        return _instrumentBean.ProductSuperPrice;
    }
    
}


/**
 *  @author yyf, 17-04
 *
 *  @brief  获取最小变动价位
 */
-(NSString *)getPriceTicke
{
    if ([TKFtEnvHelp shareInstance].ftCounter == FT_COUNTER_HS) {
        return _hsinstrumentBean.futu_price_step;
    }else{
        return _instrumentBean.PriceTick;
    }
}


/**
 *  @author yyf, 16-11
 *
 *  @brief  更新字符串颜色
 *
 *  param   要更新的字符串
 *  param   开始下标
 *  param   长度
 */
-(NSMutableAttributedString *)creteaAttributedStringWhitstring:(NSString *)string andStartIndex:(NSInteger)startIndex
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    NSDictionary *attrDict = @{NSForegroundColorAttributeName:[[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftLightTextColor"].textColor};
    [attributedString beginEditing];
    [attributedString setAttributes:attrDict range:NSMakeRange(0, 2)];
    [attributedString endEditing];
    return attributedString;
}

#pragma matk - CTP

/**
 *  @author yyf, 17-04
 *
 *  @brief  刷新  ToolBar可开数
 *
 *  @param  marketBean
 *  @param  capitalBean
 */
-(void)doFreshToolBarWithMarketBean:(TKFtmarketBean *)marketBean andCapitalBean:(TKFtCapitalBean *)capitalBean InstrumentBean:(TKFtInstrumentBean *)instrumentBean andFormName:(NSString *)formName
{
    _marketBean = marketBean;
    NSString *instrumentID = marketBean.InstrumentID;
    _instrumentBean = instrumentBean;
    
    if (!_marketBean)
    {
        _marketBean = marketBean;
        _toolBar.contentString = [NSString stringWithFormat:@"最大可开数：%@",@"--"];
        return;
    }
    
    NSString *Available = [NSString stringWithFormat:@"%f",capitalBean.Available];
    NSString *LastPrice = [NSString stringWithFormat:@"%f",marketBean.LastPrice];
    NSString *preInstrumentID = [_longmarDict getStringWithKey:@"InstrumentID"];
    if ([preInstrumentID isEqualToString:instrumentID])
    {
        //        NSString *longmarginratio =[_longmarDict getStringWithKey:@"LongMarginRatioByMoney"];
        NSString *canOPenStr = [TKFtStringHelp calculateCanOpenWithAvailableFund:Available withLatestPrice:LastPrice withInstrumentID:instrumentID withLongMarginatio:_longmarDict withOpenRadio:_openMarDict];
        _toolBar.contentString = [NSString stringWithFormat:@"最大可开数：%@",canOPenStr];
    }else
    {
        _toolBar.contentString = @"最大可开数：计算中...";
        __block NSInteger requestCount = 0;
        
        dispatch_block_t finshBlock = ^{
            if (requestCount == 2) {
                //                NSString *longmarginratio = [_longmarDict getStringWithKey:@"LongMarginRatioByMoney"];
                NSString *canOPenStr = [TKFtStringHelp calculateCanOpenWithAvailableFund:Available withLatestPrice:LastPrice withInstrumentID:instrumentID withLongMarginatio:_longmarDict withOpenRadio:_openMarDict];
                _toolBar.contentString = [NSString stringWithFormat:@"最大可开数：%@",canOPenStr];
            }
        };
        
        [self queryMarginRatioWithInstrumentID:instrumentID completion:^{
            requestCount ++;
            finshBlock();
        }];
        
        
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"InstrumentID"] = instrumentID;
        if ([instrumentBean.ProductClass isEqualToString:@"2"]||
            [instrumentBean.ProductClass isEqualToString:@"6"]) {
            params[@"funcNo"] = @"10048";
        }else{
            params[@"funcNo"] = @"10028";
        }
        [self queryCommissionWithInstrumentParas:params completion:^{
            requestCount ++;
            finshBlock();
        }];
    }
}
//1 请求保证金
-(void)queryMarginRatioWithInstrumentID:(NSString *)instrumentID completion:(void(^)(void))completion
{
    [self.service queryMarginRatioWithInstrumentID:instrumentID CallBackFunc:^(ResultVo *resultVo) {
        if (resultVo.errorNo == 0)
        {
            NSArray *resultArray  = (NSArray *)resultVo.results;
            _longmarDict = [resultArray lastObject];
            completion?completion():nil;
        }else if (resultVo.errorNo == -10003)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self queryMarginRatioWithInstrumentID:instrumentID completion:completion];
            });
        }else if (resultVo.errorNo == -90)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self queryMarginRatioWithInstrumentID:instrumentID completion:completion];
            });
        }
        else{
            _longmarDict = nil;
            completion?completion():nil;
        }
        
    }];
}

//2. 开仓手续费
-(void)queryCommissionWithInstrumentParas:(NSDictionary *)params completion:(void(^)(void))completion
{
    [self.service queryCommissionWithInstrumentParas:params CallBackFunc:^(ResultVo *resultVo) {
        //每秒发送请求数超过许可数
        if (resultVo.errorNo == 0){
            NSArray *resultArray  = (NSArray *)resultVo.results;
            _openMarDict = [resultArray lastObject];
            completion?completion():nil;
        }else if (resultVo.errorNo == -10003)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self queryCommissionWithInstrumentParas:params completion:completion];
            });
        }else if (resultVo.errorNo == -90)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self queryCommissionWithInstrumentParas:params completion:completion];
            });
        }
        else{
            _openMarDict = nil;
            completion?completion():nil;
        }
    }];
}


-(void)doFreshToolBarWithInstrumentBean:(TKFtInstrumentBean *)instrumentBean MarketBean:(TKFtmarketBean *)marketBean andFormName:(NSString *)formName
{
    _marketBean = marketBean;
    _instrumentBean = instrumentBean;
    NSString *PriceTick = instrumentBean.PriceTick;
    NSString *contentString = nil;
    if ([formName isEqualToString:@"entrust"] || [formName isEqualToString:@"contion"])
    {
        if ([TKStringHelper isEmpty:PriceTick])
        {
            if (TKFT_SCREEN_WIDTH > 325)
            {
                contentString = @"最小变动价位--，涨停--，跌停--";
            }else
            {
                contentString = @"最小变动价位--，涨停--，跌停--";
            }
            
            
        }else
        {
            NSString *upperLimitPrice = [TKFtPriceStrHelp convertPriceWithPrice:_marketBean.UpperLimitPrice andPriceTicke:instrumentBean.PriceTick];
            NSString *lowerLimitPrice = [TKFtPriceStrHelp convertPriceWithPrice:_marketBean.LowerLimitPrice andPriceTicke:instrumentBean.PriceTick];
            if (TKFT_SCREEN_WIDTH > 325)
            {
                contentString = [NSString stringWithFormat:@"最小变动价位%@，涨停%@，跌停%@",PriceTick,upperLimitPrice,lowerLimitPrice];
            }else
            {
                contentString = [NSString stringWithFormat:@"最小变动价位%@，涨停%@，跌停%@",PriceTick,upperLimitPrice,lowerLimitPrice];
            }
        }
        
    }else
    {
        if ([TKStringHelper isEmpty:PriceTick])
        {
            contentString = @"最小变动价位--";
        }else
        {
            contentString = [NSString stringWithFormat:@"最小变动价位%@",PriceTick];
        }
    }
    _toolBar.contentString = contentString;
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  刷新止盈止损最小变动价位
 *
 *  @param  刷新串
 */
-(void)doFreshToolBarWithShowString:(NSString *)showString
{
    _toolBar.contentString = showString;
    //重新输入
    _isFirstEdit = YES;
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  刷新止盈止损可平数
 *
 *  @param  刷新串
 */
-(void)doFreshToolBarWithcanFlatStr:(NSString *)canFlatStr
{
    _toolBar.contentString = canFlatStr;
    //重新输入
    _isFirstEdit = YES;
}

/**
 * 重新输入
 */
-(void)doFreshFirstEdit{

    _isFirstEdit = YES;
}


/**
 刷新自选股键盘
 
 @param stringArray 字符数组
 @param instrumentName 当前界面显示合约名称
 */
-(void)doFreshChooseKeyBoardWithStringArray:(NSMutableArray *)stringArray instrumentName:(NSString *)instrumentName
{
    [self.chooseKeyBoard freshChooseView:stringArray instrumentName:instrumentName];
}

/**
 * @Author 刘鹏民, 15-03-31 11:03:29
 *
 * @brief  获取光标位置
 */
- (NSRange)selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}

/**
 * @Author 刘鹏民, 15-03-31 11:03:42
 *
 * @brief  设置光标位置
 */
- (void)setSelectedRange:(NSRange) range
{
    UITextPosition* beginning = self.beginningOfDocument;
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:startPosition offset:range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

/**
 *  @author 刘宝, 2016-05-19 12:05:34
 *  处理copy动作
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (!_enableCopy && action == @selector(paste:)){
        return NO;
    }else if (!_enableSelectAll && action == @selector(select:)){
        return NO;
    }else if (!_enableChoose && action == @selector(selectAll:)){
        return NO;
    }else{
        return [super canPerformAction:action withSender:sender];
    }
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"text" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 *  @author yyf, 17-04
 *
 *  @brief  动态计算字体大小
 *
 *  @param  输入框字体
 */
-(void)doADaptationFontWithTextString:(NSString *)textString
{
    NSString *tempStr = self.text;
    for (NSInteger i = 18; i > 0; i--)
    {
        CGFloat tempWidth  =[tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont ftk750AdaptationFont:i]}].width;
        if (tempWidth <= self.width)
        {
            self.font = [UIFont ftk750AdaptationFont:i];
            break;
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"text"] && object == self) {
        [self doADaptationFontWithTextString:self.text];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



#pragma mark - Hs

-(void)doHsFreshToolBarWithMarketBean:(TKFtHsmarketBean *)marketBean andCapitalBean:(TKFtHsCapitalBean *)capitalBean InstrumentBean:(TKFtHsInstrumentBean *)instrumentBean andFormName:(NSString *)formName
{
    self.formName = formName;
    _hsmarketBean = marketBean;
    _hsinstrumentBean = instrumentBean;
  
    //取消计算期权最大可开数的限制 || ![_instrumentBean.ProductClass isEqualToString:@"1"]
    if (!_hsmarketBean)
    {
        _toolBar.contentString = [NSString stringWithFormat:@"最大可开数：%@",@"--"];
        return;
    }
    NSString *Available = [NSString stringWithFormat:@"%f",capitalBean.enable_balance];
    NSString *LastPrice = [NSString stringWithFormat:@"%f",marketBean.futu_last_price];
    NSString *InstrumentID = marketBean.futu_code;
    NSString *preInstrumentID = [_longmarDict getStringWithKey:@"InstrumentID"];
    if ([preInstrumentID isEqualToString:InstrumentID]) {
        NSString *canOPenStr = [TKFtStringHelp calculateHSCanOpenWithAvailableFund:Available withLatestPrice:LastPrice withInstrumentID:InstrumentID withLongMarginatio:_longmarDict withOpenRadio:_openMarDict];
        _toolBar.contentString = [NSString stringWithFormat:@"最大可开数：%@",canOPenStr];
    }else{
        _toolBar.contentString = @"最大可开数：计算中...";
        __block NSInteger requestCount = 0;
        
        dispatch_block_t finshBlock = ^{
            if (requestCount == 2) {
                // NSString *longmarginratio = [_longmarDict getStringWithKey:@"LongMarginRatioByMoney"];
                NSString *canOPenStr = [TKFtStringHelp calculateHSCanOpenWithAvailableFund:Available withLatestPrice:LastPrice withInstrumentID:InstrumentID withLongMarginatio:_longmarDict withOpenRadio:_openMarDict];
                _toolBar.contentString = [NSString stringWithFormat:@"最大可开数：%@",canOPenStr];
            }
        };
        NSMutableDictionary *params = @{}.mutableCopy;
        NSString *InstrumentID = instrumentBean.futu_code;
        params[@"futucode_type"] = instrumentBean.futucode_type;
        params[@"futu_code"] = InstrumentID;
        params[@"entrust_bs"] = @"1";
        params[@"futu_product_type"] = instrumentBean.futu_product_type;
        [self.hsService queryMarginRatioWithInstrumentParas:params callBackFunc:^(ResultVo *resultVo) {
            if (resultVo.errorNo == 0)
            {
                NSArray *resultArray  = (NSArray *)resultVo.results;
                if (resultArray.count) {
                    _longmarDict = [resultArray firstObject];
                }else{
                    _longmarDict = nil;
                }
            }else{
                _longmarDict = nil;
                NSString *error_info = resultVo.errorInfo;
                if (_ftdelegate && [_ftdelegate respondsToSelector:@selector(ftTextField:failInfo:)]) {
                    [_ftdelegate ftTextField:self failInfo:error_info];
                }
            }
            requestCount ++;
            finshBlock();
        }];
        
        NSMutableDictionary *params2 = @{}.mutableCopy;
        params2[@"futucode_type"] = instrumentBean.futucode_type;
        params2[@"futu_code"] = InstrumentID;
        params[@"futu_product_type"] = instrumentBean.futu_product_type;
        
        [self.hsService queryCommissionWithInstrumentParas:params2 callBackFunc:^(ResultVo *resultVo) {
            if (resultVo.errorNo == 0)
            {
                NSArray *resultArray  = (NSArray *)resultVo.results;
                if (resultArray.count) {
                    _openMarDict = [resultArray firstObject];
                }else{
                    _openMarDict = nil;
                }
            }else{
                _openMarDict = nil;
                NSString *error_info = resultVo.errorInfo;
                if (_ftdelegate && [_ftdelegate respondsToSelector:@selector(ftTextField:failInfo:)]) {
                    [_ftdelegate ftTextField:self failInfo:error_info];
                }
            }
            requestCount ++;
            finshBlock();
        }];
    }
   
}

-(void)doHsFreshToolBarWithMarketBean:(TKFtHsmarketBean *)marketBean andCapitalBean:(TKFtHsCapitalBean *)capitalBean InstrumentBean:(TKFtHsInstrumentBean *)instrumentBean completion:(void(^)(NSString *canOpenStr))completion
{
    _hsmarketBean = marketBean;
    _hsinstrumentBean = instrumentBean;
    
    //取消计算期权最大可开数的限制 || ![_instrumentBean.ProductClass isEqualToString:@"1"]
    if (!_hsmarketBean)
    {
         completion?completion(@"--"):nil;
    }
    NSString *Available = [NSString stringWithFormat:@"%f",capitalBean.enable_balance];
    NSString *LastPrice = [NSString stringWithFormat:@"%f",marketBean.futu_last_price];
    NSString *InstrumentID = marketBean.futu_code;
    NSString *preInstrumentID = [_longmarDict getStringWithKey:@"InstrumentID"];
    if ([preInstrumentID isEqualToString:InstrumentID]) {
        NSString *canOpenStr = [TKFtStringHelp calculateHSCanOpenWithAvailableFund:Available withLatestPrice:LastPrice withInstrumentID:InstrumentID withLongMarginatio:_longmarDict withOpenRadio:_openMarDict];
        completion?completion(canOpenStr):nil;
    }else{
        _toolBar.contentString = @"最大可开数：计算中...";
        __block NSInteger requestCount = 0;
        
        dispatch_block_t finshBlock = ^{
            if (requestCount == 2) {
                NSString *canOpenStr = [TKFtStringHelp calculateHSCanOpenWithAvailableFund:Available withLatestPrice:LastPrice withInstrumentID:InstrumentID withLongMarginatio:_longmarDict withOpenRadio:_openMarDict];
                completion?completion(canOpenStr):nil;
            }
        };
        NSMutableDictionary *params = @{}.mutableCopy;
        NSString *InstrumentID = instrumentBean.futu_code;
        params[@"futucode_type"] = instrumentBean.futucode_type;
        params[@"futu_code"] = InstrumentID;
        params[@"entrust_bs"] = @"1";
        params[@"futu_product_type"] = instrumentBean.futu_product_type;
        [self.hsService queryMarginRatioWithInstrumentParas:params callBackFunc:^(ResultVo *resultVo) {
            if (resultVo.errorNo == 0)
            {
                NSArray *resultArray  = (NSArray *)resultVo.results;
                if (resultArray.count) {
                    _longmarDict = [resultArray firstObject];
                }else{
                    _longmarDict = nil;
                }
            }else{
                _longmarDict = nil;
                NSString *error_info = resultVo.errorInfo;
                if (_ftdelegate && [_ftdelegate respondsToSelector:@selector(ftTextField:failInfo:)]) {
                    [_ftdelegate ftTextField:self failInfo:error_info];
                }
            }
            requestCount ++;
            finshBlock();
        }];
        
        NSMutableDictionary *params2 = @{}.mutableCopy;
        params2[@"futucode_type"] = instrumentBean.futucode_type;
        params2[@"futu_code"] = InstrumentID;
        params[@"futu_product_type"] = instrumentBean.futu_product_type;
        
        [self.hsService queryCommissionWithInstrumentParas:params2 callBackFunc:^(ResultVo *resultVo) {
            if (resultVo.errorNo == 0)
            {
                NSArray *resultArray  = (NSArray *)resultVo.results;
                if (resultArray.count) {
                    _openMarDict = [resultArray firstObject];
                }else{
                    _openMarDict = nil;
                }
            }else{
                _openMarDict = nil;
                NSString *error_info = resultVo.errorInfo;
                if (_ftdelegate && [_ftdelegate respondsToSelector:@selector(ftTextField:failInfo:)]) {
                    [_ftdelegate ftTextField:self failInfo:error_info];
                }
            }
            requestCount ++;
            finshBlock();
        }];
    }
    
}

-(void)doHsFreshToolBarWithInstrumentBean:(TKFtHsInstrumentBean *)instrumentBean MarketBean:(TKFtHsmarketBean *)marketBean andFormName:(NSString *)formName
{
    self.formName = formName;
    _hsinstrumentBean = instrumentBean;
    _hsmarketBean = marketBean;
    NSString *priceTick = instrumentBean.futu_price_step;
    NSString *contentString = nil;
    if ([formName isEqualToString:@"entrust"])
    {
        if ([TKStringHelper isEmpty:priceTick])
        {
            contentString = @"最小变动价位--，涨停--，跌停--";
        }else
        {
            NSString *upperLimitPrice = [TKFtPriceStrHelp convertPriceWithPrice:marketBean.uplimited_price andPriceTicke:instrumentBean.futu_price_step];
            NSString *lowerLimitPrice = [TKFtPriceStrHelp convertPriceWithPrice:marketBean.downlimited_price andPriceTicke:instrumentBean.futu_price_step];
            contentString = [NSString stringWithFormat:@"最小变动价位%@，涨停%@，跌停%@",priceTick,upperLimitPrice,lowerLimitPrice];
        }
        
    }else
    {
        if ([TKStringHelper isEmpty:priceTick])
        {
            contentString = @"最小变动价位--";
        }else
        {
            contentString = [NSString stringWithFormat:@"最小变动价位%@",priceTick];
        }
    }
    _toolBar.contentString = contentString;
}
//云条件单
-(void)doFreshToolBarWithMarketBean:(TKFtHsmarketBean *)marketBean andCapitalBean:(TKFtCapitalBean *)capitalBean InstrumentBean:(TKFtHsInstrumentBean *)instrumentBean completion:(void(^)(NSString *canOpenStr))completion
{
    _hsmarketBean = marketBean;
    _hsinstrumentBean = instrumentBean;
    
    //取消计算期权最大可开数的限制 || ![_instrumentBean.ProductClass isEqualToString:@"1"]
    if (!_hsmarketBean)
    {
        completion?completion(@"--"):nil;
    }
    NSString *Available = [NSString stringWithFormat:@"%f",capitalBean.Available];
    NSString *LastPrice = [NSString stringWithFormat:@"%f",marketBean.futu_last_price];
    NSString *InstrumentID = marketBean.futu_code;
    NSString *preInstrumentID = [_longmarDict getStringWithKey:@"InstrumentID"];
    if ([preInstrumentID isEqualToString:InstrumentID]) {
        NSString *canOpenStr = [TKFtStringHelp calculateCanOpenWithAvailableFund:Available withLatestPrice:LastPrice withInstrumentID:InstrumentID withLongMarginatio:_longmarDict withOpenRadio:_openMarDict];
        completion?completion(canOpenStr):nil;
    }else{
        _toolBar.contentString = @"最大可开数：计算中...";
        __block NSInteger requestCount = 0;
        
        dispatch_block_t finshBlock = ^{
            if (requestCount == 2) {
                NSString *canOpenStr = [TKFtStringHelp calculateCanOpenWithAvailableFund:Available withLatestPrice:LastPrice withInstrumentID:InstrumentID withLongMarginatio:_longmarDict withOpenRadio:_openMarDict];
                completion?completion(canOpenStr):nil;
            }
        };
        [self queryMarginRatioWithInstrumentID:InstrumentID completion:^{
            requestCount ++;
            finshBlock();
        }];
        
        
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"InstrumentID"] = InstrumentID;
        if ([instrumentBean.futu_product_type isEqualToString:@"2"]||
            [instrumentBean.futu_product_type isEqualToString:@"6"]) {
            params[@"funcNo"] = @"10048";
        }else{
            params[@"funcNo"] = @"10028";
        }
        [self queryCommissionWithInstrumentParas:params completion:^{
            requestCount ++;
            finshBlock();
        }];
    }
    
}
@end

