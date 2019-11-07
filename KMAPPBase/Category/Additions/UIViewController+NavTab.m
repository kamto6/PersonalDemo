//
//  NavigationBar.m
//  RongXin
//
//  Created by wdart on 13-12-16.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIViewController+NavTab.h"
#import "UIColor-Expanded.h"

///////////////////////

NSString * NTPathForBundleResource(NSString *relativePath) {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}

///////////////////////

UIImage * NTLoadImageFromBundle(NSString *imageName) {
    NSString *relativePath = [NSString stringWithFormat:@"NavTab.bundle/images/%@", imageName];
    NSString *path  = NTPathForBundleResource(relativePath);
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:data];
}


@implementation UIViewController(NavTab)



- (UIBarButtonItem *)_createBarButtonTitle:(NSString *)title target:(id)target action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 0, 50, 40);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_HEX(@"#2F383B") forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_HEX(@"#838384") forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    UIBarButtonItem *btnItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    return btnItem;
}


- (UIBarButtonItem *)_createBarButton:(NSString *)image target:(id)target action:(SEL)selector
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    if (image) {
        [btn setBackgroundImage:[UIImage imageNamed:image ] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
        if ([image isEqualToString:@"navbar-add.png"]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"navbar-add-press"] forState:UIControlStateHighlighted];
        }
    }
    [btn sizeToFit];
    btn.exclusiveTouch = TRUE;
    UIBarButtonItem *btnItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    return btnItem;
}


- (UIBarButtonItem *)_createBarButton:(NSString *)image target:(id)target action:(SEL)selector title:(NSString *)title
{
    UIFont *font = [UIFont systemFontOfSize:15];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:image];
    btn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [btn.titleLabel setFont:font];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(190, 220, 250) forState:UIControlStateHighlighted];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:img forState:UIControlStateHighlighted];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return btnItem;
}


- (UIBarButtonItem *)_createBarButton:(NSString *)image target:(id)target action:(SEL)selector title:(NSString *)title font:(UIFont *)font
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    if (image) {
        [btn setBackgroundImage:[UIImage imageNamed:image ] forState:UIControlStateNormal];
    }
    [btn.titleLabel setFont:font];
    [btn sizeToFit];
    UIBarButtonItem *btnItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    return btnItem;
}



- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)popToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)rightItemTitle:(NSString *)title target:(id)target action:(SEL)selector{

    
    UIBarButtonItem * FixSpaceBarbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    FixSpaceBarbutton.width = -18;
    UIBarButtonItem * barButton = [self _createBarButtonTitle:title
                                                                target:target
                                                                action:selector];
    [self.navigationItem setRightBarButtonItems:@[barButton,FixSpaceBarbutton]];
}



//放置右导航栏图片按钮，间距20
- (void)rightItemImage:(NSString *)imageName target:(id)target action:(SEL)selector{
    

    UIBarButtonItem * FixSpaceBarbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    FixSpaceBarbutton.width = 6;
    //右导航栏按钮，增加边距，正 往左移  并放置在首位
    //左导航栏按钮，增加边距，负 往右移  并放置在末尾
    
    UIBarButtonItem * barButton =[self _createBarButton:imageName
                                                           target:target
                                                           action:selector];
    
    [self.navigationItem setRightBarButtonItems:@[FixSpaceBarbutton,barButton]];
}

- (void)rightItemsImage:(NSArray *)images target:(id)target action:(SEL)selector Tag:(NSInteger)tag{
    
    UIBarButtonItem * FixSpaceBarbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    FixSpaceBarbutton.width = -20;
    
    NSMutableArray *rightBarButtons = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < images.count; i ++) {//19.5,18.5
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        button.tag = tag + i;
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        [rightBarButtons addObject:rightBarButton];
        if (i != images.count) {
            UIBarButtonItem * FixSpaceBarbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            FixSpaceBarbutton.width = 1; //13
            [rightBarButtons addObject:FixSpaceBarbutton];
        }
        
    }
    [rightBarButtons addObject:FixSpaceBarbutton];
    
    [self.navigationItem setRightBarButtonItems:rightBarButtons];
    
    
}
- (void)rightItemsTitle:(NSArray *)titles target:(id)target action:(SEL)selector Tag:(NSInteger)tag{
    
    self.navigationItem.rightBarButtonItems = nil;
    UIBarButtonItem * FixSpaceBarbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    FixSpaceBarbutton.width = -20;
    
    NSMutableArray *rightBarButtons = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < titles.count; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        button.tag = tag + i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_FONT forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        [rightBarButtons addObject:rightBarButton];
//        if (i != titles.count) {
//            UIBarButtonItem * FixSpaceBarbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//            FixSpaceBarbutton.width = 0;
//            [rightBarButtons addObject:FixSpaceBarbutton];
//        }
        
    }
    [rightBarButtons addObject:FixSpaceBarbutton];
    
    [self.navigationItem setRightBarButtonItems:rightBarButtons];
}
- (void)rightItemImage:(NSString *)imageName target:(id)target action:(SEL)selector title:(NSString *)title{
    self.navigationItem.rightBarButtonItem=[self _createBarButton:imageName
                                                           target:target
                                                           action:selector
                                                            title:title];
}

