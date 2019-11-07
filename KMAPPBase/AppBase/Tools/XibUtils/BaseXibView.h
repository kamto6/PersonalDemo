//
//  XibView.h
//  Reindeer
//
//  Created by Sword on 1/31/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APPWINDOW       [[UIApplication sharedApplication].delegate window]
#define SHIELD_ALPHA    0.4

@interface BaseXibView : UIView

+ (id)loadFromXib;

- (UIView*)viewForView:(UIView *)view;

@end
