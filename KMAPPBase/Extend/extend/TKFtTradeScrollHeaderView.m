//
//  TKFtTradeScrollHeaderView.m
//  TKApp_HL
//
//  Created by thinkive on 2017/3/20.
//  Copyright © 2017年 com.thinkive.www. All rights reserved.
//

#import "TKFtTradeScrollHeaderView.h"

#define SUBVIEW_HORIZONTAL_MARGIN ft750AdaptationWidth(8)

static const CGFloat  TKFt_Label_Font_Value = 14;

@interface TKFtTradeScrollHeaderView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UILabel *nameLable;//合约名称标签
@property (nonatomic,strong) UIScrollView *scrollView;//滑动底图
@property (nonatomic,strong) NSArray *titles;//标题名数组
@property (nonatomic,strong) NSMutableArray *labelArrays;//标签数组
@property (nonatomic,strong) UIImageView *leftIndicatorImg;//左边指示剂
@property (nonatomic,strong) UIImageView *rightIndicatorImg;//右边指示剂
@property (nonatomic,strong) UIView *leftIndicatorView;//左边渐变色块
@property (nonatomic,strong) UIView *rightIndicatorView;//左边渐变色块
@property (nonatomic,strong) UIView *separatorView;//底部分割线
@property (nonatomic,strong) UIView *topRuleView;//顶部分割线
@property (nonatomic,strong) UIView *ruleView1;//第一条分隔线
@property (nonatomic,strong) UIView *contentView;//内容底图
@property (nonatomic,strong) NSMutableArray *widthArray;
@property (nonatomic,assign) CGFloat nameLabelWidth;
@property (nonatomic,assign) CGFloat nameLabelFont;
@property (nonatomic,assign) TKFtTradeOperationMenuType menuType; //菜单类型
@property (nonatomic,assign) BOOL isShowIndicator; //是否显示指示器
@end

@implementation TKFtTradeScrollHeaderView

- (instancetype)initWithTradeOperationMenuType:(TKFtTradeOperationMenuType)type{
    _menuType = type;
    [self doReadLabelTitlesAndWidthsWithMenuType:_menuType];
    if (self = [super init]) {
        
    }
    return self;
}

-(instancetype)initWithTitles:(NSArray *)titles andWidthArray:(NSMutableArray *)widthArray nameLabelWidth:(CGFloat)nameLabelWidth nameLabelFont:(CGFloat)font
{
    self.widthArray = widthArray;
    _titles = titles;
    _nameLabelWidth = nameLabelWidth;
    _nameLabelFont = font;
    self = [self init];
    return self;
}

//初始化
-(instancetype)initWithTitles:(NSArray *)titles andWidthArray:(NSMutableArray *)widthArray nameLabelWidth:(CGFloat)nameLabelWidth nameLabelFont:(CGFloat)font menuType:(TKFtTradeOperationMenuType)type
{
    _menuType = type;
    self.widthArray = widthArray;
    _titles = titles;
    _nameLabelWidth = nameLabelWidth;
    _nameLabelFont = font;
    self = [self init];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupView];
    }
    return self;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  初始化子视图
 */
-(void)setupView
{
    [self addCssClass:@".ftScrollHeaderViewBgColor"];
    [self addSubview:self.nameLable];
    [self addSubview:self.separatorView];
    [self addSubview:self.topRuleView];
    [self addSubview:self.scrollView];
    if (_menuType != TKFtTradeOperationMenuTypeUnknown && _menuType != TKFtTradeOperationMenuTypeNotEdge) {
        _ruleView1 = [self getRuleView];
        [self addSubview:_ruleView1];
    }
    [self.scrollView addSubview:self.contentView];
    if (_isShowIndicator && _menuType != TKFtTradeOperationMenuTypeUnknown && _menuType != TKFtTradeOperationMenuTypeNotEdge) {
        
        [self addSubview:self.leftIndicatorView];
        [self addSubview:self.rightIndicatorView];
        [self addSubview:self.leftIndicatorImg];
        [self addSubview:self.rightIndicatorImg];
    }else{
        [self addSubview:self.leftIndicatorImg];
        [self addSubview:self.rightIndicatorImg];
    }
    if (_menuType == TKFtTradeOperationMenuTypeUnknown || _menuType == TKFtTradeOperationMenuTypeNotEdge) {
        [self layoutPageSubViews2];
    }else{
        [self layoutPageSubViews];
    }
}

