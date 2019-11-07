//
//  TKFtShowHandBackView.m
//  TKApp_HL
//
//  Created by thinkive on 2017/5/8.
//  Copyright © 2017年 liubao. All rights reserved.
//

#import "TKFtShowHandBackView.h"

@interface TKFtShowHandBackView()
@property (nonatomic,strong) UIView  *backgroundView;//背景底图
@property (nonatomic,strong) UIView  *separatorView1;//分割线1
@property (nonatomic,strong) UIView  *separatorView2;//分割线2
@property (nonatomic,strong) UILabel *contentLabel;//内容标签
@property (nonatomic,strong) UIButton*confirmBtn;//确认按钮
@property (nonatomic,strong) UIButton*cancelBtn;//取消按钮
@property (nonatomic,  copy) NSAttributedString *attributedString;

@end

@implementation TKFtShowHandBackView


-(instancetype)initWithContent:(NSString *)content
{
    _content = [content copy];
    _attributedString = [self stringChangeAttributedStringWithString:_content];
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

-(void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //背景底图
    [self addSubview:self.backgroundView];
    [_backgroundView addSubview:self.separatorView1];
    [_backgroundView addSubview:self.separatorView2];
    [_backgroundView addSubview:self.confirmBtn];
    [_backgroundView addSubview:self.cancelBtn];
    [_backgroundView addSubview:self.contentLabel];
    
}

-(void)layoutSubviews
{
    //背景底图
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.height.greaterThanOrEqualTo(@(44*3));
        make.width.mas_equalTo(ft750AdaptationWidth(270));
    }];

    //内容的高度计算
    CGFloat contentLabelX = (TKFT_SCREEN_WIDTH - ft750AdaptationWidth(90)) *0.15;
    CGFloat textWidth = [UIScreen mainScreen].bounds.size.width - ft750AdaptationWidth(90) - ft750AdaptationWidth(30);
    CGSize textMaxSize = CGSizeMake(textWidth, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont ftk750AdaptationFont:14]};
    CGSize textSize = [_content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat contentLabelHeight = textSize.height + ft750AdaptationWidth(25*2);
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView.mas_top).offset(ft750AdaptationWidth(15));
        make.left.equalTo(_backgroundView).offset(contentLabelX);
        make.right.equalTo(_backgroundView).offset(-ft750AdaptationWidth(15));
//        make.bottom.equalTo(_backgroundView.mas_bottom).offset(-35);
    }];
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:contentLabelHeight]);
    }];
    
    //分割线2
    [_separatorView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ft750AdaptationWidth(0.5));
        make.left.right.equalTo(_backgroundView);
        make.top.equalTo(_contentLabel.mas_bottom).offset(ft750AdaptationWidth(15));
    }];
    
    //分割线3
    [_separatorView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ft750AdaptationWidth(0.5));
        make.top.equalTo(_separatorView1.mas_bottom);
        make.centerX.equalTo(_backgroundView);
        make.bottom.equalTo(_backgroundView);
    }];
    //确认按钮
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_separatorView1.mas_bottom);
        make.left.bottom.equalTo(_backgroundView);
        make.right.equalTo(_separatorView2.mas_left);
        make.height.mas_equalTo(ft750AdaptationWidth(45));
    }];
    //取消按钮
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_separatorView1.mas_bottom);
        make.right.bottom.equalTo(_backgroundView);
        make.left.equalTo(_separatorView2.mas_right);
        make.height.mas_equalTo(ft750AdaptationWidth(45));
    }];
    
    [super layoutSubviews];
}

-(void)doConfirmClick
{
    [self hide];
    if ([self.delegate respondsToSelector:@selector(doHandBackClickConfirm)]) {
        [self.delegate doHandBackClickConfirm];
    }
}

-(void)doCancelClick
{
    [self hide];
    if ([self.delegate respondsToSelector:@selector(doHandBackClickCancel)]) {
        [self.delegate doHandBackClickCancel];
    }
}

-(void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.frame = keyWindow.bounds;
}

-(void)hide
{
    [self removeFromSuperview];
}

-(void)setContent:(NSString *)content
{
    _content = [content copy];
    _attributedString = [self stringChangeAttributedStringWithString:_content];
    _contentLabel.attributedText = _attributedString;
}

-(NSAttributedString *)stringChangeAttributedStringWithString:(NSString *)string
{
    if (!string) {
        string = @"    ";
    }
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 5.0f;  // 行距
    //    paragraph.paragraphSpacingBefore = 50.0f; // 段前距
    paragraph.alignment = NSTextAlignmentLeft; // 对齐方式
    //    paragraph.headIndent = -50.0f; // 头缩进
    //    paragraph.tailIndent = 320; // 尾缩进
    //    paragraph.minimumLineHeight = 10.0f;   // 最小行高
    //    paragraph.maximumLineHeight = 10.0f;   // 最大行高
    paragraph.lineBreakMode = NSLineBreakByWordWrapping; // 换行模式
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName: paragraph}];
    return attributedString;
}

#pragma mark - setter and getter

/**
 *  @author yyf, 16-11
 *
 *  @brief  背景底图
 */
-(UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.layer.cornerRadius = ft750AdaptationWidth(10);
        _backgroundView.alpha = 0.9;
        [_backgroundView addCssClass:@".ftBaseBackgroundColor"];
    }
    return _backgroundView;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  分割线2
 */
-(UIView *)separatorView1
{
    if (!_separatorView1) {
        _separatorView1 = [[UIView alloc]init];
        [_separatorView1 addCssClass:@".ftSeparateLine"];
    }
    return _separatorView1;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  分割线3
 */
-(UIView *)separatorView2
{
    if (!_separatorView2) {
        _separatorView2 = [[UIView alloc]init];
        [_separatorView2 addCssClass:@".ftSeparateLine"];
    }
    return _separatorView2;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  确认按钮
 */
-(UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addCssClass:@".ftUpRedTextColor"];
        _confirmBtn.titleLabel.font = [UIFont ftk750AdaptationFont:16];
        [_confirmBtn addTarget:self action:@selector(doConfirmClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  取消按钮
 */
-(UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addCssClass:@".ftMainTextColor"];
        _cancelBtn.titleLabel.font = [UIFont ftk750AdaptationFont:16];
        [_cancelBtn addTarget:self action:@selector(doCancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  内容标签
 */
-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        [_contentLabel addCssClass:@".ftMainTextColor"];
        _contentLabel.font = [UIFont ftk750AdaptationFont:16];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.attributedText = _attributedString;
    }
    return _contentLabel;
}

@end
