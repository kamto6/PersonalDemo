//
//  UIScrollView+UITouchEvent.m
//  Reindeer
//
//  Created by 揭康伟 on 16/2/3.
//  Copyright © 2016年 Sword. All rights reserved.
//

#import "UIScrollView+UITouchEvent.h"

@implementation UIScrollView (UITouchEvent)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
@end
