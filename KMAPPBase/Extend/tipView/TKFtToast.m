//
//  TKFtToast.m
//  TKFtSDK
//
//  Created by 揭康伟 on 2018/10/25.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import "TKFtToast.h"


#define TKFt_MULTILINE_TEXTSIZE(text, fontSize, maxSize) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} \
context:nil].size: CGSizeZero;

@interface TKFtToast ()

@property (nonatomic, strong) UIView *superView; //父视图
@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UILabel *contentLabel; //可自动换行
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) TKFtToastPosition position;
@end
/** 提示文字字体大小 */
static const float  KLayerContentFontSize = 14;
/** 提示框默认宽度 */
static const CGFloat  KLayerViewWidth = 180;
/** 提示框停留时间 */
static const NSInteger  KTimeDuration = 2;
//布局间距
static const CGFloat loadingIndicatorViewTop = 20;
static const CGFloat contentLabelToIndicatorViewTop = 10;
static const CGFloat contentLabelLeftEdge = 20;
static const CGFloat contentLabelBottomEdge = 20;
//tag
static const CGFloat containViewTag = 123456789;

@implementation TKFtToast

- (instancetype)initContentView:(UIView *)view
{
    _superView = view;
    _position = TKFtToastPositionCenter;
    return [self init];
}

- (instancetype)initContentView:(UIView *)view position:(TKFtToastPosition)position
{
    _superView = view;
    _position = position;
    return [self init];
}

- (instancetype)init
{
    if (self = [super init]) {
        //初始化
        _layerViewWidth = _layerViewWidth>0?_layerViewWidth:KLayerViewWidth;
        _timeInterval = _timeInterval > 0?_timeInterval:KTimeDuration;
        _contentTextFontSize = _contentTextFontSize>0?_contentTextFontSize:KLayerContentFontSize;
        _contentLabelBottom = _contentLabelBottom >0?_contentLabelBottom:contentLabelBottomEdge;
        _contentLabelLeft = _contentLabelLeft >0?_contentLabelLeft:contentLabelLeftEdge;
        _containViewCustomY = 0;
        _isAdaptiveWidth = NO;
    }
    return self;
}

- (void)showLoading:(NSString *)text{
    
    // 判断是否是主线程展示的
    NSAssert([NSThread isMainThread], @"TKFtToast needs to be accessed on the main thread.");
    
    [self hideAllLayerViews:YES];
    if (!self.containView.superview&&_superView) {
        [_superView addSubview:self.containView];
        [_superView bringSubviewToFront:self.containView];
    }
    
    if (!_superView) {
        [[UIApplication sharedApplication].delegate.window addSubview:self.containView];
    }
    
    CGSize contentSize = TKFt_MULTILINE_TEXTSIZE(text,_contentTextFontSize,CGSizeMake(_layerViewWidth - 2*_contentLabelLeft, MAXFLOAT));

    CGFloat layerViewHeight = loadingIndicatorViewTop + 37 + contentLabelToIndicatorViewTop + contentSize.height + _contentLabelBottom;
    
    self.containView.alpha = 0;
    [self.containView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(layerViewHeight);
        make.width.mas_equalTo(_layerViewWidth);
        make.left.offset((TKFT_SCREEN_WIDTH -_layerViewWidth)/2);
        make.top.offset([self getContainViewY:_position layerViewHeight:layerViewHeight]);
    }];
    
    if (!self.loadingIndicatorView.superview) {
        [self.containView addSubview:self.loadingIndicatorView];
        [self.loadingIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.containView.centerX);
            make.top.equalTo(self.containView.mas_top).offset(loadingIndicatorViewTop);
        }];

    }
    
    if (!self.contentLabel.superview) {
        [self.containView addSubview:self.contentLabel];
        self.contentLabel.text = text;
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.containView.centerX);
            make.top.equalTo(self.loadingIndicatorView.mas_bottom).offset(contentLabelToIndicatorViewTop);
            make.left.equalTo(self.containView.mas_left).offset(_contentLabelLeft);
            make.right.equalTo(self.containView.mas_right).offset(-_contentLabelLeft);
        }];
    }
    
    [self.loadingIndicatorView startAnimating];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    self.containView.alpha = 1.0f;
    [UIView commitAnimations];
    
}

