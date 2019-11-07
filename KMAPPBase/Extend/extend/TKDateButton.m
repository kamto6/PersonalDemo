//
//  TKDateButton.m
//  TKApp_HL
//
//  Created by thinkive on 2017/8/26.
//  Copyright © 2017年 liubao. All rights reserved.
//

#import "TKDateButton.h"

@implementation TKDateButton

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
    CGFloat imageViewX = ft750AdaptationWidth(16);
    CGFloat imageViewY = ft750AdaptationWidth(8);
    CGFloat imageViewW = ft750AdaptationWidth(24);
    CGFloat titleLabelX = imageViewX + imageViewW;

    self.titleLabel.frame = CGRectMake(titleLabelX, 0, bottonW - titleLabelX, bottonH);
    self.imageView.frame  = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewW);
}

@end
