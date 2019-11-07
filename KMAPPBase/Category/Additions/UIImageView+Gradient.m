////
////  UIImageView+Gradient.m
////  Reindeer
////
////  Created by Sword on 8/13/15.
////  Copyright (c) 2015 Sword. All rights reserved.
////
//
//#import "UIImageView+Gradient.h"
//
//@implementation UIImageView (Gradient)
//
////颜色渐变
//- (void)addGradient {
//    // Create a gradient layer that goes transparent -&gt; opaque
//    // [UIColor colorWithWhite:0 alpha:1]  [UIColor colorWithWhite:0 alpha:0.4]
//    CAGradientLayer *alphaGradientLayer = [CAGradientLayer layer];
//    NSArray *colors = [NSArray arrayWithObjects:
//                       (id)[[UIColor clearColor] CGColor],
//                       (id)[UIColor blackColor].CGColor,
//                       nil];
//    [alphaGradientLayer setColors:colors];
//
//    // Start the gradient at the bottom and go almost half way up.
//    //渐变层由上而下
//    [alphaGradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
//    [alphaGradientLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
//
//    //alphaGradientLayer.locations = @[@(0.5f) ,@(1.0f)];
//
//    //[alphaGradientLayer setFrame:[self bounds]];
//
//
//    [alphaGradientLayer setFrame:CGRectMake(0, CGRectGetHeight(self.bounds)/2, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/2)];
//
//
//    //[[self layer] setMask:alphaGradientLayer];
//
//
//   [[self layer] addSublayer:alphaGradientLayer];
//
//}
//
//- (void)addGradient:(CGRect)frame{
//
//    UIColor * blackColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//    CAGradientLayer *alphaGradientLayer = [CAGradientLayer layer];
//    NSArray *colors = [NSArray arrayWithObjects:
//                       (id)[[UIColor clearColor] CGColor],
//                       (id)blackColor.CGColor,
//                       nil];
//    [alphaGradientLayer setColors:colors];
//
//    [alphaGradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
//    [alphaGradientLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
//
//
//
//    [alphaGradientLayer setFrame:CGRectMake(0, CGRectGetHeight(frame)/2, CGRectGetWidth(frame), CGRectGetHeight(frame)/2)];
//
//    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperlayer];
//    }];
//    [[self layer] addSublayer:alphaGradientLayer];
//
//
//}
//- (void)addPlanCoverGradient:(CGRect)frame{
//
//    UIColor * bottom_color =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
//    UIColor * top_color    =  [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.15];
//
//    CAGradientLayer *alphaGradientLayer = [CAGradientLayer layer];
//    NSArray *colors = [NSArray arrayWithObjects:
//                       (id)[top_color CGColor],
//                       (id)bottom_color.CGColor,
//                       nil];
//    [alphaGradientLayer setColors:colors];
//
//    [alphaGradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
//    [alphaGradientLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
//
//
//
//    [alphaGradientLayer setFrame:frame];
//
//    [[self layer] addSublayer:alphaGradientLayer];
//
//
//}
//
//- (void)addBlack:(CGRect)frame alpha:(float)alpha{
//    // 0.35
//    UIColor * blackColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
//    CALayer *Layer = [CALayer layer];
//
//    [Layer setBackgroundColor:blackColor.CGColor];
//
//    [Layer setFrame:frame];
//
//    [[self layer] addSublayer:Layer];
//
//
//}
//
//- (void)addLayerColor:(UIColor *)color Frame:(CGRect)frame{
//
//    CALayer *Layer = [CALayer layer];
//
//    [Layer setBackgroundColor:color.CGColor];
//
//    [Layer setFrame:frame];
//
//    [[self layer] addSublayer:Layer];
//
//}
//
//- (void)addSubRelateCellGradient:(CGRect)frame{
//
//    UIColor * topColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
//    UIColor *bottomColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//
//    CAGradientLayer *alphaGradientLayer = [CAGradientLayer layer];
//    NSArray *colors = [NSArray arrayWithObjects:
//                       (id)[topColor CGColor],
//                       (id)bottomColor.CGColor,
//                       nil];
//    [alphaGradientLayer setColors:colors];
//
//    [alphaGradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
//    [alphaGradientLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
//
//
//
//    [alphaGradientLayer setFrame:CGRectMake(0, CGRectGetHeight(frame)/2, CGRectGetWidth(frame), CGRectGetHeight(frame)/2)];
//
//    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperlayer];
//    }];
//    [[self layer] addSublayer:alphaGradientLayer];
//}
//
//- (void)addAtlasCoverGradient:(UIColor *)startColor EndColor:(UIColor *)endColor Frame:(CGRect)frame{
//
//    CAGradientLayer *alphaGradientLayer = [CAGradientLayer layer];
//    NSArray *colors = [NSArray arrayWithObjects:
//                       (id)[startColor  CGColor],
//                       (id)[endColor   CGColor],
//                       nil];
//    [alphaGradientLayer setColors:colors];
//
//    [alphaGradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
//    [alphaGradientLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
//
//    [alphaGradientLayer setFrame:frame];
//
//    [[self layer] addSublayer:alphaGradientLayer];
//
//}
//
//- (void)addMyTripListCoverGradient:(CGRect)frame{
//
//    UIColor * topColor =  [UIColor colorWithRed:255 green:255 blue:255 alpha:0.0];
//    UIColor * middleColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.26];
//    UIColor *bottomColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.0];
//    
//    CAGradientLayer *alphaGradientLayer = [CAGradientLayer layer];
//    NSArray *colors = [NSArray arrayWithObjects:
//                       (id)[topColor CGColor],
//                       (id)[middleColor CGColor],
//                       (id)bottomColor.CGColor,
//                       nil];
//    [alphaGradientLayer setColors:colors];
//
//    [alphaGradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
//    [alphaGradientLayer setEndPoint:CGPointMake(1.0f, 0.0f)];
//
//    [alphaGradientLayer setFrame:frame];
//
//    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperlayer];
//    }];
//    [[self layer] addSublayer:alphaGradientLayer];
//
//}
//
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.layer.mask.frame = self.frame;
//
//}
//
//- (void)sd_setImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholder {
//    if (url && [url length]) {
//
//        NSString * imaUrl = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//把str字符串以UTF-8规则进行解码
//        imaUrl =  [imaUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//对字符串进行UTF-8编码
//
//        NSURL *URL = [NSURL URLWithString:imaUrl];
//
//        [self sd_setImageWithURL:URL placeholderImage:placeholder];
//
//    }
//    else {
//        self.image = placeholder;
//    }
//}
//
//- (void)sd_setImageWithUrl:(NSString *)url placeholder:(UIImage *)placeholder completion:(void(^)(NSError *error,UIImage *image))completion{
//
//    if (url && [url length]) {
//        NSString * imaUrl = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//把str字符串以UTF-8规则进行解码
//        imaUrl =  [imaUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//对字符串进行UTF-8编码
//        NSURL *URL = [NSURL URLWithString:imaUrl];
////        [self sd_setImageWithURL:URL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////            if (!error) {
////                completion(nil,image);
////            }
////
////        }];
//        [self sd_setImageWithURL:URL placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            if (!error) {
//                completion(nil,image);
//            }
//        }];
//    }
//    else {
//        self.image = placeholder;
//    }
//}
//@end