- (void)showContent:(NSString *)content
{
    // 判断是否是主线程展示的
    NSAssert([NSThread isMainThread], @"TKFtToast needs to be accessed on the main thread.");
    
    [self hideAllLayerViews:YES];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideDelayed) object:nil];
    
    if (!self.containView.superview && _superView) {
        [_superView addSubview:self.containView];
        [_superView bringSubviewToFront:self.containView];
    }
    if (!_superView) {
        [[UIApplication sharedApplication].delegate.window addSubview:self.containView];
    }
    CGSize contentSize = TKFt_MULTILINE_TEXTSIZE(content,_contentTextFontSize,CGSizeMake(_layerViewWidth - 2*_contentLabelLeft, MAXFLOAT));
    
    CGFloat layerViewHeight = 2*_contentLabelBottom + contentSize.height;
    self.containView.alpha = 0;
    
    CGFloat containViewY = 0;
    CGPoint superView_Point;
    if (_containViewCustomY > 0) {
        containViewY = _containViewCustomY;
        superView_Point = CGPointMake(0, containViewY);
    }else{
        containViewY = [self getContainViewY:_position layerViewHeight:layerViewHeight];
        //根据window标准转换坐标
        superView_Point = [self.containView.superview convertPoint:CGPointMake(0, containViewY) fromView:nil];
    }

    CGFloat containViewWidth = 0;
    CGFloat containViewHeight = 0;
    if (_isAdaptiveWidth) {
        //居中显示
        CGSize contentSize = TKFt_MULTILINE_TEXTSIZE(content,_contentTextFontSize,CGSizeMake(MAXFLOAT, 17));
        containViewWidth = contentSize.width + 2*_contentLabelLeft;
        containViewHeight = 2*_contentLabelBottom+16;
    }else{
        containViewWidth = _layerViewWidth;
        containViewHeight = layerViewHeight;
    }
    
    [self.containView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(containViewWidth);
        make.height.mas_equalTo(containViewHeight);
        make.left.offset((TKFT_SCREEN_WIDTH -containViewWidth)/2);
        make.top.offset(superView_Point.y);
    }];

    self.contentLabel.text = content;
    
    if (!self.contentLabel.superview) {
        [self.containView addSubview:self.contentLabel];
        if (_isAdaptiveWidth) {
            [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.containView.centerY);
                make.centerX.mas_equalTo(self.containView.centerX);
            }];
        }else{
            [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.containView.centerY);
                make.left.equalTo(self.containView.mas_left).offset(_contentLabelLeft);
                make.right.equalTo(self.containView.mas_right).offset(-_contentLabelLeft);
            }];
        }
    }

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    self.containView.alpha = 1.0f;
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideDelayed) withObject:nil afterDelay:_timeInterval];
}

- (void)showContent:(NSString *)content position:(TKFtToastPosition)position
{
    _position = position;
    [self showContent:content];
}

- (void)hideDelayed
{
    [self hide];
}
- (void)hide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    [self hideAllLayerViews:YES];
    [UIView commitAnimations];
}
- (void)hideAllLayerViews:(BOOL)hideAll
{
    if (hideAll) {
        NSArray *layerViews = [self allLayerViewsForView:_superView];
        for (UIView *layerView in layerViews) {
            [layerView removeFromSuperview];
        }
        NSArray *layerViews2 = [self allLayerViewsForView:[UIApplication sharedApplication].delegate.window];
        for (UIView *layerView in layerViews2) {
            [layerView removeFromSuperview];
        }
    }
}

- (NSArray *)allLayerViewsForView:(UIView *)view
{
    NSMutableArray *layerViews = @[].mutableCopy;
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if (aView.tag == containViewTag) {
            [layerViews addObject:aView];
        }
    }
    return [NSArray arrayWithArray:layerViews];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.loadingIndicatorView.superview) {
        [self hide];
    }
}

- (CGFloat)getContainViewY:(TKFtToastPosition)position layerViewHeight:(CGFloat)height
{
    CGFloat viewY;
    switch (position) {
        case TKFtToastPositionTop:
            viewY = STATUSBAR_HEIGHT + NAVBAR_HEIGHT + 15;
            break;
        case TKFtToastPositionCenter:
            viewY = (TKFT_SCREEN_HEIGHT -height)/2;
            break;
        case TKFtToastPositionBottom:
            viewY = TKFT_SCREEN_HEIGHT - height - TABBAR_HEIGHT - 20;
            break;
        default:
            break;
    }
    return viewY;
}

- (void)dealloc
{
    self.containView = nil;
    self.contentLabel = nil;
    self.loadingIndicatorView = nil;
    self.tapGesture = nil;
}
#pragma mark - setter and getter

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    self.containView.backgroundColor = backgroundColor;
}

- (void)setContentTextColor:(UIColor *)contentTextColor{
    _contentTextColor = contentTextColor;
    self.contentLabel.textColor = contentTextColor;
}

- (void)setContentTextFontSize:(NSInteger)contentTextFontSize{
    _contentTextFontSize = contentTextFontSize;
    self.contentLabel.font = [UIFont systemFontOfSize:contentTextFontSize];
}

- (void)setIsClickDisappear:(BOOL)isClickDisappear{
    _isClickDisappear = isClickDisappear;
    if (_isClickDisappear) {
        if (!self.tapGesture.view) {
            [_superView addGestureRecognizer:self.tapGesture];
        }
    }else{
        if (self.tapGesture.view) {
            [self.tapGesture.view removeGestureRecognizer:self.tapGesture];
            self.tapGesture = nil;
        }
    }
}

- (UIView *)containView{
    if (!_containView) {
        _containView = [[UIView alloc]init];
        _containView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
        _containView.tag = containViewTag;
        _containView.layer.cornerRadius = 10;
        _containView.layer.masksToBounds = YES;
    }
    return _containView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:_contentTextFontSize];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UIActivityIndicatorView *)loadingIndicatorView{
    if (!_loadingIndicatorView) {
        _loadingIndicatorView = [[UIActivityIndicatorView alloc]init];
        _loadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _loadingIndicatorView.hidesWhenStopped = YES;
    }
    return _loadingIndicatorView;
}
- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        _tapGesture.numberOfTapsRequired = 1;
    }
    return _tapGesture;
}



@end

