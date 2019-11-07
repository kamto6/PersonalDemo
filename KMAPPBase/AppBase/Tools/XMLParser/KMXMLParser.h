//
//  KMXMLParser.h
//  KMAppBase
//
//  Created by 揭康伟 on 2017/10/29.
//  Copyright © 2017 kamto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMXMLParser : NSObject

interfaceSingleton(KMXMLParser)

/**
 *
 *  读取系统config.xml文件
 *
 *  @param xml 文件
 *  @param compleBlock 结果回调
 *
 */
- (void)readSystemConfigXML:(NSString *)xml compleBlock:(void(^)(id result,BOOL success))compleBlock;


@end

