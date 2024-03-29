//
//  TKFtPopoverView.h
//  TKApp
//
//  Created by thinkive on 2018/3/14.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TKFtPopoverPosition) {
    TKFtPopoverPositionUp = 1,
    TKFtPopoverPositionDown,
};

typedef NS_ENUM(NSUInteger, TKFtPopoverMaskType) {
    TKFtPopoverMaskTypeBlack,
    TKFtPopoverMaskTypeNone,  // overlay does not respond to touch
};

@interface TKFtPopoverView : UIView

+ (instancetype)popover;

/**
 *  The contentView positioned in container, default is zero;
 *  //边距
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 *  If the popover is stay up or down the showPoint
 */
@property (nonatomic, assign, readonly) TKFtPopoverPosition popoverPosition;

/**
 *  The popover arrow size, default is {10.0, 10.0};
 *  弹出框三角形的大小
 */
@property (nonatomic, assign) CGSize arrowSize;

/**
 *  The popover corner radius, default is 7.0;
 *  半径
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *  The popover animation show in duration, default is 0.4;
 *  淡入时间
 */
@property (nonatomic, assign) CGFloat animationIn;

/**
 *  The popover animation dismiss duration, default is 0.3;
 *  淡出时间
 */
@property (nonatomic, assign) CGFloat animationOut;

/**
 *  If the drop in animation using spring animation, default is YES;
 *  弹簧
 */
@property (nonatomic, assign) BOOL animationSpring;

/**
 *  The background of the popover, default is DXPopoverMaskTypeBlack;
 */
@property (nonatomic, assign) TKFtPopoverMaskType maskType;

/**
 *  If maskType does not satisfy your need, use blackoverylay to control the touch
 * event(userInterfaceEnabled) for
 * background color
 */
@property (nonatomic, strong, readonly) UIControl *blackOverlay;

/**
 *  If the popover has the shadow behind it, default is YES, if you wanna custom the shadow, set it
 * by
 * popover.layer.shadowColor, shadowOffset, shadowOpacity, shadowRadius
 * 展示边缘阴影
 */
@property (nonatomic, assign) BOOL applyShadow;

/**
 *  when you using atView show API, this value will be used as the distance between popovers'arrow
 * and atView. Note:
 * this value is invalid when popover show using the atPoint API
 */
@property (nonatomic, assign) CGFloat betweenAtViewAndArrowHeight;

/**
 * Decide the nearest edge between the containerView's border and popover, default is 4.0
 */
@property (nonatomic, assign) CGFloat sideEdge;

/**
 *  The callback when popover did show in the containerView
 */
@property (nonatomic, copy) dispatch_block_t didShowHandler;

/**
 *  The callback when popover did dismiss in the containerView;
 */
@property (nonatomic, copy) dispatch_block_t didDismissHandler;

//显示箭头
@property (nonatomic,getter=isShowArrow) BOOL showArrow;


/**
 *  Show API
 *
 *  point         the point in the container coordinator system.
 *  position      stay up or stay down from the showAtPoint
 *  contentView   the contentView to show
 *  containerView the containerView to contain
 */
- (void)showAtPoint:(CGPoint)point
     popoverPostion:(TKFtPopoverPosition)position
    withContentView:(UIView *)contentView
             inView:(UIView *)containerView;

/**
 *  Lazy show API        The show point will be caluclated for you, try it!
 *
 *  atView        The view to show at
 *  position      stay up or stay down from the atView, if up or down size is not enough for
 *  contentView, then it
 *  will be set correctly auto.
 *  contentView   the contentView to show
 *  containerView the containerView to contain
 */
- (void)showAtView:(UIView *)atView
    popoverPostion:(TKFtPopoverPosition)position
   withContentView:(UIView *)contentView
            inView:(UIView *)containerView;

/**
 *  Lazy show API        The show point and show position will be caluclated for you, try it!
 *
 *  atView        The view to show at
 *  contentView   the contentView to show
 *  containerView the containerView to contain
 */
- (void)showAtView:(UIView *)atView
   withContentView:(UIView *)contentView
            inView:(UIView *)containerView;

/**
 *  Lazy show API        The show point and show position will be caluclated for you, using
 *  application's keyWindow as
 *  containerView, try it!
 *
 *  atView        The view to show at
 *  contentView   the contentView to show
 */
- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView;

- (void)showAtView:(UIView *)atView withText:(NSAttributedString *)abs;
- (void)showAtView:(UIView *)atView withText:(NSAttributedString *)abs inView:(UIView *)container;

- (void)dismiss;

- (void)doNoAnimationDismiss;

@end