/**
 *  @author 陈智坤, 16-05-23 15:05:34
 *
 *  @brief 布局子控件
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark--ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(doScrollViewDidHeaderScroll:)])
    {
        [self.delegate doScrollViewDidHeaderScroll:scrollView];
    }
    CGFloat rightEdge = _menuType == TKFtTradeOperationMenuTypeUnknown?SUBVIEW_HORIZONTAL_MARGIN:0;
    if ([TKStringHelper isNotEmpty:_notificationName]) {
        CGPoint offsetPoint = scrollView.contentOffset;
        NSDictionary *params = @{
                                 TKFtTradeScrollTableViewHeaderViewDidParamKey :
                                     (NSStringFromCGPoint(offsetPoint))
                                 };
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:_notificationName object:self userInfo:params];
    }
    
    //判断指示器是否显示
    CGFloat subViewWidth = (scrollView.frame.size.width - (rightEdge*2)) / 3;
    if (scrollView.contentOffset.x < subViewWidth/2)
    {
        _leftIndicatorImg.hidden = YES;
        _leftIndicatorView.hidden = YES;
        _rightIndicatorImg.hidden = NO;
        _rightIndicatorView.hidden = NO;
    }
    else if (scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.frame.size.width - subViewWidth/2)
    {
        _leftIndicatorImg.hidden = NO;
        _leftIndicatorView.hidden = NO;
        _rightIndicatorImg.hidden = YES;
        _rightIndicatorView.hidden = YES;
    }
    else
    {
        _leftIndicatorImg.hidden = NO;
        _leftIndicatorView.hidden = NO;
        _rightIndicatorImg.hidden = NO;
        _rightIndicatorView.hidden = NO;
    }
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  设置滚动位移值
 *
 *  scrollView
 */
- (void)doSetUpHeaderContOffex:(UIScrollView *)scrollView
{
    self.scrollView.contentOffset = scrollView.contentOffset;
}

#pragma mark - setter and gerter

/**
 *  @author yyf, 16-11
 *
 *  @brief  获取当前的偏移量
 */
