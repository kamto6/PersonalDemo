//
//  NSString+ITTAdditions.m
//
//  Created by Jack on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIFont+Additions.h"


@implementation NSString (ITTAdditions)

- (NSInteger)numberOfLinesWithFont:(UIFont*)font
                     withLineWidth:(NSInteger)lineWidth
{
//    CGSize size;
//    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
//        size = [self boundingRectWithSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
//                                             options:NSStringDrawingUsesLineFragmentOrigin
//                                          attributes:@{NSFontAttributeName:font}
//                                             context:nil].size;
//    } else {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        size = [self sizeWithFont:font
//                           constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
//                               lineBreakMode:NSLineBreakByTruncatingTail];
//#pragma clang diagnostic pop
//    }
    CGFloat height = [self heightWithFont:font withLineWidth:lineWidth];
	NSInteger lines = height / (font.ascender - font.descender);
	return lines;
}

- (CGFloat)heightWithFont:(UIFont*)font
            withLineWidth:(NSInteger)lineWidth
{
    CGSize size;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        size = [self boundingRectWithSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:font}
                                  context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [self sizeWithFont:font
                constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                    lineBreakMode:NSLineBreakByTruncatingTail];
#pragma clang diagnostic pop
    }
	return size.height;
	
}

- (CGFloat)widthWithFont:(UIFont*)font withLineHeight:(NSInteger)lineHeight
{
    CGSize size;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        size = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, lineHeight)
                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                               attributes:@{NSFontAttributeName:font}
                                  context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [self sizeWithFont:font
                constrainedToSize:CGSizeMake(CGFLOAT_MAX, lineHeight)
                    lineBreakMode:NSLineBreakByTruncatingTail];
#pragma clang diagnostic pop
    }
    return size.width;
}

- (NSString *)md5
{
	const char *concat_str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, (CC_LONG)strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
		[hash appendFormat:@"%02X", result[i]];
	}
	return [hash lowercaseString];
	
}

- (NSString*)encodeUrl
{
	NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
	if (newString) {
		return newString;
	}
	return @"";
}

- (BOOL)isStartWithString:(NSString*)start
{
    BOOL result = FALSE;
    NSRange found = [self rangeOfString:start options:NSCaseInsensitiveSearch];

    if (found.location == 0)
    {
        result = TRUE;
    }
    return result;
}

- (BOOL)isEndWithString:(NSString*)end
{
    NSInteger endLen = [end length];
    NSInteger len = [self length];
    BOOL result = TRUE;
    if (endLen <= len) {
        NSInteger index = len - 1;
        for (NSInteger i = endLen - 1; i >= 0; i--) {
            if ([end characterAtIndex:i] != [self characterAtIndex:index]) {
                result = FALSE;
                break;
            }
            index--;
        }
    }
    else {
        result = FALSE;
    }
    return result;
}


- (BOOL)canConvertToNumber
{
    BOOL can = FALSE;
    if (self && [self length]) {
        can = TRUE;
        NSInteger len = self.length;
        for (NSInteger i = 0; i < len; i++) {
            if (!([self characterAtIndex:i] >= '0' && [self characterAtIndex:i] <= '9')) {
                can = FALSE;
                break;
            }
        }
    }
    return can;
}

- (NSAttributedString *)shadowText{
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
    shadow.shadowOffset = CGSizeMake(1, 1);
    shadow.shadowBlurRadius = 2;
    
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:self attributes:@{NSShadowAttributeName:shadow}];
    
    return attributedText;
}


@end

