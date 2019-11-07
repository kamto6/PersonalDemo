//
//  NSTimer+BlockSupport.h
//  Reindeer
//
//  Created by 揭康伟 on 17/5/10.
//  Copyright © 2017年 Sword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (BlockSupport)
+ (NSTimer *)WeakTimerWithTimeInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

/**
 **block 避免nstimer 循环引用
 __weak XXClass *weakSelf = self;
 timer = [NSTimer xx_scheduledTimerWithTimeInterval:.5
 block:^{
     XXClass *strongSelf = weakSelf;
     [strongSelf doSomething];
 }repeats:YES];
 */
+ (NSTimer *)xx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;
@end