-(CGPoint)contentOffSet
{
    return _scrollView.contentOffset;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  合约名称标签
 */
-(UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.text = _titles[0];
        _nameLable.textAlignment = NSTextAlignmentCenter;
        _nameLable.font = [UIFont ftk750AdaptationFont:TKFt_Label_Font_Value];
        [_nameLable addCssClass:@".ftMiddleTextColor"];
    }
    return _nameLable;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  左边指示剂
 */
-(UIImageView *)leftIndicatorImg
{
    if (!_leftIndicatorImg) {
        _leftIndicatorImg = [[UIImageView alloc]init];
        [_leftIndicatorImg addCssClass:@".ftLeftMore"];
        _leftIndicatorImg.contentMode = UIViewContentModeScaleAspectFit;
        _leftIndicatorImg.hidden = YES;
    }
    return _leftIndicatorImg;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  右边指示剂
 */
-(UIImageView *)rightIndicatorImg
{
    if (!_rightIndicatorImg) {
        _rightIndicatorImg = [[UIImageView alloc]init];
        [_rightIndicatorImg addCssClass:@".ftRightMore"];
        _rightIndicatorImg.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _rightIndicatorImg;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  分割线
 */
-(UIView *)separatorView
{
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        [_separatorView addCssClass:@".ftSeparateLine"];
    }
    return _separatorView;
}
-(UIView *)topRuleView
{
    if (!_topRuleView) {
        _topRuleView = [[UIView alloc]init];
        [_topRuleView addCssClass:@".ftSeparateLine"];
    }
    return _topRuleView;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  内容视图
 */
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  内容视图,不包含合约名标签
 */
-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        //添加具体的子视图
        NSUInteger count = self.labelArrays.count;
        for (int i = 0; i<count; i++)
        {
            UILabel *subView = self.labelArrays[i];
            subView.textAlignment = NSTextAlignmentCenter;
            subView.text = _titles[i+1];
            subView.font = [UIFont ftk750AdaptationFont:TKFt_Label_Font_Value];
            [subView addCssClass:@".ftMiddleTextColor"];
            [_contentView addSubview:subView];
        }
    }
    return _contentView;
}

/**
 *  @author yyf, 16-11
 *
 *  @brief  集体子视图内容标签
 */
- (NSMutableArray *)labelArrays
{
    if (!_labelArrays) {
        _labelArrays = [NSMutableArray array];
        for (int i = 1; i<_titles.count; i++) {
            UILabel *subView = [[UILabel alloc]init];
            subView.textAlignment = NSTextAlignmentCenter;
            [_labelArrays addObject:subView];
        }
    }
    return _labelArrays;
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  宽度数组
 */
-(NSMutableArray *)widthArray
{
    if (!_widthArray) {
        _widthArray = [NSMutableArray array];
    }
    return _widthArray;
}
- (UIView *)leftIndicatorView{
    if (!_leftIndicatorView) {
        _leftIndicatorView = [[UIView alloc]init];
        //        _leftIndicatorView.backgroundColor =({
        //            UIColor *color = nil;
        //            if ([[TKThemeManager shareInstance].theme isEqualToString:@"theme1"]) {
        //                color = [UIColor whiteColor];
        //            }else{
        //                color = [TKUIHelper colorWithHexString:@"#111410"];
        //            }
        //            color;
        //        });
        _leftIndicatorView.hidden = YES;
    }
    return _leftIndicatorView;
}
- (UIView *)rightIndicatorView{
    if (!_rightIndicatorView) {
        _rightIndicatorView = [[UIView alloc]init];
        //        _rightIndicatorView.backgroundColor =({
        //            UIColor *color = nil;
        //            if ([[TKThemeManager shareInstance].theme isEqualToString:@"theme1"]) {
        //                color = [UIColor whiteColor];
        //            }else{
        //                color = [TKUIHelper colorWithHexString:@"#111410"];
        //            }
        //            color;
        //        });
        _rightIndicatorView.hidden = YES;
    }
    return _rightIndicatorView;
}

//根据type读取标题和宽度配置   20181022
- (void)doReadLabelTitlesAndWidthsWithMenuType:(TKFtTradeOperationMenuType)type
{
    NSString *titleParasKey = nil,*labelWidthKey = nil;
    switch (type) {
        case TKFtTradeOperationMenuTypeHolding:
            titleParasKey = @"holdingParas";
            labelWidthKey = @"holdingSectionHeaderWidth";
            break;
        case TKFtTradeOperationMenuTypeRevoke:
            titleParasKey = @"revokeParas";
            labelWidthKey = @"revokeSectionHeaderWidth";
            break;
        case TKFtTradeOperationMenuTypeEntrust:
            titleParasKey = @"entrustParas";
            labelWidthKey = @"entrustSectionHeaderWidth";
            break;
        case TKFtTradeOperationMenuTypeTurnover:
            titleParasKey = @"turnoverParas";
            labelWidthKey = @"turnoverSectionHeaderWidth";
            break;
        default:
            break;
    }
    if (titleParasKey&&labelWidthKey) {
        NSString *titleParasStr = [[TKFtConfig instance] getConfigByKey:[NSString stringWithFormat:@"Common.%@",titleParasKey]];
        if (!titleParasStr) return;
        NSArray *titleParas = [titleParasStr componentsSeparatedByString:@"|"];
        _titles = titleParas;
        NSString *labelWidthParasStr = [[TKFtConfig instance] getConfigByKey:[NSString stringWithFormat:@"Common.%@",labelWidthKey]];
        if (!labelWidthParasStr) return;
        NSArray *labelWidthParas = [labelWidthParasStr componentsSeparatedByString:@"|"];
        self.widthArray = labelWidthParas.mutableCopy;
        float width_total = 0;
        for (NSString *width in self.widthArray) {
            width_total += width.floatValue;
        }
        _isShowIndicator = width_total>375;
    }
    
}

- (void)layoutPageSubViews
{
    
    NSString *nameLabelWidthStr = self.widthArray?self.widthArray[0]:nil;
    CGFloat nameLabelWidth = nameLabelWidthStr?ft750AdaptationWidth(nameLabelWidthStr.floatValue):ft750AdaptationWidth(94.5);
    
    //第一个不滚动的标题
    //根据屏幕尺寸设置width
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(nameLabelWidth);
    }];
    
    [_ruleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ft750AdaptationWidth(0.5));
        make.left.equalTo(_nameLable.mas_right);
        make.top.bottom.equalTo(self);
    }];
    
    if (_isShowIndicator) {
        
        [_leftIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_nameLable.mas_right).offset(ft750AdaptationWidth(0.5));
            make.width.mas_equalTo(ft750AdaptationWidth(44));
            make.height.mas_equalTo(ft750AdaptationWidth(34));
        }];
        [_rightIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(ft750AdaptationWidth(44));
            make.height.mas_equalTo(ft750AdaptationWidth(34));
        }];
        //左滚动指示器
        [_leftIndicatorImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(_nameLable.mas_right).offset(ft750AdaptationWidth(6.5));
            make.width.mas_equalTo(ft750AdaptationWidth(7));
        }];
        //右滚动指示器
        [_rightIndicatorImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(self).offset(-ft750AdaptationWidth(7));
            make.width.mas_equalTo(ft750AdaptationWidth(7));
        }];
        
        [self addView:_leftIndicatorView Frame:CGRectMake(0, 0, ft750AdaptationWidth(44), ft750AdaptationWidth(30)) Left:YES];
        [self addView:_rightIndicatorView Frame:CGRectMake(0, 0, ft750AdaptationWidth(44), ft750AdaptationWidth(30)) Left:NO];
    }
    
    //底部分割线
    [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ft750AdaptationWidth(0.5));
        make.right.left.bottom.equalTo(self);
    }];
    //顶部分割线
    [_topRuleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ft750AdaptationWidth(0.5));
        make.right.left.top.equalTo(self);
    }];
    //滚动视图
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        //        make.left.equalTo(_leftIndicatorImg.mas_right);
        //        make.right.equalTo(_rightIndicatorImg.mas_left);
        make.left.equalTo(_nameLable.mas_right);
        make.right.equalTo(self);
    }];
    //设置scrollview的内容
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    
    //计算width
    NSUInteger count = self.labelArrays.count;
    UIView *lastView = nil;
    for (int i = 0; i<count; i++)
    {
        UILabel *subView = self.labelArrays[i];
        UIView *ruleView = [self getRuleView];
        [_contentView addSubview:ruleView];
        
        CGFloat subViewWidth =  ft750AdaptationWidth([self.widthArray[i+1] floatValue]);
        
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_contentView);
            make.width.equalTo([NSNumber numberWithFloat:subViewWidth]);
            if (lastView)
            {
                make.left.equalTo(lastView.mas_right);
            }
            else
            {
                make.left.equalTo(_contentView);
            }
        }];
        
        [ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ft750AdaptationWidth(0.5));
            make.left.equalTo(subView.mas_right);
            make.top.bottom.equalTo(_contentView);
        }];
        
        lastView = subView;
    }
    if (lastView) {
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView);
        }];
    }
}

