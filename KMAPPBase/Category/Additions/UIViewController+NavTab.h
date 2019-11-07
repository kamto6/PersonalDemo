//
//  UIViewController+NavTab
//  RongXin
//
//  Created by wdart on 13-12-16.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController(NavTab)

- (UIBarButtonItem *)_createBarButton:(NSString *)image target:(id)target action:(SEL)selector;
/**
 *	@brief 返回到上一页面 等于[self.navigationController popViewControllerAnimated:YES];
 */
- (void)pop;


/**
 *	@brief 返回到Root页面 等于[self.navigationController popToRootViewControllerAnimated:YES];
 */
- (void)popToRoot;

//////////////////   常用   //////////////////

/**
 *	@brief	             创建导航条左返回按钮
 *	imageName 	     按钮图片
 * target 	             按钮点击事件响应对象
 *	selector 	         按钮点击事件响应方法
 * space                 距离左屏幕18
 */

- (void)leftBarButtonItem:(NSString *)imageName target:(id)target action:(SEL)selector ;
/**
 *	@brief	             创建导航条左返回按钮
 * title 	                 按钮标题
 * target 	             按钮点击事件响应对象
 *	selector 	         按钮点击事件响应方法
 * space                 距离左屏幕18
 */
- (void)leftBarButtonTitle:(NSString *)title target:(id)target action:(SEL)selector;

/**
 *	@brief	             创建导航条右按钮
 *	title 	                  按钮标题
 * target 	              按钮点击事件响应对象
 *	selector 	          按钮点击事件响应方法
 * space                  距离右屏幕18
 */
- (void)rightItemTitle:(NSString *)title target:(id)target action:(SEL)selector;



/**
 *	@brief	              创建导航条右按钮
 *	imageName 	      按钮图片
 * target 	              按钮点击事件响应对象
 *	selector 	          按钮点击事件响应方法
 * space                  距离右屏幕18
 */
- (void)rightItemImage:(NSString *)imageName target:(id)target action:(SEL)selector;


//////////////////   常用   //////////////////

/**
 *	@brief	创建导航条右按钮 两个
 *
 *	 	imageName 	按钮图片
 *		target 	    按钮点击事件响应对象
 *		selector 	按钮点击事件响应方法
 */

- (void)rightItemsImage:(NSArray *)images target:(id)target action:(SEL)selector Tag:(NSInteger)tag;
/**
 *  创建导航条右按钮 两个
 *
 *   titles   按钮文字
 *   target   按钮点击事件响应对象
 *   selector 按钮点击事件响应方法
 *   tag
 */
- (void)rightItemsTitle:(NSArray *)titles target:(id)target action:(SEL)selector Tag:(NSInteger)tag;

/**
 *	@brief	创建导航条左按钮
 *
 *	 	title 	按钮标题
 *	 	target 	按钮点击事件响应对象
 *	 	selector 	按钮点击事件响应方法
 */
- (void)leftItemTitle:(NSString *)title target:(id)target action:(SEL)selector;




/**
 *	@brief	创建导航条左按钮
 *
 *	 	imageName 	按钮图片
 *	 	target 	按钮点击事件响应对象
 *	 	selector 	按钮点击事件响应方法
*      默认间距
 */
- (void)leftItemImage:(NSString *)imageName target:(id)target action:(SEL)selector;



/**
 *	@brief	创建导航条左按钮
 *
 *	 	imageName 	按钮图片
 *	 	target 	按钮点击事件响应对象
 *	 	selector 	按钮点击事件响应方法
 *	 	title 	按钮标题
 *     默认间距
 */
- (void)leftItemImage:(NSString *)imageName target:(id)target action:(SEL)selector title:(NSString *)title;


/**
 *	@brief	创建导航条左按钮
 *
 *	 	imageName 	按钮图片
 *	 	target 	按钮点击事件响应对象
 *	 	selector 	按钮点击事件响应方法
 *	 	title 	按钮标题
 *	 	font 	按钮字体
 *       默认间距
 */
- (void)leftItemImage:(NSString *)imageName target:(id)target action:(SEL)selector title:(NSString *)title font:(UIFont *)font;





/**
 *	@brief	创建导航条左返回按钮
 *
 *	 	imageName 	按钮图片
 *	 	title 	按钮标题
 */
- (void)leftItemBack:(NSString *)imageName title:(NSString *)title;


/**
 *	@brief	创建导航条左返回按钮
 *
 *	 	imageName 	按钮图片
 *
 */




/**
 *	@brief	清除右按钮
 */
- (void)clearRightItem;



/**
 *	@brief	清除左按钮
 */
- (void)clearLeftItem;



/**
 *	@brief	显示和隐藏导航条
 *
 *	 	hide 	YES隐藏 NO显示
 */
- (void)navBarHidden:(BOOL)hide;




/**
 *	@brief	显示和隐藏选项卡
 *
 *	 	hide 	YES隐藏 NO显示
 */
- (void)tabBarHidden:(BOOL)hide;



/**
 *	@brief	动画显示和隐藏选项卡
 *
 *	 	hidden 	YES隐藏 NO显示
 */

- (void) tabBarHiddenAnimated:(BOOL) hidden;


@end
