//
//  TKHLSlider.m
//  testSlider
//
//  Created by thinkive on 2017/4/12.
//  Copyright © 2017年 com.thinkive.www. All rights reserved.
//

#import "TKFtSlider.h"

@implementation TKFtSlider

//设置轨道的坐标及尺寸
//这个方法是用来返回 UISlider 上的进度条的尺寸的
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    // 必须通过调用父类的trackRectForBounds 获取一个 bounds 值，否则 Autolayout 会失效，UISlider 的位置会跑偏。
    bounds = [super trackRectForBounds:bounds];
    // 这里面的h即为你想要设置的高度。
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 5);
}

@end