-(UIView *)getRuleView
{
    UIView *ruleView = [[UIView alloc]init];
    [ruleView addCssClass:@".ftSeparateLine"];
    return ruleView;
}

- (void)addView:(UIView *)view Frame:(CGRect)frame Left:(BOOL)left{
    
    NSInteger leftColorComponent = left?0:1;
    NSInteger rightColorComponent = left?1:0;
    
    UIColor *backgroundColor =({
        UIColor *color = nil;
        if ([[TKThemeManager shareInstance].theme isEqualToString:@"theme1"]) {
            color = [UIColor whiteColor];
        }else{
            color = [TKUIHelper colorWithHexString:@"#111410"];
        }
        color;
    });
    UIColor *startColor = [backgroundColor colorWithAlphaComponent:leftColorComponent];
    UIColor *endColor = [backgroundColor colorWithAlphaComponent:rightColorComponent];
    CAGradientLayer *alphaGradientLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[startColor  CGColor],
                       (id)[endColor   CGColor],
                       nil];
    [alphaGradientLayer setColors:colors];
    
    [alphaGradientLayer setStartPoint:CGPointMake(1.0f, 0.0f)];
    [alphaGradientLayer setEndPoint:CGPointMake(0.0f, 0.0f)];
    
    [alphaGradientLayer setFrame:frame];
    
    [[view layer] addSublayer:alphaGradientLayer];
    
}
- (void)layoutPageSubViews2
{
    CGFloat rightEdge = _menuType == TKFtTradeOperationMenuTypeUnknown?SUBVIEW_HORIZONTAL_MARGIN:0;
    //第一个不滚动的标题
    //根据屏幕尺寸设置width
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(ft750AdaptationWidth(15));
        make.width.mas_equalTo(_nameLabelWidth);
    }];
    
    //左滚动指示器
    [_leftIndicatorImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_nameLable.mas_right).offset(ft750AdaptationWidth(6.5));
        make.width.mas_equalTo(ft750AdaptationWidth(7));
    }];
    //右滚动指示器
    [_rightIndicatorImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-ft750AdaptationWidth(7));
        make.width.mas_equalTo(ft750AdaptationWidth(7));
    }];
    //分割线
    [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ft750AdaptationWidth(0.5));
        make.right.left.bottom.equalTo(self);
    }];
    //计算width
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_leftIndicatorImg.mas_right);
        make.right.equalTo(_rightIndicatorImg.mas_left);
    }];
    //设置scrollview的内容
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    
    //计算width
    NSUInteger count = self.labelArrays.count;
    UIView *lastView = nil;
    for (int i = 0; i<count; i++)
    {
        UILabel *subView = self.labelArrays[i];
        CGFloat subViewWidth =  [self.widthArray[i] floatValue];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_contentView);
            make.width.equalTo([NSNumber numberWithFloat:subViewWidth]);
            if (lastView)
            {
                make.left.equalTo(lastView.mas_right).offset(rightEdge);
            }
            else
            {
                make.left.equalTo(_contentView);
            }
        }];
        lastView = subView;
    }
    if (lastView) {
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView);
        }];
    }
    
}
@end

