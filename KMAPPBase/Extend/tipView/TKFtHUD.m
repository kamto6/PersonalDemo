//
//  TKFtHUD.m
//  TKFtSDK
//
//  Created by 揭康伟 on 2018/10/25.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import "TKFtHUD.h"

#define TKFt_MULTILINE_TEXTSIZE(text, fontSize, maxSize) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} \
context:nil].size: CGSizeZero;

@interface TKFtHUD ()

@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UILabel *contentLabel; //可自动换行
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIView *bgView;
@end

static const float  KLayerContentFontSize = 16;
static const CGFloat  KLayerViewWidth = 180;
//布局间距
static const CGFloat loadingIndicatorViewTop = 20;
static const CGFloat contentLabelToIndicatorViewTop = 10;
static const CGFloat contentLabelLeftEdge = 20;
static const CGFloat contentLabelBottomEdge = 20;

@implementation TKFtHUD

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = [[[UIApplication sharedApplication] delegate] window].frame;
        _layerViewWidth = _layerViewWidth>0?_layerViewWidth:KLayerViewWidth;
        
    }
    return self;
}

- (void)showLoading:(NSString *)text{
    
    [self hideAllLayerViews:YES];
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if (!self.superview) {
        [keyWindow addSubview:self];
    }
    if (!_isClickMaskDisapper) {
        if (!self.bgView.superview) {
            [self addSubview:self.bgView];
        }
    }
    if (!self.containView.superview) {
        [self addSubview:self.containView];
    }
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset((TKFT_SCREEN_WIDTH -KLayerViewWidth)/2);
        make.width.height.mas_equalTo(_layerViewWidth);
    }];
    
    self.containView.alpha = 0;
    
    if (!self.loadingIndicatorView.superview) {
        [self.containView addSubview:self.loadingIndicatorView];
        [self.loadingIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.containView.centerX);
            make.top.equalTo(self.containView.mas_top).offset(loadingIndicatorViewTop);
        }];
    }
    [self.loadingIndicatorView layoutIfNeeded];
    if (!self.contentLabel.superview) {
        [self.containView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.containView.centerX);
            make.top.equalTo(self.loadingIndicatorView.mas_bottom).offset(contentLabelToIndicatorViewTop);
            make.left.equalTo(self.containView.mas_left).offset(contentLabelLeftEdge);
            make.right.equalTo(self.containView.mas_right).offset(-contentLabelLeftEdge);
        }];
    }
    [self.contentLabel layoutIfNeeded];
    self.contentLabel.text = text;
    self.contentLabel.numberOfLines = 0;
    CGSize contentSize = TKFt_MULTILINE_TEXTSIZE(text,KLayerContentFontSize,CGSizeMake(KLayerViewWidth - 2*contentLabelLeftEdge, MAXFLOAT));
    CGFloat layerViewHeight = loadingIndicatorViewTop + CGRectGetHeight(self.loadingIndicatorView.frame) + contentLabelToIndicatorViewTop + contentSize.height + contentLabelBottomEdge;
    
    [self.containView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset((TKFT_SCREEN_HEIGHT -KLayerViewWidth)/2);
        make.height.mas_equalTo(layerViewHeight);
    }];
    [self.containView layoutIfNeeded];
    
    [self.loadingIndicatorView startAnimating];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    self.containView.alpha = 1.0f;
    [UIView commitAnimations];
    
}

- (void)hideLoading{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideAllLayerViews:YES];
        [self.loadingIndicatorView stopAnimating];
    });
    [UIView commitAnimations];
}
- (void)hideAllLayerViews:(BOOL)hideAll{
    if (hideAll) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        NSArray *layerViews = [self allLayerViewsForView:keyWindow];
        for (TKFtHUD *hud in layerViews) {
            [hud removeFromSuperview];
        }
    }
}

- (NSArray *)allLayerViewsForView:(UIView *)view {
    NSMutableArray *layerViews = @[].mutableCopy;
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:[TKFtHUD class]]) {
            [layerViews addObject:aView];
        }
    }
    return [NSArray arrayWithArray:layerViews];
}
- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    [self hideLoading];
}

- (void)dealloc{
    
    self.containView = nil;
    self.contentLabel = nil;
    self.loadingIndicatorView = nil;
    self.tapGesture = nil;
}
#pragma mark - setter and getter



- (UIView *)containView{
    if (!_containView) {
        _containView = [[UIView alloc]init];
        _containView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
        _containView.layer.cornerRadius = 4;
        _containView.layer.masksToBounds = YES;
    }
    return _containView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:KLayerContentFontSize];
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

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        if (!self.tapGesture.view) {
            [_bgView addGestureRecognizer:self.tapGesture];
        }
    }
    return _bgView;
}
@end

