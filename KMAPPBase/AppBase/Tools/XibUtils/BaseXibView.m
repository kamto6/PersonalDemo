//
//  XibView.m
//  Reindeer
//
//  Created by Sword on 1/31/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import "BaseXibView.h"
#import "XibViewUtils.h"

#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@implementation BaseXibView

- (void)dealloc
{
    ITTDINFO(@"%@ is dealloced!", [self class]);
}

+ (id)loadFromXib
{
    return [XibViewUtils loadViewFromXibNamed:NSStringFromClass([self class])];
}


- (UIView*)keyboardView
{
    if (IOS7_OR_LATER) {
        UIView *keyboardView = [[[[[UIApplication sharedApplication] windows] lastObject] subviews] firstObject];
        return keyboardView;
    }
    else {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *window in [windows reverseObjectEnumerator]) {
            for (UIView *view in [window subviews]) {
                // UIPeripheralHostView is used from iOS 4.0, UIKeyboard was used in previous versions:
                if (!strcmp(object_getClassName(view), "UIPeripheralHostView") || !strcmp(object_getClassName(view), "UIKeyboard")) {
                    return view;
                }
            }
        }
        return nil;
    }
}

- (UIView*)viewForView:(UIView *)view
{
    UIView *keyboardView = [self keyboardView];
    if (keyboardView) {
        view = keyboardView.superview;
    }
    
    return view;
}
@end
