//
//  TKFuturesTradeBarKeyBoard.m
//  testKeyBoard
//
//  Created by thinkive on 2017/2/26.
//  Copyright © 2017年 com.thinkive.www. All rights reserved.
//

#import "TKFtNSuperPriceKeyBoard.h"

@interface TKFtNSuperPriceKeyBoard ()

@property (nonatomic, assign)  NSRange range;
@property (nonatomic, assign)  NSInteger num;
@property (nonatomic, assign)  double priceTick;

@end


@implementation TKFtNSuperPriceKeyBoard

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [TKUIHelper colorWithHexString:@"DDDDDD"];
        [self setupView];
    }
    return self;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  初始化子控件
 *
 */
-(void)setupView
{
    NSArray *numberBtnTitles = @[@"7",@"8",@"9",@"4",@"5",@"6",@"1",@"2",@"3",@".",@"0",@""];
    NSArray *priceBtnTitles = @[@"排队价",@"对手价",@"市价",@"最新价"];
    
    int rowCount = 4;
    float distanse = ft750AdaptationWidth(1);
    float btnWidth = (TKFT_SCREEN_WIDTH-5*distanse)/rowCount;
    float priceBackViewH = 40;//ft750AdaptationWidth(40);
    float priceBtnWidth = (TKFT_SCREEN_WIDTH - distanse * 5)/4;
    
    UIView *priceBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TKFT_SCREEN_WIDTH, priceBackViewH)];
    priceBackView.backgroundColor = [TKUIHelper colorWithHexString:@"#DDDDDD"];
    [self addSubview:priceBackView];
    
    for (NSInteger i = 0; i < priceBtnTitles.count; i++)
    {
        float priceTitleBtnX = distanse + i * (priceBtnWidth + distanse) ;
        UIButton *priceTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [priceTitleBtn setFrame:CGRectMake(priceTitleBtnX, 0, priceBtnWidth, priceBackViewH)];
        [priceTitleBtn setTitleColor:[TKUIHelper colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        priceTitleBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#EDEDED"];
        priceTitleBtn.titleLabel.font = [UIFont ftk750AdaptationFont:18];
        [priceTitleBtn setTitle:priceBtnTitles[i] forState:UIControlStateNormal];
        [priceTitleBtn addTarget:self action:@selector(priceTitleInputAction:) forControlEvents:UIControlEventTouchUpInside];
        [priceBackView addSubview:priceTitleBtn];
    }
    
    float btnHeight = 40;//ft750AdaptationWidth(40);
    CGFloat YY = CGRectGetMaxY(priceBackView.frame) + distanse;
    for (int i=0; i<numberBtnTitles.count; i++) {
        
        float keyBoardBtnX ;
        float keyBoardBtnY ;
        keyBoardBtnX = distanse+i%(rowCount - 1)*(distanse + btnWidth);
        keyBoardBtnY = YY + i/(rowCount - 1)*(distanse +btnHeight);
        
        UIButton *keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [keyBoardBtn setFrame:CGRectMake(keyBoardBtnX, keyBoardBtnY, btnWidth, btnHeight)];
        if (i == numberBtnTitles.count - 1)
        {
            NSString *imageNameStr = [NSString stringWithFormat:@"TKFtSDK.bundle/%@",@"keyboard_delete"];
            [keyBoardBtn setImage:[UIImage imageNamed:imageNameStr] forState:UIControlStateNormal];
            keyBoardBtn.adjustsImageWhenHighlighted = NO;
            keyBoardBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#F2F2F2"];
            keyBoardBtn.tag = 100;
        }else if([numberBtnTitles[i] isEqualToString:@"."])
        {
            keyBoardBtn.contentEdgeInsets = UIEdgeInsetsMake(-18, 0, 0, 0);
            keyBoardBtn.titleLabel.font = [UIFont ftk750AdaptationFont:36];;
            [keyBoardBtn setTitle:numberBtnTitles[i] forState:UIControlStateNormal];
            keyBoardBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#F2F2F2"];
            [keyBoardBtn setTitleColor:[TKUIHelper colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        }else{
            keyBoardBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#FFFFFF"];
            [keyBoardBtn setTitleColor:[TKUIHelper colorWithHexString:@"#000000"] forState:UIControlStateNormal];
            keyBoardBtn.titleLabel.font = [UIFont ftk750AdaptationFont:24];;
            [keyBoardBtn setTitle:numberBtnTitles[i] forState:UIControlStateNormal];
        }
        
        [keyBoardBtn addTarget:self action:@selector(keyBoardInputAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:keyBoardBtn];
    }
    
    CGFloat plusBtnX = btnWidth * 3 + distanse *4;
    CGFloat plusBtnY = YY;
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setFrame:CGRectMake(plusBtnX, plusBtnY, btnWidth, 2*btnHeight + distanse)];
    plusBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#F2F2F2"];
    NSString *imagePlusStr = [NSString stringWithFormat:@"TKFtSDK.bundle/%@",@"keyboard_plus"];
    [plusBtn setImage:[UIImage imageNamed:imagePlusStr] forState:UIControlStateNormal];
    plusBtn.adjustsImageWhenHighlighted = NO;
    [plusBtn addTarget:self action:@selector(doPlusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusBtn];
    
    CGFloat minusBtnX = btnWidth * 3 + distanse *4;
    CGFloat minusBtnY = CGRectGetMaxY(plusBtn.frame) + distanse;
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusBtn setFrame:CGRectMake(minusBtnX, minusBtnY, btnWidth, 2*btnHeight + distanse)];
    minusBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#F2F2F2"];
    NSString *imageMinusStr = [NSString stringWithFormat:@"TKFtSDK.bundle/%@",@"keyboard_minus"];
    [minusBtn setImage:[UIImage imageNamed:imageMinusStr] forState:UIControlStateNormal];
    minusBtn.adjustsImageWhenHighlighted = NO;
    [minusBtn addTarget:self action:@selector(doMinusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:minusBtn];
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  数组输入
 */
-(void)keyBoardInputAction:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"."])
    {
        //小数点
        if([self.delegate respondsToSelector:@selector(appendChar:)]){
            [self.delegate appendChar:button.currentTitle];
        }
    }else if (button.tag == 100)
    {
        //回删
        if([self.delegate respondsToSelector:@selector(deleteChar)]){
            [self.delegate deleteChar];
        }
    }else
    {
        //输入数组
        if([self.delegate respondsToSelector:@selector(appendChar:)]){
            [self.delegate appendChar:button.currentTitle];
        }
    }
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  加号按钮
 */
-(void)doPlusButtonAction:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(plusNumber)]){
        [self.delegate plusNumber];
    }
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  减号按钮
 */
-(void)doMinusButtonAction:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(minusNumber)]){
        [self.delegate minusNumber];
    }
}


/**
 *  @author yyf, 16-11
 *
 *  @brief  标题输入
 */
-(void)priceTitleInputAction:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(appendChar:)]){
        [self.delegate appendChar:button.currentTitle];
    }
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  隐藏键盘
 */
- (void)hidden
{
    [self.intPutLabel resignFirstResponder];
}


@end

