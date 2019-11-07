//
//  UIImageView+Gradient.h
//  Reindeer
//
//  Created by Sword on 8/13/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Gradient)

- (void)addGradient;

- (void)addGradient:(CGRect)frame;

- (void)addBlack:(CGRect)frame alpha:(float)alpha;
- (void)addLayerColor:(UIColor *)color Frame:(CGRect)frame;

- (void)addSubRelateCellGradient:(CGRect)frame;
- (void)addAtlasCoverGradient:(UIColor *)startColor EndColor:(UIColor *)endColor Frame:(CGRect)frame;


- (void)addMyTripListCoverGradient:(CGRect)frame;

- (void)sd_setImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholder;
- (void)sd_setImageWithUrl:(NSString *)url placeholder:(UIImage *)placeholder completion:(void(^)(NSError *error,UIImage *image))completion;
@end
