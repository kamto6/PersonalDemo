//
//  TKFtStoplossSheetView.m
//  TKApp_HL
//
//  Created by thinkive on 2017/6/1.
//  Copyright © 2017年 liubao. All rights reserved.
//

////设置图片
//#define setIMG(name) [UIImage imageNamed:name]

#import "TKFtSheetView.h"

typedef NS_ENUM(NSInteger,TKFtSheetType) {
    TKFtSheetTypeTypeImg,
    TKFtSheetTypeTypeTitle,
};

@interface TKFtSheetView()
@property(nonatomic,assign) TKFtSheetType actionSheetType;
@property(nonatomic,strong) UIWindow *backWindow;
@property(nonatomic,copy) NSArray *imgArray;
@property(nonatomic,copy) NSArray *titles;
@property(nonatomic,copy) NSArray *colors;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIView *optionsBgView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) NSMutableArray *optionBtnArrayM;
@property(nonatomic,strong) NSMutableArray *imageViews;
@property(nonatomic,strong) NSMutableArray *contentArray;

@property(nonatomic,assign) float bgViewHeigh;
@end

@implementation TKFtSheetView

+(instancetype)ActionSheetWithTitleArray:(NSArray<NSString *> *)titleArray andTitleColorArray:(NSArray *)colors delegate:(id<TKFtSheetViewDelegate>)delegate{
    return [[self alloc] initSheetWithTitles:titleArray andTitleColors:colors andDelegate:delegate];
}

+(instancetype)ActionSheetWithImageArray:(NSArray *)imgArray delegate:(id<TKFtSheetViewDelegate>)delegate{
    return [[self alloc] initSheetWithImgs:imgArray andDelegate:delegate];
}
-(instancetype)initSheetWithTitles:(NSArray *)titleArray andTitleColors:(NSArray *)colors andDelegate:(id<TKFtSheetViewDelegate>)delegate{
    self.titles = titleArray;
    self.colors = colors;
    self.actionSheetType = TKFtSheetTypeTypeTitle;
    _delegate = delegate;
    return [self initActionSheet];
}
-(instancetype)initSheetWithImgs:(NSArray *)imgArray andDelegate:(id<TKFtSheetViewDelegate>)delegate{
    self.actionSheetType = TKFtSheetTypeTypeImg;
    self.imgArray = imgArray;
    _delegate = delegate;
    return [self initActionSheet];
}


