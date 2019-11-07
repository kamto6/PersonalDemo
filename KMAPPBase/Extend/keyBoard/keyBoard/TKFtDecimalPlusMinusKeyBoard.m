//
//  TKFtDecimalPlusMinusKeyBoard.m
//  TKApp
//
//  Created by 陈智坤 on 2019/1/3.
//  Copyright © 2019 Pengxuyuan. All rights reserved.
//

#import "TKFtDecimalPlusMinusKeyBoard.h"
#define HLKEYBOARD_HEIGHT ft750AdaptationWidth(215)
@implementation TKFtDecimalPlusMinusKeyBoard

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [TKUIHelper colorWithHexString:@"#DDDDDD"];
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    NSArray *BtnTitles = @[@"7",@"8",@"9",@"4",@"5",@"6",@"1",@"2",@"3",];
    
    int rowCount = 4;
    float distanse = ft750AdaptationWidth(1);
    float btnHeight = 40;//ft750AdaptationWidth(45);
    float btnWidth = (TKFT_SCREEN_WIDTH-5*distanse)/rowCount;
    
    for (int i=0; i<9; i++) {
        
        float kx;
        float ky;
        kx = distanse+i%(rowCount - 1)*(distanse + btnWidth);
        ky = i/(rowCount - 1)*(distanse +btnHeight);
        UIButton *keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [keyBoardBtn setFrame:CGRectMake(kx, ky, btnWidth, btnHeight)];
        keyBoardBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#FFFFFF"];
        [keyBoardBtn setTitleColor:[TKUIHelper colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        [keyBoardBtn setTitle:BtnTitles[i] forState:UIControlStateNormal];
        keyBoardBtn.titleLabel.font = [UIFont ftk750AdaptationFont:24];
        [keyBoardBtn addTarget:self action:@selector(keyBoardInputAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:keyBoardBtn];
    }
    
    CGFloat deleteBtnX = btnWidth * 3 + distanse *4;
    CGFloat deleteBtnY = 0;
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setFrame:CGRectMake(deleteBtnX, deleteBtnY, btnWidth, btnHeight)];
    NSString *imageNameStr = [NSString stringWithFormat:@"TKFtSDK.bundle/%@",@"keyboard_delete"];
    [deleteBtn setImage:[UIImage imageNamed:imageNameStr] forState:UIControlStateNormal];
    deleteBtn.adjustsImageWhenHighlighted = NO;
    [deleteBtn setFrame:CGRectMake(deleteBtnX, deleteBtnY, btnWidth, btnHeight)];
    deleteBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#F2F2F2"];
    [deleteBtn addTarget:self action:@selector(doDeleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    
    CGFloat plusBtnX = btnWidth * 3 + distanse *4;
    CGFloat plusBtnY = CGRectGetMaxY(deleteBtn.frame) + distanse;
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setFrame:CGRectMake(plusBtnX, plusBtnY, btnWidth, btnHeight)];
    NSString *imagePlusStr = [NSString stringWithFormat:@"TKFtSDK.bundle/%@",@"keyboard_plus"];
    [plusBtn setImage:[UIImage imageNamed:imagePlusStr] forState:UIControlStateNormal];
    plusBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#F2F2F2"];
    [plusBtn addTarget:self action:@selector(doPlusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    plusBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:plusBtn];
    
    CGFloat minusBtnX = btnWidth * 3 + distanse *4;
    CGFloat minusBtnY = CGRectGetMaxY(plusBtn.frame) + distanse;
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusBtn setFrame:CGRectMake(minusBtnX, minusBtnY, btnWidth, btnHeight)];
    minusBtn.adjustsImageWhenHighlighted = NO;
    NSString *imageMinusStr = [NSString stringWithFormat:@"TKFtSDK.bundle/%@",@"keyboard_minus"];
    [minusBtn setImage:[UIImage imageNamed:imageMinusStr] forState:UIControlStateNormal];
    minusBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#F2F2F2"];
    [minusBtn addTarget:self action:@selector(doMinusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:minusBtn];
    
    CGFloat decimalBtnX = distanse;
    CGFloat decimalBtnY = 3 * btnHeight + 3 * distanse;
    UIButton *decimalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [decimalBtn setFrame:CGRectMake(decimalBtnX, decimalBtnY, btnWidth, btnHeight)];
    decimalBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#FFFFFF"];
    [decimalBtn setTitle:@"." forState:UIControlStateNormal];
    [decimalBtn setTitleColor:[TKUIHelper colorWithHexString:@"#000000"] forState:UIControlStateNormal];
    decimalBtn.titleLabel.font = [UIFont ftk750AdaptationFont:24];
    [decimalBtn addTarget:self action:@selector(doZeroButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:decimalBtn];
    
    CGFloat zeroBtnX = btnWidth + 2*distanse;
    CGFloat zeroBtnY = 3 * btnHeight + 3 * distanse;
    UIButton *zeroBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zeroBtn setFrame:CGRectMake(zeroBtnX, zeroBtnY, btnWidth, btnHeight)];
    zeroBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#FFFFFF"];
    [zeroBtn setTitle:@"0" forState:UIControlStateNormal];
    [zeroBtn setTitleColor:[TKUIHelper colorWithHexString:@"#000000"] forState:UIControlStateNormal];
    zeroBtn.titleLabel.font = [UIFont ftk750AdaptationFont:24];
    [zeroBtn addTarget:self action:@selector(doZeroButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:zeroBtn];
    
    //正负切换按钮
    CGFloat plusOrMinusBtnX = CGRectGetMaxX(zeroBtn.frame) + distanse;
    CGFloat plusOrMinusBtnY = CGRectGetMaxY(minusBtn.frame) + distanse;
    UIButton *plusOrMinusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusOrMinusBtn setFrame:CGRectMake(plusOrMinusBtnX, plusOrMinusBtnY, btnWidth*2, btnHeight)];
    NSString *imagePlusOrMinusStr = [NSString stringWithFormat:@"TKFtSDK.bundle/%@",@"keyboard_plusOrMinus"];
    [plusOrMinusBtn setImage:[UIImage imageNamed:imagePlusOrMinusStr] forState:UIControlStateNormal];
    plusOrMinusBtn.backgroundColor = [TKUIHelper colorWithHexString:@"#F2F2F2"];
    [plusOrMinusBtn addTarget:self action:@selector(doPlusOrMinusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    plusOrMinusBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:plusOrMinusBtn];
    
}
-(void)doPlusOrMinusButtonAction:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(plusOrMinusChange)])
    {
        [self.delegate plusOrMinusChange];
    }
}
/**
 *  @author yyf, 16-11
 *
 *  @brief  输入数字
 *
 */
-(void)keyBoardInputAction:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(appendChar:)])
    {
        [self.delegate appendChar:button.currentTitle];
    }
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  加号
 *
 */
-(void)doPlusButtonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(plusNumber)])
    {
        [_delegate plusNumber];
    }
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  减号
 *
 */
-(void)doMinusButtonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(minusNumber)])
    {
        [_delegate minusNumber];
    }
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  0按钮
 *
 */
-(void)doZeroButtonAction:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(appendChar:)])
    {
        [self.delegate appendChar:button.currentTitle];
    }
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  回删
 */
-(void)doDeleteButtonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(deleteChar)])
    {
        [_delegate deleteChar];
    }
}

@end
