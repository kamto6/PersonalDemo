//
//  UIView+TKFtFrame.h
//  TKApp
//
//  Created by thinkive on 2018/3/15.
//  Copyright © 2018年 Pengxuyuan. All rights reserved.
//


@interface UIView (TKFtFrame)

@property (nonatomic, assign) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic, assign) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic, assign) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, assign) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic, assign) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic, assign) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic, assign) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic, assign) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic, assign) CGSize  size;        ///< Shortcut for frame.size.
/**
 * 是否包含该子view
 */
- (BOOL) containsSubView:(UIView *)subView;
/**
 * 是否包含该类的子view
 */
- (BOOL) containsSubViewOfClassType:(Class)aClass;
/**
 * 页面键盘显示时，添加单击手势关闭键盘
 */
- (void)setupForDismissKeyboard;

@end
