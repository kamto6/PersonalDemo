//
//  TKFtUnEditingTextField.m
//  TKFtSDK
//
//  Created by thinkive on 2018/6/1.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import "TKFtUnEditingTextField.h"

@implementation TKFtUnEditingTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)){
        return NO;
    }else if (action == @selector(select:)){
        return NO;
    }else if (action == @selector(selectAll:)){
        return NO;
    }else{
        return [super canPerformAction:action withSender:sender];
    }
}

@end
