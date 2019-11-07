//
//  NSTimer+BlockSupport.m
//  Reindeer
//
//  Created by 揭康伟 on 17/5/10.
//  Copyright © 2017年 Sword. All rights reserved.
//

#import "NSTimer+BlockSupport.h"


@implementation NSTimer (BlockSupport)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (NSTimer *)WeakTimerWithTimeInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    KMProxy *proxy = [KMProxy proxyWithTarget:aTarget];
    return [self timerWithTimeInterval:interval target:proxy selector:aSelector userInfo:userInfo repeats:yesOrNo];

}

+ (NSTimer *)xx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(xx_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)xx_blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if(block) {
        block();
    }
}
#pragma clang diagnostic pop
@end
