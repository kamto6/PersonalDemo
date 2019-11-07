//
//  TKFtPopoverView.m
//  TKApp
//
//  Created by thinkive on 2018/3/14.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import "TKFtPopoverView.h"

#define TKFTDEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)


@interface TKFtPopoverView ()

@property (nonatomic, strong, readwrite) UIControl *blackOverlay;//蒙板
@property (nonatomic, weak) UIView *containerView;//容器
@property (nonatomic, assign, readwrite) TKFtPopoverPosition popoverPosition;//方向
@property (nonatomic, assign) CGPoint arrowShowPoint;//弹层起始坐标点
@property (nonatomic, weak) UIView *contentView;//内容
@property (nonatomic, assign) CGRect contentViewFrame;//内容范围
@property (nonatomic, strong) UIColor *contentColor;//内容view的颜色

@end

@implementation TKFtPopoverView{
    BOOL _setNeedsReset;//是否需要重绘
}

+ (instancetype)popover {
    return [[TKFtPopoverView alloc] init];
}

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.arrowSize = CGSizeMake(11.0, 9.0);
    self.cornerRadius = 5.0;
    self.backgroundColor = [UIColor whiteColor];
    self.animationIn = 0.4;
    self.animationOut = 0.3;
    self.animationSpring = YES;
    self.sideEdge = 10.0;
    self.maskType = TKFtPopoverMaskTypeBlack;
    self.betweenAtViewAndArrowHeight = 4.0;
    self.applyShadow = YES;
    self.showArrow = YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    self.contentColor = backgroundColor;
}


- (void)setApplyShadow:(BOOL)applyShadow {
    _applyShadow = applyShadow;
    if (_applyShadow) {
        //阴影颜色
        self.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9].CGColor;
        //shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOffset = CGSizeMake(0, 2);
        //阴影透明度，默认0
        self.layer.shadowOpacity = 0.5;
        //阴影半径，默认3
        self.layer.shadowRadius = 2.0;
    } else {
        self.layer.shadowColor = nil;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.0;
        self.layer.shadowRadius = 0.0;
    }
}

- (void)setShowArrow:(BOOL)showArrow
{
    _showArrow = showArrow;
}

//设置self的位子，大小
- (void)_setup {
    if (_setNeedsReset == NO) {
        return;
    }
    
    CGRect frame = self.contentViewFrame;
    //获取contentView的X轴中心点
    CGFloat frameMidx = self.arrowShowPoint.x - CGRectGetWidth(frame) * 0.5;
    frame.origin.x = frameMidx;
    
    // we don't need the edge now
    CGFloat sideEdge = 0.0;
    if (CGRectGetWidth(frame) < CGRectGetWidth(self.containerView.frame)) {
        sideEdge = self.sideEdge;
    }
    
    // righter the edge
    CGFloat outerSideEdge = CGRectGetMaxX(frame) - CGRectGetWidth(self.containerView.bounds);
    if (outerSideEdge > 0) {
        frame.origin.x -= (outerSideEdge + sideEdge);
    } else {
        if (CGRectGetMinX(frame) < 0) {
            frame.origin.x += ABS(CGRectGetMinX(frame)) + sideEdge;
        }
    }
    
    //重新设置self的起点坐标
    self.frame = frame;
    
    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toView:self];
    
    CGPoint anchorPoint;
    switch (self.popoverPosition) {
        case TKFtPopoverPositionDown: {
            frame.origin.y = self.arrowShowPoint.y;
            anchorPoint = CGPointMake(arrowPoint.x / CGRectGetWidth(frame), 0);
        } break;
        case TKFtPopoverPositionUp: {
            frame.origin.y = self.arrowShowPoint.y - CGRectGetHeight(frame) - self.arrowSize.height;
            anchorPoint = CGPointMake(arrowPoint.x / CGRectGetWidth(frame), 1);
        } break;
    }
    
    CGPoint lastAnchor = self.layer.anchorPoint;
    self.layer.anchorPoint = anchorPoint;
    self.layer.position = CGPointMake(
                                      self.layer.position.x + (anchorPoint.x - lastAnchor.x) * self.layer.bounds.size.width,
                                      self.layer.position.y + (anchorPoint.y - lastAnchor.y) * self.layer.bounds.size.height);
    //重新设置高度
    frame.size.height += self.arrowSize.height;
    self.frame = frame;
    _setNeedsReset = NO;
}

