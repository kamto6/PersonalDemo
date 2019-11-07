//
//  TKFutureTradeTransferPasswordInputView.m
//  TKApp
//
//  Created by 陈智坤 on 8/17/16.
//  Copyright © 2016 姚元丰. All rights reserved.
//

#import "TKFtPlaceOrdertipView.h"
#import "TKFtAttutStringHelp.h"

@interface TKFtPlaceOrdertipView()
@property (nonatomic,strong) UIView  *backgroundView;//背景底图
@property (nonatomic,strong) UIView  *separatorView1;//分割线1
@property (nonatomic,strong) UIView  *separatorView2;//分割线2
@property (nonatomic,strong) UIView  *separatorView3;//分割线3
@property (nonatomic,strong) UILabel *titleLabel;//标题标签
@property (nonatomic,strong) UILabel *contentLabel;//内容标签
@property (nonatomic,strong) UIButton *confirmBtn;//确认按钮
@property (nonatomic,strong) UIButton *cancelBtn;//取消按钮
@property (nonatomic,assign) TKFtPlaceOrdertipViewType type;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSMutableArray *contentViews;//集体内容标签
@property (nonatomic,strong) UIView *contentView;//内容底图
@property (nonatomic,  copy) NSAttributedString *attributedString;
@property (nonatomic,strong) UIView *radiusView;//圆角背景图

@end

@implementation TKFtPlaceOrdertipView

-(instancetype)initWithTitle:(NSString *)title withContent:(NSString *)content withStyle:(TKFtPlaceOrdertipViewType)type
{
    _title = [title copy];
    _content = [content copy];
    _attributedString = [TKFtAttutStringHelp changeStringHeightWithString:_content lineSpacing:5.0f];
    _type = type;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doFreshCssAndSubViewsCss) name:QHThemeChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:CTP_AUTO_LOGOFF object:nil];
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
    [_backgroundView addSubview:self.radiusView];
    [_backgroundView addSubview:self.titleLabel];
    [_backgroundView addSubview:self.separatorView1];
    [_backgroundView addSubview:self.separatorView2];
    [_backgroundView addSubview:self.separatorView3];
    [_backgroundView addSubview:self.contentView];
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
    
    //title
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_backgroundView);
        make.height.mas_equalTo(ft750AdaptationWidth(35));
    }];
    
    //圆角背景图
    [_radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_titleLabel.mas_bottom);
        make.left.right.equalTo(_backgroundView);
        make.height.mas_equalTo(ft750AdaptationWidth(11));
    }];
    //分割线1
    [_separatorView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ft750AdaptationWidth(0.5));
        make.left.right.equalTo(_backgroundView);
        make.top.equalTo(_titleLabel.mas_bottom);
    }];
    
    //内容的高度计算
    CGFloat contentLabelX = (TKFT_SCREEN_WIDTH - ft750AdaptationWidth(90)) *0.15;
    CGFloat textWidth = [UIScreen mainScreen].bounds.size.width - ft750AdaptationWidth(90) - ft750AdaptationWidth(30);
    CGSize textMaxSize = CGSizeMake(textWidth, CGFLOAT_MAX);
    //    NSDictionary *dic = @{NSFontAttributeName:[UIFont ftk750AdaptationFont:14]};
    //    CGSize textSize = [_content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    CGFloat lineSpacing = 5.0f;
    if (_lineSpacing != 0) {
        lineSpacing = _lineSpacing;
    }
    paragraph.lineSpacing = lineSpacing;  // 行距
    paragraph.alignment = NSTextAlignmentLeft; // 对齐方式
    paragraph.lineBreakMode = NSLineBreakByWordWrapping; // 换行模式
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_content attributes:@{NSParagraphStyleAttributeName: paragraph,NSFontAttributeName:[UIFont ftk750AdaptationFont:14]}];
    
    CGSize textSize = [attributedString boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    CGFloat contentLabelHeight = textSize.height + ft750AdaptationWidth(25*2);
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_separatorView1.mas_bottom);
        make.left.equalTo(_backgroundView).offset(contentLabelX);
        make.right.equalTo(_backgroundView).offset(-ft750AdaptationWidth(15));
    }];
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:contentLabelHeight]);
    }];
    //分割线2
    [_separatorView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ft750AdaptationWidth(0.5));
        make.left.right.equalTo(_backgroundView);
        make.top.equalTo(_contentLabel.mas_bottom);
    }];
    
    //分割线3
    [_separatorView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ft750AdaptationWidth(0.5));
        make.top.equalTo(_separatorView2.mas_bottom);
        make.centerX.equalTo(_backgroundView);
        make.bottom.equalTo(_backgroundView);
    }];
    //确认按钮
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_separatorView2.mas_bottom);
        make.left.bottom.equalTo(_backgroundView);
        make.right.equalTo(_separatorView3.mas_left);
        make.height.mas_equalTo(ft750AdaptationWidth(45));
    }];
    //取消按钮
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_separatorView2.mas_bottom);
        make.right.bottom.equalTo(_backgroundView);
        make.left.equalTo(_separatorView3.mas_right);
        make.height.mas_equalTo(ft750AdaptationWidth(45));
    }];
    
    [super layoutSubviews];
}

