//
//  TKFtCheckButton.m
//  TKApp_HL
//
//  Created by thinkive on 2017/5/26.
//  Copyright © 2017年 liubao. All rights reserved.
//

#import "TKFtCheckButton.h"

@implementation TKFtCheckButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat bottonW = self.frame.size.width;
    CGFloat bottonH = self.frame.size.height;
    CGFloat titleLabelX = ft750AdaptationWidth(16);
    self.titleLabel.frame = CGRectMake(titleLabelX, 0, bottonW - 2*titleLabelX, bottonH);
    self.imageView.frame  = CGRectMake(bottonW-titleLabelX, bottonH-titleLabelX, titleLabelX, titleLabelX);
}

@end