- (void)showAtPoint:(CGPoint)point
     popoverPostion:(TKFtPopoverPosition)position
    withContentView:(UIView *)contentView
             inView:(UIView *)containerView {
    //获取传进来View的宽度
    CGFloat contentWidth = CGRectGetWidth(contentView.bounds);
    //获取传进来View的高度
    CGFloat contentHeight = CGRectGetHeight(contentView.bounds);
    //获取传进来容器View的宽度
    CGFloat containerWidth = CGRectGetWidth(containerView.bounds);
    //获取传进来容器View的高度
    CGFloat containerHeight = CGRectGetHeight(containerView.bounds);
    
    NSAssert(contentWidth > 0 && contentHeight > 0,
             @"DXPopover contentView bounds.size should not be zero");
    NSAssert(containerWidth > 0 && containerHeight > 0,
             @"DXPopover containerView bounds.size should not be zero");
    NSAssert(containerWidth >= (contentWidth + self.contentInset.left + self.contentInset.right),
             @"DXPopover containerView width %f should be wider than contentViewWidth %f & "
             @"contentInset %@",
             containerWidth, contentWidth, NSStringFromUIEdgeInsets(self.contentInset));
    
    if (!self.blackOverlay) {
        self.blackOverlay = [[UIControl alloc] init];
        //自动适应父视图的高宽
        self.blackOverlay.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    self.blackOverlay.frame = containerView.bounds;
    
    //设置blackOverlay 的背景色
    UIColor *maskColor;
    switch (self.maskType) {
        case TKFtPopoverMaskTypeBlack:
            maskColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            break;
        case TKFtPopoverMaskTypeNone: {
            maskColor = [UIColor clearColor];
            self.blackOverlay.userInteractionEnabled = NO;
        } break;
        default:
            break;
    }
    
    self.blackOverlay.backgroundColor = maskColor;
    //容器添加blackOverlay
    [containerView addSubview:self.blackOverlay];
    [self.blackOverlay addTarget:self
                          action:@selector(dismiss)
                forControlEvents:UIControlEventTouchUpInside];
    //容器
    self.containerView = containerView;
    //内容
    self.contentView = contentView;
    //方向
    self.popoverPosition = position;
    //坐标点
    self.arrowShowPoint = point;
    
    //把contentView 的坐标移到containerView上
    CGRect contentFrame = [containerView convertRect:contentView.frame toView:containerView];
    BOOL isEdgeZero = UIEdgeInsetsEqualToEdgeInsets(self.contentInset, UIEdgeInsetsZero);
    // if the edgeInset is not be setted, we use need set the contentViews cornerRadius
    //判断内边距
    if (isEdgeZero) {
        self.contentView.layer.cornerRadius = self.cornerRadius;
        self.contentView.layer.masksToBounds = YES;
    } else {
        contentFrame.size.width += self.contentInset.left + self.contentInset.right;
        contentFrame.size.height += self.contentInset.top + self.contentInset.bottom;
    }
    
    self.contentViewFrame = contentFrame;
    [self show];
}

- (void)showAtView:(UIView *)atView
    popoverPostion:(TKFtPopoverPosition)position
   withContentView:(UIView *)contentView
            inView:(UIView *)containerView {
    CGFloat betweenArrowAndAtView = self.betweenAtViewAndArrowHeight;
    CGFloat contentViewHeight = CGRectGetHeight(contentView.bounds);
    CGRect atViewFrame = [containerView convertRect:atView.frame toView:containerView];
    
    BOOL upCanContain = CGRectGetMinY(atViewFrame) >= contentViewHeight + betweenArrowAndAtView;
    BOOL downCanContain =
    (CGRectGetHeight(containerView.bounds) -
     (CGRectGetMaxY(atViewFrame) + betweenArrowAndAtView)) >= contentViewHeight;
    NSAssert((upCanContain || downCanContain),
             @"DXPopover no place for the popover show, check atView frame %@ "
             @"check contentView bounds %@ and containerView's bounds %@",
             NSStringFromCGRect(atViewFrame), NSStringFromCGRect(contentView.bounds),
             NSStringFromCGRect(containerView.bounds));
    
    CGPoint atPoint = CGPointMake(CGRectGetMidX(atViewFrame), 0);
    TKFtPopoverPosition popoverPosition;
    if (upCanContain) {
        popoverPosition = TKFtPopoverPositionUp;
        atPoint.y = CGRectGetMinY(atViewFrame) - betweenArrowAndAtView;
    } else {
        popoverPosition = TKFtPopoverPositionDown;
        atPoint.y = CGRectGetMaxY(atViewFrame) + betweenArrowAndAtView;
    }
    
    // if they are all yes then it shows in the bigger container
    if (upCanContain && downCanContain) {
        CGFloat upHeight = CGRectGetMinY(atViewFrame);
        CGFloat downHeight = CGRectGetHeight(containerView.bounds) - CGRectGetMaxY(atViewFrame);
        BOOL useUp = upHeight > downHeight;
        
        // except you set outsider
        if (position != 0) {
            useUp = position == TKFtPopoverPositionUp ? YES : NO;
        }
        if (useUp) {
            popoverPosition = TKFtPopoverPositionUp;
            atPoint.y = CGRectGetMinY(atViewFrame) - betweenArrowAndAtView;
        } else {
            popoverPosition = TKFtPopoverPositionDown;
            atPoint.y = CGRectGetMaxY(atViewFrame) + betweenArrowAndAtView;
        }
    }
    
    [self showAtPoint:atPoint popoverPostion:popoverPosition withContentView:contentView inView:containerView];
}

- (void)showAtView:(UIView *)atView
   withContentView:(UIView *)contentView
            inView:(UIView *)containerView {
    [self showAtView:atView popoverPostion:0 withContentView:contentView inView:containerView];
}

- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView {
    [self showAtView:atView
     withContentView:contentView
              inView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

//确定contentView的大小和位子及和父视图的关系
- (void)show {
    _setNeedsReset = YES;
    [self setNeedsDisplay];
    
    CGRect contentViewFrame = self.contentView.frame;
    CGFloat originY = 0.0;
    
    //需要箭头，则加入箭头
    if (self.showArrow)
    {
        if (self.popoverPosition == TKFtPopoverPositionDown) {
            originY = self.arrowSize.height;
        }
    }
    
    contentViewFrame.origin.x = self.contentInset.left;
    contentViewFrame.origin.y = originY + self.contentInset.top;
    
    self.contentView.frame = contentViewFrame;
    [self addSubview:self.contentView];
    [self.containerView addSubview:self];
    
    if (self.showArrow)
    {
        self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    }else
    {
        self.transform = CGAffineTransformMakeScale(1, 0.0);
    }
    
    if (self.animationSpring) {
        [UIView animateWithDuration:self.animationIn
                              delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:3
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             if (self.didShowHandler) {
                                 self.didShowHandler();
                             }
                         }];
    } else {
        [UIView animateWithDuration:self.animationIn
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             if (self.didShowHandler) {
                                 self.didShowHandler();
                             }
                         }];
    }
}

- (void)showAtView:(UIView *)atView withText:(NSAttributedString *)abs {
    [self showAtView:atView
            withText:abs
              inView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

- (void)showAtView:(UIView *)atView withText:(NSAttributedString *)abs inView:(UIView *)container {
    UILabel *textLabel = [UILabel new];
    textLabel.attributedText = abs;
    [textLabel sizeToFit];
    textLabel.backgroundColor = [UIColor clearColor];
    self.contentInset = UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0);
    [self showAtView:atView withContentView:textLabel inView:container];
}

- (void)dismiss {
    if (self.superview) {
        
        //交易资金详情页币种选择，弹框消失发通知
        [[NSNotificationCenter defaultCenter]postNotificationName:TKFtFUNDDISMISS object:nil];
        
        [UIView animateWithDuration:self.animationOut
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             //没有箭头不需要收到一点
                             if (self.showArrow)
                             {
                                 self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                             }else
                             {
                                 self.transform = CGAffineTransformMakeScale(1, 0.0001);
                             }
                         }
                         completion:^(BOOL finished) {
                             [self.contentView removeFromSuperview];
                             [self.blackOverlay removeFromSuperview];
                             [self removeFromSuperview];
                             if (self.didDismissHandler) {
                                 self.didDismissHandler();
                             }
                         }];
    }
}


- (void)doNoAnimationDismiss
{
    if (self.superview)
    {
        //        [UIView animateWithDuration:0.1 animations:^{
        //            self.alpha = 0;
        //            self.blackOverlay.alpha = 0;
        //        } completion:^(BOOL finished) {
        self.alpha = 0;
        [self.contentView removeFromSuperview];
        [self.blackOverlay removeFromSuperview];
        [self removeFromSuperview];
        //        }];
    }
}

- (void)drawRect:(CGRect)rect {
    
    if (!self.showArrow)
    {
        return;
    }
    
    UIBezierPath *arrow = [[UIBezierPath alloc] init];
    //获取颜色
    UIColor *contentColor = self.contentColor;
    // the point in the ourself view coordinator
    //containerView 把arrowShowPoint转换到self得坐标系中来，以self的坐标为准，返回arrowShowPoint以self坐标的点
    //arrowShowPoint:(x = 250, y = 205)
    //self = (30 205; 280 359)
    //arrowPoint    (220,0)
    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toView:self];
    //弹出框三角形的大小
    CGSize arrowSize = self.arrowSize;
    
    //半径
    CGFloat cornerRadius = self.cornerRadius;
    CGSize size = self.bounds.size;
    
    switch (self.popoverPosition) {
        case TKFtPopoverPositionDown: {
            [arrow moveToPoint:CGPointMake(arrowPoint.x, 0)];
            [arrow
             addLineToPoint:CGPointMake(arrowPoint.x + arrowSize.width * 0.5, arrowSize.height)];
            [arrow addLineToPoint:CGPointMake(size.width - cornerRadius, arrowSize.height)];
            //center：圆心的坐标
            //radius：半径
            //startAngle：起始的弧度
            //endAngle：圆弧结束的弧度
            //clockwise：YES为顺时针，No为逆时针
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius,
                                                arrowSize.height + cornerRadius)
                             radius:cornerRadius
                         startAngle:TKFTDEGREES_TO_RADIANS(270.0)
                           endAngle:TKFTDEGREES_TO_RADIANS(0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width, size.height - cornerRadius)];
            [arrow
             addArcWithCenter:CGPointMake(size.width - cornerRadius, size.height - cornerRadius)
             radius:cornerRadius
             startAngle:TKFTDEGREES_TO_RADIANS(0)
             endAngle:TKFTDEGREES_TO_RADIANS(90.0)
             clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, size.height)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, size.height - cornerRadius)
                             radius:cornerRadius
                         startAngle:TKFTDEGREES_TO_RADIANS(90)
                           endAngle:TKFTDEGREES_TO_RADIANS(180.0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, arrowSize.height + cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, arrowSize.height + cornerRadius)
                             radius:cornerRadius
                         startAngle:TKFTDEGREES_TO_RADIANS(180.0)
                           endAngle:TKFTDEGREES_TO_RADIANS(270)
                          clockwise:YES];
            [arrow
             addLineToPoint:CGPointMake(arrowPoint.x - arrowSize.width * 0.5, arrowSize.height)];
        } break;
        case TKFtPopoverPositionUp: {
            [arrow moveToPoint:CGPointMake(arrowPoint.x, size.height)];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x - arrowSize.width * 0.5,
                                              size.height - arrowSize.height)];
            [arrow addLineToPoint:CGPointMake(cornerRadius, size.height - arrowSize.height)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius,
                                                size.height - arrowSize.height - cornerRadius)
                             radius:cornerRadius
                         startAngle:TKFTDEGREES_TO_RADIANS(90.0)
                           endAngle:TKFTDEGREES_TO_RADIANS(180.0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, cornerRadius)
                             radius:cornerRadius
                         startAngle:TKFTDEGREES_TO_RADIANS(180.0)
                           endAngle:TKFTDEGREES_TO_RADIANS(270.0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width - cornerRadius, 0)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius, cornerRadius)
                             radius:cornerRadius
                         startAngle:TKFTDEGREES_TO_RADIANS(270.0)
                           endAngle:TKFTDEGREES_TO_RADIANS(0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width,
                                              size.height - arrowSize.height - cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius,
                                                size.height - arrowSize.height - cornerRadius)
                             radius:cornerRadius
                         startAngle:TKFTDEGREES_TO_RADIANS(0)
                           endAngle:TKFTDEGREES_TO_RADIANS(90.0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x + arrowSize.width * 0.5,
                                              size.height - arrowSize.height)];
        } break;
    }
    //设置填充色
    [contentColor setFill];
    //填充路径里面的颜色
    [arrow fill];
}

- (void)layoutSubviews {
    [self _setup];
}
/**
 *  @author 刘贝, 16-11-24 17:11:14
 *
 *  @brief 设置透明度动画
 *
 *  needView  需要设置视图
 *  fromValue 开始透明值
 *  toValue   结束透明值
 */
- (void)doSetUpOpacityAnimation:(UIView *)needView
                     startValue:(CGFloat)fromValue
                       endValue:(CGFloat)toValue
{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    opacityAnimation.toValue = [NSNumber numberWithFloat:toValue];
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.duration = self.animationIn;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.repeatCount = 1;
    [needView.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
