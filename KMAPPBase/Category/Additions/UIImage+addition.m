//
//  UIImage+addition.m
//  douyuTVDemo
//
//  Created by 揭康伟 on 16/5/10.
//  Copyright © 2016年 kamto. All rights reserved.
//

#import "UIImage+addition.h"

@implementation UIImage (addition)
+ (UIImage *)compressImage:(UIImage *)image Size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [image drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}
static float scale = 1.0;
+ (NSData *)compactImage:(UIImage *)image{
    NSData * resultData= nil;
    NSData * data = UIImageJPEGRepresentation(image, scale);
    resultData = data;
    while (resultData.length > 1024 * 100 && scale > 0.1) {
        scale -= 0.05;
        UIImage * newImage = [UIImage imageWithData:data];
        NSData * newData = UIImageJPEGRepresentation(newImage, scale);
        resultData = newData;
    }
    
    return resultData;
}
/*
 图片的压缩其实是俩概念，
 1、是 “压” 文件体积变小，但是像素数不变，长宽尺寸不变，那么质量可能下降，
 2、是 “缩” 文件的尺寸变小，也就是像素数减少。长宽尺寸变小，文件体积同样会减小。
 
 这个 UIImageJPEGRepresentation(image, 0.0)，是1的功能。这个 [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)] 是2的功能。
 */
