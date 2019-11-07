//
//  UIImage+addition.h
//  douyuTVDemo
//
//  Created by 揭康伟 on 16/5/10.
//  Copyright © 2016年 kamto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (addition)
/**
 *  根据size改变显示图片尺寸
 *
 *  @param image
 *  @param size
 *
 *  @return
 */
+ (UIImage *)compressImage:(UIImage *)image Size:(CGSize)size;
/**
 *  压缩图片大小
 *
 *  @param image
 *
 *  @return
 */
+ (NSData *)compactImage:(UIImage *)image;
/**
 *  压缩图片指定多大
 *
 *  @param image
 *
 *  @return
 */
-(UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;
/**
 *  在图片上添加文字
 *
 *  @param img
 *  @param text
 *
 *  @return 
 */
+ (UIImage *)AddImage:(UIImage *)img text:(NSString *)text;
/**
 *
 *
 *  @param color
 *
 *  @return
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  剪切图片
 *
 *  @param size          剪切的size
 *  @param originalImage
 *
 *  @return 
 */
+ (UIImage *)getCutImageSize:(CGSize)size
               originalImage:(UIImage *)originalImage;
/**
 *  裁剪图片
 *
 *  @param image     图片
 *  @param targetSize  裁剪的size
 *  按照比例
 *  @return
 */
-(UIImage*)cutImage:(UIImage*)image   fortargetSize: (CGSize)targetSize;
@end
