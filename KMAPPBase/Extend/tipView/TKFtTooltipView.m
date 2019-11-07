//
//  TKFtTooltipView.m
//  TKApp
//
//  Created by thinkive on 2018/3/14.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "TKFtTooltipView.h"

@interface TKFtTooltipView()
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIButton *confirmBtn;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIView *separatorView_1;
@property(nonatomic,strong)UIView *separatorView_2;
@property(nonatomic,strong)UIView *separatorView_3;
@property(nonatomic,assign)TKFtTooltipViewType type;
//@property(nonatomic,strong)TKHqNotificationHub *tipHubView;
@property (nonatomic,strong) UIView *radiusView;//圆角背景图
@property (nonatomic,strong) NSArray *buttonTitles;
@end

@implementation TKFtTooltipView

-(instancetype)initWithTitle:(NSString *)title withContent:(NSString *)content withStyle:(TKFtTooltipViewType)type
{
    _title = [title copy];
    _content = [content copy];
    _type = type;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doFreshCssAndSubViewsCss) name:QHThemeChange object:nil];
    self = [self init];
    return self;
}

-(instancetype)initWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles withContent:(NSString *)content withStyle:(TKFtTooltipViewType)type
{
    _title = [title copy];
    _content = [content copy];
    _buttonTitles = [buttonTitles copy];
    _type = type;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doFreshCssAndSubViewsCss) name:QHThemeChange object:nil];
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

-(void)layoutSubviews
{
    //整体输入框
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        //        make.centerY.equalTo(self).multipliedBy(0.6);
        make.centerY.equalTo(self);
        make.height.greaterThanOrEqualTo(@(ft750AdaptationWidth(44)*3));
        make.left.equalTo(self).offset(ft750AdaptationWidth(45));
        make.right.equalTo(self).offset(-ft750AdaptationWidth(45));
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
    [_separatorView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ft750AdaptationWidth(0.5));
        make.left.right.equalTo(_backgroundView);
        make.top.equalTo(_titleLabel.mas_bottom);
    }];
    //内容
    //内容的高度计算
    CGFloat textWidth = [UIScreen mainScreen].bounds.size.width - ft750AdaptationWidth(90) - ft750AdaptationWidth(30);
    CGSize textMaxSize = CGSizeMake(textWidth, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize textSize = [_content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat contentLabelHeight = textSize.height+ft750AdaptationWidth(20) + ft750AdaptationWidth(25)*2;
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_separatorView_1.mas_bottom);
        make.left.equalTo(_backgroundView).offset(ft750AdaptationWidth(15));
        make.right.equalTo(_backgroundView).offset(-ft750AdaptationWidth(15));
    }];
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:contentLabelHeight]);
    }];
    //分割线2
    [_separatorView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ft750AdaptationWidth(0.5));
        make.left.right.equalTo(_backgroundView);
        make.top.equalTo(_contentLabel.mas_bottom);
    }];
    if (_type == TKFtTooltipViewTypeSingle)
    {
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separatorView_2.mas_bottom);
            make.left.bottom.right.equalTo(_backgroundView);
            make.height.mas_equalTo(ft750AdaptationWidth(44));
        }];
    }
    else
    {
        
        //分割线3
        [_separatorView_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separatorView_2.mas_bottom);
            make.bottom.equalTo(_backgroundView);
            make.centerX.equalTo(_backgroundView.mas_centerX).offset(ft750AdaptationWidth(0.25));
            make.width.mas_equalTo(ft750AdaptationWidth(0.5));
        }];
        
        //确认按钮
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separatorView_2.mas_bottom);
            make.right.bottom.equalTo(_backgroundView);
            make.left.equalTo(_separatorView_3.mas_right).offset(0);
            make.height.mas_equalTo(ft750AdaptationWidth(44));
        }];
        //取消按钮
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separatorView_2.mas_bottom);
            make.left.bottom.equalTo(_backgroundView);
            make.right.equalTo(_separatorView_3.mas_left).offset(0);
            make.height.mas_equalTo(ft750AdaptationWidth(44));
        }];
    }
    [super layoutSubviews];
}