-(UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}
+ (UIImage *)AddImage:(UIImage *)img text:(NSString *)text
{
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [[UIColor clearColor] set];
    [img drawInRect:CGRectMake(0, 0, w, h)];
    float x  = [UIApplication sharedApplication].keyWindow.center.x;
    
    [text drawInRect:CGRectMake(x, 100, 240, 80) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
    
    
}
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//剪切图片(从中心算起）
+ (UIImage *)getCutImageSize:(CGSize)size originalImage:(UIImage *)originalImage {
    
    originalImage = [self fixOrientation:originalImage];
    CGRect rect = [self getCutRectWithBigSize:originalImage.size cutSize:size];
    CGImageRef imageRef = originalImage.CGImage;
    CGImageRef cutImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, cutImageRef);
    UIImage *cutImage = [UIImage imageWithCGImage:cutImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(cutImageRef);
    
    return cutImage;
}

//获取截图区域(从中心算起）
+ (CGRect)getCutRectWithBigSize:(CGSize)bigSize cutSize:(CGSize)cutSize {
    CGFloat scale = [self getCompressScaleWithBigSize:bigSize smallSize:cutSize];
    CGPoint bigPoint = CGPointMake(bigSize.width / 2.0f, bigSize.height / 2.0f);
    CGSize scaleSize = CGSizeMake(cutSize.width / scale, cutSize.height / scale);
    CGRect Rect = CGRectMake(bigPoint.x - scaleSize.width / 2.0f,
                             bigPoint.y - scaleSize.height / 2.0f,
                             scaleSize.width, scaleSize.height);
    return Rect;
}


//获取压缩比scale
+ (CGFloat)getCompressScaleWithBigSize:(CGSize)bigSize
                             smallSize:(CGSize)smallSize {
    CGFloat scale;
    if (bigSize.height / bigSize.width >= smallSize.height / smallSize.width) {
        scale = smallSize.width / bigSize.width;
    } else {
        scale = smallSize.height / bigSize.height;
    }
    return scale;
}

//修改图片处理后旋转问题
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,
                                                   aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the
    // transform
    // calculated above.
    CGContextRef ctx =
    CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                          CGImageGetBitsPerComponent(aImage.CGImage), 0,
                          CGImageGetColorSpace(aImage.CGImage),
                          CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,
                               CGRectMake(0, 0, aImage.size.height, aImage.size.width),
                               aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,
                               CGRectMake(0, 0, aImage.size.width, aImage.size.height),
                               aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


-(UIImage*)cutImage:(UIImage*)image   fortargetSize: (CGSize)targetSize{
    
    UIImage*sourceImage = image;
    
    CGSize imageSize = sourceImage.size;//图片的size
    
    CGFloat imageWidth = imageSize.width;//图片宽度
    
    CGFloat imageHeight = imageSize.height;//图片高度
    
    NSInteger judge;//声明一个判断属性
    
    //判断是否需要调整尺寸(这个地方的判断标准又个人决定,在此我是判断高大于宽),因为图片是800*480,所以也可以变成480*800
    
    if( ( imageHeight - imageWidth)>0) {
        
        //在这里我将目标尺寸修改成480*800
        
        CGFloat tempW = targetSize.width;
        
        CGFloat tempH = targetSize.height;
        
        targetSize.height= tempW;
        
        targetSize.width= tempH;
        
    }
    
    CGFloat targetWidth = targetSize.width;//获取最终的目标宽度尺寸
    
    CGFloat targetHeight = targetSize.height;//获取最终的目标高度尺寸
    
    CGFloat scaleFactor ;//先声明拉伸的系数
    
    CGFloat scaledWidth = targetWidth;
    
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint =CGPointMake(0.0,0.0);//这个是图片剪切的起点位置
    
    //第一个判断,图片大小宽跟高都小于目标尺寸,直接返回image
    
    if( imageHeight < targetHeight && imageWidth < targetWidth) {
        
        return image;
        
    }
    
    if ( CGSizeEqualToSize(imageSize, targetSize ) ==NO )
        
    {
        
        CGFloat widthFactor = targetWidth / imageWidth;  //这里是目标宽度除以图片宽度
        
        CGFloat heightFactor = targetHeight / imageHeight; //这里是目标高度除以图片高度
        
        //分四种情况,
        
        //第一种,widthFactor,heightFactor都小于1,也就是图片宽度跟高度都比目标图片大,要缩小
        
        if(widthFactor <1&& heightFactor<1){
            
            //第一种,需要判断要缩小哪一个尺寸,这里看拉伸尺度,我们的scale在小于1的情况下,谁越小,等下就用原图的宽度高度✖️那一个系数(这里不懂的话,代个数想一下,例如目标800*480  原图1600*800  系数就采用宽度系数widthFactor = 1/2  )
            
            if(widthFactor > heightFactor){
                
                judge =1;//右部分空白
                
                scaleFactor = heightFactor; //修改最后的拉伸系数是高度系数(也就是最后要*这个值)
                
            }
            
            else
                
            {
                
                judge =2;//下部分空白
                
                scaleFactor = widthFactor;
                
            }
            
        }
        
        else if(widthFactor >1&& heightFactor <1){
            
            //第二种,宽度不够比例,高度缩小一点点(widthFactor大于一,说明目标宽度比原图片宽度大,此时只要拉伸高度系数)
            
            judge =3;//下部分空白
            
            //采用高度拉伸比例
            
            scaleFactor = imageWidth / targetWidth;// 计算高度缩小系数
            
        }else if(heightFactor >1&& widthFactor <1){
            
            //第三种,高度不够比例,宽度缩小一点点(heightFactor大于一,说明目标高度比原图片高度大,此时只要拉伸宽度系数)
            
            judge =4;//下边空白
            
            //采用高度拉伸比例
            
            scaleFactor = imageHeight / targetWidth;
            
        }else{
            
            //第四种,此时宽度高度都小于目标尺寸,不必要处理放大(如果有处理放大的,在这里写).
            
        }
        
        scaledWidth= imageWidth * scaleFactor;
        
        scaledHeight = imageHeight * scaleFactor;
        
    }
    
    if(judge ==1){
        
        //右部分空白
        
        targetWidth = scaledWidth;//此时把原来目标剪切的宽度改小,例如原来可能是800,现在改成780
        
    }else if(judge ==2){
        
        //下部分空白
        
        targetHeight = scaledHeight;
        
    }else if(judge ==3){
        
        //第三种,高度不够比例,宽度缩小一点点
        
        targetWidth  = scaledWidth; 
        
    }else{
        
        //第三种,高度不够比例,宽度缩小一点点
        
        targetHeight= scaledHeight;
        
    }
    
    UIGraphicsBeginImageContext(targetSize);//开始剪切
    
    CGRect thumbnailRect =CGRectZero;//剪切起点(0,0)
    
    thumbnailRect.origin= thumbnailPoint;
    
    thumbnailRect.size.width= scaledWidth;
    
    thumbnailRect.size.height= scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    UIImage*newImage =UIGraphicsGetImageFromCurrentImageContext();//截图拿到图片
    
    return newImage;
}

@end
