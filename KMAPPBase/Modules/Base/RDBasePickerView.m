//
//  RDBasePickerView.m
//  Reindeer
//
//  Created by Sword on 3/23/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import "RDBasePickerView.h"

@interface RDBasePickerView()
{
    UIView                  *_shieldView;
    UIImageView             *_imageView;
    UITapGestureRecognizer  *_hideGesture;
}
@end

@implementation RDBasePickerView

@synthesize shieldView = _shieldView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showInView:(UIView*)superView
{
    if (!_shieldView) {
        _shieldView = [[UIView alloc] initWithFrame:superView.bounds];
        _shieldView.backgroundColor = [UIColor blackColor];
        _shieldView.alpha = 0;
    }
    if (!_shieldView.superview) {
        [superView addSubview:_shieldView];
    }
   
    if (!self.superview) {
        if (!_hideGesture) {
            _hideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
            [self.shieldView addGestureRecognizer:_hideGesture];
        }
        [superView addSubview:self];
    }
    [superView bringSubviewToFront:self];
    CGRect frame = self.frame;
    frame.size.width = CGRectGetWidth(superView.frame);
    self.top = CGRectGetMaxY(superView.frame);
    self.width = CGRectGetWidth(superView.frame);
    frame.origin.y = CGRectGetHeight(superView.frame) - CGRectGetHeight(frame);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
        _shieldView.alpha = SHIELD_ALPHA;
        
    }];
}

- (void)hide
{
    CGFloat top = CGRectGetMaxY(self.superview.frame);
    [UIView animateWithDuration:0.3 animations:^{
        self.top = top;
        _shieldView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_shieldView removeFromSuperview];
            if (self.superview) {
                [self removeFromSuperview];
            }
        }
    }];
}

@end