-(instancetype)initActionSheet{
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        //        [self setBackgroundColor:HEXColor(0x000000, 0.5)];
        [self addSubview:self.bgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnClick)];
        [self addGestureRecognizer:tap];
        [self.bgView addSubview:self.cancelBtn];
        [self.bgView addSubview:self.optionsBgView];
        
        float btnHeight = ft750AdaptationWidth(45);//按钮统一高度
        float lineHeight = ft750AdaptationWidth(0.5);//线高
        float optionViewLineHeight = 0;//线总高
        NSArray *arrayC = nil;
        switch (self.actionSheetType){
            case TKFtSheetTypeTypeImg:
                arrayC = self.imgArray;
                break;
            case TKFtSheetTypeTypeTitle:
                arrayC = self.titles;
                break;
            default:
                break;
        }
        //线永远比数组数少一个 如果数组等于0 线的数量不能等于-1 所以线高等于0
        if (arrayC.count == 0) {
            optionViewLineHeight = 0;
        }else{
            optionViewLineHeight = (arrayC.count-1) * lineHeight;
        }
        float optionBgWithCancelBtnMargin = ft750AdaptationWidth(4);//选项和按钮之间间距
        float optionBgViewHeight = btnHeight*arrayC.count + optionViewLineHeight;//选项View高度
        float btnAllAroundMargin = 0;// ft750AdaptationWidth(15);//按钮距离四周的间距
        self.bgViewHeigh = optionBgViewHeight+optionBgWithCancelBtnMargin+btnHeight;
        
        UIView *ruleView = [[UIView alloc]init];
        [ruleView addCssClass:@".ftSheetLineBackgroundColor"];
        [_bgView addSubview:ruleView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(@(optionBgViewHeight+optionBgWithCancelBtnMargin+btnHeight));
        }];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.bgView).offset(-btnAllAroundMargin);
            make.left.equalTo(self.bgView).offset(btnAllAroundMargin);
            make.height.equalTo(@(btnHeight));
        }];
        [ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgView);
            make.bottom.equalTo(_cancelBtn.mas_top);
            make.height.mas_equalTo(optionBgWithCancelBtnMargin);
        }];
        
        //选项背景View高度等于线总高+选项总高
        [_optionsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.cancelBtn.mas_top).offset(-optionBgWithCancelBtnMargin);
            make.right.equalTo(self.bgView).offset(-btnAllAroundMargin);
            make.left.equalTo(self.bgView).offset(btnAllAroundMargin);
            make.height.equalTo(@(optionBgViewHeight));
        }];
        
        
        for (int i = 0; i<arrayC.count; ++i) {
            
            UIView *backView = [[UIView alloc]init];
            backView.tag = 990+i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doClickIndex:)];
            [backView addGestureRecognizer:tap];
            [self.optionsBgView addSubview:backView];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_optionsBgView).offset((i*btnHeight+(i*lineHeight)));
                make.left.mas_equalTo(_optionsBgView.mas_left);
                make.right.mas_equalTo(_optionsBgView.mas_right);
                make.height.equalTo(@(btnHeight));
            }];
            
            UIButton *button = [UIButton new];
            button.backgroundColor = [UIColor clearColor];
            button.titleLabel.font = [UIFont ftk750AdaptationFont:18];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (self.actionSheetType == TKFtSheetTypeTypeTitle) {
                NSString *title = @"";
                NSAssert([self.titles[i] isKindOfClass:[NSString class]], @"标题数组里必须传入NSString类型对象" );
                title = self.titles[i];
                [button setTitle:title forState:UIControlStateNormal];
                [self.optionBtnArrayM addObject:button];
                
            }else if (self.actionSheetType == TKFtSheetTypeTypeImg){
                //过滤掉误传的非NSString类型的图片名数据
                NSAssert([self.imgArray[i] isKindOfClass:[NSString class]], @"图片名数组里必须传入NSString类型" );
                NSString *imageName = self.imgArray[i];
                [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            }
            
            [backView addSubview:button];
            
            CGFloat buttonW = [self.titles[i] sizeWithAttributes:@{NSFontAttributeName:[UIFont ftk750AdaptationFont:18]}].width+1;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_optionsBgView.mas_left).offset(ft750AdaptationWidth(15));
                make.centerY.equalTo(backView.mas_centerY);
                make.width.mas_equalTo(buttonW);
                make.height.equalTo(backView.mas_height);
            }];
            
            //选中图片
            UIImageView *checkImgeView = [[UIImageView alloc]init];
            [checkImgeView addCssClass:@".ftCheck"];
            [self.optionsBgView addSubview:checkImgeView];
            [self.imageViews addObject:checkImgeView];
            [checkImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_optionsBgView.mas_right).offset(ft750AdaptationWidth(-15));
                make.height.width.mas_equalTo(ft750AdaptationWidth(20));
                make.top.equalTo(button.mas_top).offset(ft750AdaptationWidth(10.5));
            }];
            
            //内容
            UILabel *contentLabel = [[UILabel alloc]init];
            contentLabel.text = self.contentArray[i];
            contentLabel.textAlignment = NSTextAlignmentLeft;
            contentLabel.font = [UIFont ftk750AdaptationFont:12];
            [contentLabel addCssClass:@".ftMiddleTextColor"];
            [backView addSubview:contentLabel];
            
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(button.mas_right).offset(ft750AdaptationWidth(20));
                make.centerY.equalTo(backView.mas_centerY);
            }];
            
            //当数组长度非0的时候 创建比数组少一的线
            if (i != self.titles.count-1) {
                UIView *line = [UIView new];
                [self.optionsBgView addSubview:line];
                [line setBackgroundColor:TKFT_HEXColor(0x000000, 0.1)];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(button.mas_bottom);
                    make.left.right.equalTo(_optionsBgView);
                    make.height.equalTo(@(lineHeight));
                }];
            }
            
        }
        [self optionColorSet];
    }
    
    return self;
}

-(void)setCancelDefaultColor:(UIColor *)cancelDefaultColor
{
    _cancelDefaultColor = cancelDefaultColor;
    [self.cancelBtn setTitleColor:cancelDefaultColor forState:UIControlStateNormal];
}
-(void)setOptionDefaultColor:(UIColor *)optionDefaultColor
{
    _optionDefaultColor = optionDefaultColor;
    [self optionColorSet];
}

