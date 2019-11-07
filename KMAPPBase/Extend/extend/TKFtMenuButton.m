//
//  TKFtMenuButton.m
//  TKApp
//
//  Created by thinkive on 2017/9/26.
//  Copyright © 2017年 Pengxuyuan. All rights reserved.
//

#import "TKFtMenuButton.h"

@implementation TKFtMenuButton

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
    CGFloat imageViewY = ft750AdaptationWidth(16);
    CGFloat imageViewX = ft750AdaptationWidth(30);
    CGFloat imageViewW = ft750AdaptationWidth(30);

    CGFloat titleLabelH = ft750AdaptationWidth(26);
    CGFloat titleLabelY = imageViewY+imageViewW+ft750AdaptationWidth(10);

    self.imageView.frame  = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewW);
    self.titleLabel.frame = CGRectMake(0, titleLabelY, bottonW, titleLabelH);
}



@end