-(void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //整体输入框
    _backgroundView = [[UIView alloc]init];
    _backgroundView.layer.cornerRadius = ft750AdaptationWidth(10);
    _backgroundView.alpha = 0.9;
    [_backgroundView addCssClass:@".ftShowViewBgColor"];
    [self addSubview:_backgroundView];
    
    //圆角背景图
    _radiusView = [[UIView alloc]init];
    [_radiusView addCssClass:@".ftShowViewTitleBgColor"];
    [_backgroundView addSubview:_radiusView];
    
    //title
    _titleLabel = [[UILabel alloc]init];
    [_titleLabel addCssClass:@".ftMainTextColor"];
    [_titleLabel addCssClass:@".ftShowViewTitleBgColor"];
    _titleLabel.layer.cornerRadius = ft750AdaptationWidth(10);
    _titleLabel.layer.masksToBounds = YES;
    _titleLabel.font = [UIFont ftk750AdaptationFont:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = _title;
    [_backgroundView addSubview:_titleLabel];
    //分割线1
    _separatorView_1 = [[UIView alloc]init];
    [_separatorView_1 addCssClass:@".ftSeparateLine"];
    [_backgroundView addSubview:_separatorView_1];
    //内容
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.numberOfLines = 0;
    [_contentLabel addCssClass:@".ftMainTextColor"];
    _contentLabel.font = [UIFont ftk750AdaptationFont:18];
    _contentLabel.text = _content;
    [_backgroundView addSubview:_contentLabel];
    //分割线2
    _separatorView_2 = [[UIView alloc]init];
    [_separatorView_2 addCssClass:@".ftSeparateLine"];
    [_backgroundView addSubview:_separatorView_2];
    
    NSString *textColorStr = [TKFtColourHelp getftUpRedTextColor];
    if (_type == TKFtTooltipViewTypeSingle)
    {
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        //确认按钮
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *confirmButtonTitle = _buttonTitles.count?_buttonTitles[0]:@"确认";
        [_confirmBtn setTitle:confirmButtonTitle forState:UIControlStateNormal];
        [_confirmBtn addCssClass:textColorStr];
        _confirmBtn.titleLabel.font = [UIFont ftk750AdaptationFont:18];
        [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:_confirmBtn];
    }
    else
    {
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        
        //分割线3
        _separatorView_3 = [[UIView alloc]init];
        [_separatorView_3 addCssClass:@".ftSeparateLine"];
        [_backgroundView addSubview:_separatorView_3];
        //确认按钮
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *confirmButtonTitle = _buttonTitles.count?_buttonTitles[0]:@"确认";
        [_confirmBtn setTitle:confirmButtonTitle forState:UIControlStateNormal];
        [_confirmBtn addCssClass:textColorStr];
        _confirmBtn.titleLabel.font = [UIFont ftk750AdaptationFont:18];
        [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:_confirmBtn];
        //取消按钮
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *cancleButtonTitle = _buttonTitles.count>1?_buttonTitles[1]:@"取消";
        [_cancelBtn setTitle:cancleButtonTitle forState:UIControlStateNormal];
        [_cancelBtn addCssClass:@".ftMainTextColor"];
        _cancelBtn.titleLabel.font = [UIFont ftk750AdaptationFont:18];
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:_cancelBtn];
    }
}

-(void)confirmClick
{
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(futureTradeTransferTooltipViewClickConfirm)]) {
        [self.delegate futureTradeTransferTooltipViewClickConfirm];
    }
    if (_futureTradeTransferTooltipViewClickConfirm) {
        _futureTradeTransferTooltipViewClickConfirm();
    }
}

-(void)cancelClick
{
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(futureTradeTransferTooltipViewClickCancel)]) {
        [self.delegate futureTradeTransferTooltipViewClickCancel];
    }
    if (_futureTradeTransferTooltipViewClickCancel) {
        _futureTradeTransferTooltipViewClickCancel();
    }
}

-(void)show
{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
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
    _contentLabel.text = _content;
}


-(void)setAlignmentType:(TKFtTooltipAlignmentType)alignmentType
{
    _alignmentType = alignmentType;
    if (_alignmentType == TKFtTooltipAlignmentTypeLeft)
    {
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }else if (_alignmentType == TKFtTooltipAlignmentTypeRight)
    {
        _contentLabel.textAlignment = NSTextAlignmentRight;
    }else if (_alignmentType == TKFtTooltipAlignmentTypeCenter)
    {
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
}

-(void)setOrientationType:(TKFtTipOrientationType)orientationType
{
    _orientationType = orientationType;
    if (_orientationType == TKFtTipOrientationTypeLand) {
        _backgroundView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else{
        
    }
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
 *  @author 刘贝, 16-11-11 10:11:00
 *
 *  @brief 设置提示值
 */
//- (void)setTipHubNum:(NSInteger)tipHubNum
//{
//    _tipHubNum = tipHubNum;
//    [self.tipHubView setCount:(int)tipHubNum];
//}

/**
 *  @author 刘贝, 16-11-11 10:11:18
 *
 *  @brief 是否显示提示值
 */
//- (void)setIsShowTipHub:(BOOL)isShowTipHub
//{
//    _isShowTipHub = isShowTipHub;
//    if (isShowTipHub) {
//        [self.tipHubView pop];
//    }else{
//        [self.tipHubView hideCount];
//    }
//}

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

/**
 *  @author 刘贝, 16-11-11 10:11:16
 *
 *  @brief 小圆角提示
 */
//- (TKHqNotificationHub *)tipHubView
//{
//    if (!_tipHubView) {
//        _tipHubView = [[TKHqNotificationHub alloc] initWithView:_confirmBtn];
//        [_tipHubView moveCircleByX:5 Y:0];
////        [_tipHubView setCount:3];
//    }
//    return _tipHubView;
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

