//
//  TKFtChooseViewCell.m
//  TKFtSDK
//
//  Created by thinkive on 2018/5/25.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import "TKFtChooseViewCell.h"

@interface TKFtChooseViewCell()

@property (nonatomic,strong) UILabel *textLable;

@end

@implementation TKFtChooseViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self addCssClass:@".ftBaseBackgroundColor"];
    }
    return self;
}

-(void)initUI
{
    _textLable = [[UILabel alloc]init];
    _textLable.font = [UIFont ftk750AdaptationFont:14];
    [self.contentView addSubview:_textLable];
    _textLable.textAlignment = NSTextAlignmentCenter;
    [_textLable addCssClass:@".ftMainTextColor"];
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.contentView);
    }];
    
    _textLable.layer.masksToBounds = YES;
    _textLable.layer.cornerRadius = 2;
    _textLable.layer.borderWidth = 0.5;
    _textLable.layer.borderColor = [[TKThemeManager shareInstance] getCssRulesetByCssKey:@".ftSeparateLine"].backgroundColor.CGColor;

}

-(void)setTitle:(NSString *)title
{
    _title = [title copy];
    _textLable.text = title;
}

-(void)freshSelectCellBgColor
{
    [self removeCss];
    [self addCssClass:@".ftChooseKeyBoardSelectBgColor"];
    [self.textLable addCssClass:@".ftChooseKeyBoardSelectTextColor"];
}

-(void)freshNormalCellBgColor
{
    [self removeCss];
    [self addCssClass:@".ftBaseBackgroundColor"];
    [self.textLable addCssClass:@".ftMainTextColor"];
}


@end
