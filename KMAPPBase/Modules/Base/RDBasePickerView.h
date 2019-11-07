//
//  RDBasePickerView.h
//  Reindeer
//
//  Created by Sword on 3/23/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import "BaseXibView.h"

@interface RDBasePickerView : BaseXibView

@property (nonatomic, readonly) UIView  *shieldView;

- (void)showInView:(UIView*)superView;
- (void)hide;

@end