-(void)setSelectedTitle:(NSString *)selectedTitle
{
    _selectedTitle = selectedTitle;
    [self optionTitleImgeView];
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  设置图片显示
 */
-(void)optionTitleImgeView
{
    for (int i = 0; i<self.optionBtnArrayM.count; ++i)
    {
        UIButton *button = self.optionBtnArrayM[i];
        UIImageView *imageView = self.imageViews[i];
        if ([button.currentTitle isEqualToString:self.selectedTitle])
        {
            imageView.hidden = NO;
        }else
        {
            imageView.hidden = YES;
        }
    }
}

/**
 *  @author yyf, 17-04
 *
 *  @brief  设置按钮字体颜色
 */
-(void)optionColorSet
{
    //颜色数组可以为空  为空默认黑色  不为空必须传UIColor类型
    if (self.optionBtnArrayM.count != 0) {
        UIColor *color;
        
        for (int i = 0; i<self.optionBtnArrayM.count; ++i) {
            UIButton *button = self.optionBtnArrayM[i];
            if (i<self.colors.count) {
                NSAssert([self.colors[i] isKindOfClass:[UIColor class]], @"标题颜色数组里必须传入UIColor类型对象" );
                color = self.colors[i];
            }else{
                
                if (self.optionDefaultColor != nil) {
                    color = self.optionDefaultColor;
                }else{
                    color = [UIColor blackColor];
                }
            }
            [button setTitleColor:color forState:UIControlStateNormal];
        }
    }
}

-(void)doClickIndex:(UITapGestureRecognizer *)tap
{
    for (int i = 0; i<self.optionBtnArrayM.count; ++i)
    {
        UITableView *imageView = self.imageViews[i];
        imageView.hidden = YES;
    }
    NSInteger selectIndex = tap.view.tag - 990;
    UIImageView *showImgeView = [self.imageViews objectAtIndex:selectIndex];
    showImgeView.hidden = NO;
    [self.delegate sheetViewClickWithActionSheet:self selectedTitle:self.titles[selectIndex]];
    [self dismissAlertView];
}
-(void)cancelBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(sheetViewClickCancellWithActionSheet:)]) {
        [self.delegate sheetViewClickCancellWithActionSheet:self];
    }
    
    [self dismissAlertView];
}

-(void)layerAnimationMakeWithUp:(BOOL)up
{
    [self.layer removeAllAnimations];
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    
    if (up == YES) {
        colorAnimation.duration = 0.3;
        colorAnimation.fromValue = (__bridge id _Nullable)([TKFT_HEXColor(0x000000, 0) CGColor]);
        colorAnimation.toValue = (__bridge id _Nullable)([TKFT_HEXColor(0x000000, 0.4) CGColor]);
    }else{
        colorAnimation.duration = 0.15;
        colorAnimation.fromValue = (__bridge id _Nullable)([TKFT_HEXColor(0x000000, 0.4) CGColor]);
        colorAnimation.toValue = (__bridge id _Nullable)([TKFT_HEXColor(0x000000, 0) CGColor]);
    }
    
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:colorAnimation forKey:@"colorAnimation"];
    
}
-(void)showSheetView
{
    _backWindow.hidden = NO;
    [self.backWindow addSubview:self];
    [self layerAnimationMakeWithUp:YES];
    [self.bgView.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-self.bgViewHeigh);
        }];
        [self.bgView.superview layoutIfNeeded];//强制绘制
    }];
}

- (void)hide{
    [self dismissAlertView];
}


-(void)dismissAlertView{
    
    [self layerAnimationMakeWithUp:NO];
    [UIView animateWithDuration:0.15 animations:^{
        [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
        }];
        [self.bgView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_backWindow resignKeyWindow];
        _backWindow.hidden = YES;
    }];
}
-(UIWindow *)backWindow{
    if (!_backWindow) {
        _backWindow=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel=UIWindowLevelAlert;
        [_backWindow becomeKeyWindow];
        [_backWindow makeKeyAndVisible];
    }
    return _backWindow;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn addCssClass:@".ftPickerTopViewBgColor"];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:TKFT_HEXColor(0x49515c, 1) forState:UIControlStateNormal];
        //        _cancelBtn.layer.cornerRadius = 3;
        //        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.titleLabel.font = [UIFont ftk750AdaptationFont:18];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
-(UIView *)optionsBgView{
    if (!_optionsBgView) {
        _optionsBgView = [UIView new];
        //        [_optionsBgView setBackgroundColor:HEXColor(0xffffff, 0.9)];
        [_optionsBgView addCssClass:@".ftPickerTopViewBgColor"];
        //        _optionsBgView.layer.cornerRadius = 3;
        //        _optionsBgView.layer.masksToBounds = YES;
    }
    return _optionsBgView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        [_bgView setBackgroundColor:[UIColor clearColor]];
    }
    return _bgView;
}
-(NSMutableArray *)optionBtnArrayM{
    if (!_optionBtnArrayM) {
        _optionBtnArrayM = [[NSMutableArray alloc] initWithCapacity:41];
    }
    return _optionBtnArrayM;
}

-(NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

-(NSMutableArray *)contentArray
{
    if (!_contentArray) {
        _contentArray = [NSMutableArray arrayWithObjects:@"滑点小，但成交概率最低",@"滑点较大，但成交概率最高(以涨停买或以跌停卖)",@"滑点较小，成交概率较低", nil];
    }
    
    return _contentArray;
}


@end