-(void)doConfirmClick
{
    [self hide];
    if ([self.delegate respondsToSelector:@selector(doPlaceOrdertClickConfirm)]) {
        [self.delegate doPlaceOrdertClickConfirm];
    }
    
    if (self.tipViewConfirmBlock) {
        self.tipViewConfirmBlock();
    }
}

-(void)doCancelClick
{
    [self hide];
    if ([self.delegate respondsToSelector:@selector(doPlaceOrdertClickCancel)]) {
        [self.delegate doPlaceOrdertClickCancel];
    }
    
    if (self.tipViewCancelBlock) {
        self.tipViewCancelBlock();
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

-(void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = _title;
}
-(void)setContent:(NSString *)content
{
    _content = [content copy];
    CGFloat lineSpacing = 5.0f;
    if (_lineSpacing != 0) {
        lineSpacing = _lineSpacing;
    }
    _attributedString = [TKFtAttutStringHelp changeStringHeightWithString:_content lineSpacing:lineSpacing];
    _contentLabel.attributedText = _attributedString;
}

-(void)setLineSpacing:(CGFloat)lineSpacing
{
    _lineSpacing = lineSpacing;
}

/**
 *  @author 刘贝, 16-09-26 14:09:30
 *
 *  @brief 自定义设置确认按钮标题文字
 */
- (void)setClickConfirmText:(NSString *)clickConfirmText
{
    _clickConfirmText = clickConfirmText;
    [_confirmBtn setTitle:clickConfirmText forState:UIControlStateNormal];
}

/**
 *  @author 刘贝, 16-09-26 14:09:53
 *
 *  @brief 自定义设置取消按钮标题文字
 */
- (void)setCancelText:(NSString *)cancelText
{
    _cancelText = cancelText;
    [_cancelBtn setTitle:_cancelText forState:UIControlStateNormal];
}



/**
 *  @author 刘贝, 16-10-25 12:10:18
 *
 *  @brief 自定义设置取消.确认按钮文字颜色
 *
 *  confirmColor 确认
 *  cancelColor  取消
 */
- (void)doSetUpConfirm:(UIColor *)confirmColor withCancel:(UIColor *)cancelColor
{
    if (_confirmBtn && confirmColor) {
        [_confirmBtn setTitleColor:confirmColor forState:UIControlStateNormal];
    }
    if (_cancelBtn && cancelColor) {
        [_cancelBtn setTitleColor:cancelColor forState:UIControlStateNormal];
    }
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  接收通知刷新界面css
 *
 *
 */
-(void)doFreshCssAndSubViewsCss
{
    [self refreshCssAndSubViewsCss];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - setter and getter
-(void)setOrientationType:(TKFtPlaceOrderOrientationType)orientationType
{
    _orientationType = orientationType;
    if (_orientationType == TKFtTipOrientationTypeLand) {
        _backgroundView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else{
        
    }
}
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
        [_backgroundView addCssClass:@".ftShowViewBgColor"];
    }
    return _backgroundView;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  标题标签
 */
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel addCssClass:@".ftMainTextColor"];
        [_titleLabel addCssClass:@".ftShowViewTitleBgColor"];
        _titleLabel.font = [UIFont ftk750AdaptationFont:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.cornerRadius = ft750AdaptationWidth(10);
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.text = _title;
    }
    return _titleLabel;
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  圆角背景图
 *
 *
 */
-(UIView *)radiusView
{
    if (!_radiusView) {
        _radiusView = [[UIView alloc]init];
        [_radiusView addCssClass:@".ftShowViewTitleBgColor"];
    }
    return _radiusView;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  分割线1
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
 *  @brief  分割线2
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
 *  @brief  分割线3
 */
-(UIView *)separatorView3
{
    if (!_separatorView3) {
        _separatorView3 = [[UIView alloc]init];
        [_separatorView3 addCssClass:@".ftSeparateLine"];
    }
    return _separatorView3;
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
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        NSString *textColorStr = [TKFtColourHelp getftUpRedTextColor];
        [_confirmBtn addCssClass:textColorStr];
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
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.attributedText = _attributedString;
    }
    return _contentLabel;
}

@end