- (void)rightItemImage:(NSString *)imageName target:(id)target action:(SEL)selector title:(NSString *)title font:(UIFont *)font{
    self.navigationItem.leftBarButtonItem=[self _createBarButton:imageName
                                                          target:target
                                                          action:selector
                                                           title:title font:font];
}


- (void)leftItemTitle:(NSString *)title target:(id)target action:(SEL)selector{
    self.navigationItem.leftBarButtonItem=[self _createBarButtonTitle:title
                                                               target:target
                                                               action:selector];
}




- (void)leftItemImage:(NSString *)imageName target:(id)target action:(SEL)selector{
    UIView *leftItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65, 44)];

    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlight", imageName]] forState:UIControlStateHighlighted];
    btn.exclusiveTouch = TRUE;
    btn.frame = leftItemView.bounds;
    btn.contentEdgeInsets = UIEdgeInsetsMake(11, 18, 12, 34);
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [leftItemView addSubview:btn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 40, 44)];
    label.text = NSLocalizedString(@"rd_navigation_back_title", nil);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont PingFangRegularFontOfSize:16];
    [leftItemView addSubview:label];
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = leftItemView.bounds;
//    [backBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
//    [leftItemView addSubview:backBtn];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftItemView];

//    self.navigationItem.leftBarButtonItem=[self _createBarButton:imageName
//                                                          target:target
//                                                          action:selector];
}


- (void)leftItemImage:(NSString *)imageName target:(id)target action:(SEL)selector title:(NSString *)title{
    self.navigationItem.leftBarButtonItem=[self _createBarButton:imageName
                                                          target:target
                                                          action:selector
                                                           title:title];
}

- (void)leftItemImage:(NSString *)imageName target:(id)target action:(SEL)selector title:(NSString *)title font:(UIFont *)font{
    self.navigationItem.leftBarButtonItem=[self _createBarButton:imageName
                                                          target:target
                                                          action:selector
                                                           title:title font:font];
}

- (void)leftItemBack:(NSString *)imageName title:(NSString *)title{
    
    self.navigationItem.leftBarButtonItem=[self _createBarButton:imageName
                                                          target:self
                                                          action:@selector(pop)
                                                           title:title
                                           ];
    
}


- (void)leftBarButtonItem:(NSString *)imageName target:(id)target action:(SEL)selector {
    UIBarButtonItem * FixSpaceBarbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    FixSpaceBarbutton.width = -18;
    

    UIBarButtonItem *leftBarButton = [self _createBarButton:imageName
                                                                                           target:target
                                                                                           action:selector
                                                                                            title:nil
                                                                            ];;
    
    [self.navigationItem setLeftBarButtonItems:@[leftBarButton,FixSpaceBarbutton]];
}
- (void)leftBarButtonTitle:(NSString *)title target:(id)target action:(SEL)selector{
    UIBarButtonItem * FixSpaceBarbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    FixSpaceBarbutton.width = -18;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [self.navigationItem setLeftBarButtonItems:@[FixSpaceBarbutton,leftBarButton]];
}
- (void)clearRightItem{
    self.navigationItem.rightBarButtonItem=nil;
}


- (void)clearLeftItem{
    self.navigationItem.leftBarButtonItem=nil;
}


- (void)navBarHidden:(BOOL)hide
{
    [self.navigationController setNavigationBarHidden:hide];
}


- (void) tabBarHidden:(BOOL) hidden{
    float cHeight=self.tabBarController.tabBar.frame.size.height;
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, 480 - cHeight, view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480 - cHeight)];
            }
        }
    }
}


- (void) tabBarHiddenAnimated:(BOOL) hidden{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    float cHeight=self.tabBarController.tabBar.frame.size.height;
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, 480 - cHeight, view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480 - cHeight)];
            }
        }
    }
    [UIView commitAnimations];
    
}


@end

