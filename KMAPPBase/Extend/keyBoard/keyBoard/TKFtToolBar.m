//
//  YYView.m
//  testKeyBoard
//
//  Created by thinkive on 2017/2/26.
//  Copyright © 2017年 com.thinkive.www. All rights reserved.
//

#import "TKFtToolBar.h"

@interface TKFtToolBar ()

@property (nonatomic,strong) UILabel *titleLabel;//标题内容
@property (nonatomic,strong) UIButton *hideButton;//隐藏按钮
@property (nonatomic,strong) UIView *topRule;//顶部分割线
@property (nonatomic,strong) UIView *bottomRule;//底部分割线
@property (nonatomic,strong) UIButton *bigHideButton;
@end

@implementation TKFtToolBar


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self stupView];
    }
    return self;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  初始化
 */
-(void)stupView
{
    self.backgroundColor = [TKUIHelper colorWithHexString:@"#DDDDDD"];
    [self addSubview:self.titleLabel];
    [self addSubview:self.hideButton];
    [self addSubview:self.topRule];
    [self addSubview:self.bottomRule];
    [self addSubview:self.bigHideButton];
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  标题内容标签
 *
 */
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = CGRectMake(ft750AdaptationWidth(10), 0, self.frame.size.width -60, self.frame.size.height);
        _titleLabel.font = [UIFont ftk750AdaptationFont:14];;
        _titleLabel.textColor = [TKUIHelper colorWithHexString:@"#000000"];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  隐藏按钮
 *
 */
-(UIButton *)hideButton
{
    if (!_hideButton) {
        _hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hideButton.frame = CGRectMake(TKFT_SCREEN_WIDTH -37, 0, 22, 22);
        _hideButton.centerY = self.height/2;
        NSString *imageNameStr = TKFtGetBundleImageName(@"keyboard_hide");
        [_hideButton setImage:[UIImage imageNamed:imageNameStr] forState:UIControlStateNormal];
        [_hideButton addTarget:self action:@selector(doHideBoard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideButton;
}
- (UIButton *)bigHideButton{
    if (!_bigHideButton) {
        _bigHideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bigHideButton.frame = CGRectMake(TKFT_SCREEN_WIDTH -80, 0, 80, CGRectGetHeight(self.bounds));
        [_bigHideButton addTarget:self action:@selector(doHideBoard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bigHideButton;
}
-(void)setContentString:(NSString *)contentString
{
    _contentString = contentString;
    _titleLabel.text = _contentString;
    
    if ([contentString containsString:@"自选合约"]) {
        self.bottomRule.hidden = NO;
        self.topRule.hidden = NO;
        self.backgroundColor = [[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftShowViewTitleBgColor"].backgroundColor;
        self.titleLabel.textColor = [[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftMainTextColor"].textColor;
        self.hideButton.layer.borderColor = [[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftSeparateLine"].backgroundColor.CGColor;
        self.topRule.backgroundColor = [[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftSeparateLine"].backgroundColor;
        self.bottomRule.backgroundColor = [[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftSeparateLine"].backgroundColor;
    }else{
        self.bottomRule.hidden = YES;
        self.topRule.hidden = YES;
        self.backgroundColor = [TKUIHelper colorWithHexString:@"#DDDDDD"];
        self.titleLabel.textColor = [TKUIHelper colorWithHexString:@"#000000"];
    }
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  隐藏键盘
 *
 */
-(void)doHideBoard:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(toolBarHide:)])
    {
        [self.delegate toolBarHide:self];
    }
}

/**
 顶部分割线

 @return 顶部分割线
 */
-(UIView *)topRule
{
    if (!_topRule) {
        _topRule = [[UIView alloc]init];
        _topRule.frame = CGRectMake(0, 0, self.width, 0.5);
    }
    
    return _topRule;
}

/**
 底部分割线
 
 @return 底部分割线
 */
-(UIView *)bottomRule
{
    if (!_bottomRule) {
        _bottomRule = [[UIView alloc]init];
        _bottomRule.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
    }
    
    return _bottomRule;
}

@end
