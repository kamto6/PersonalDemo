//
//  KMXMLParser.m
//  KMAppBase
//
//  Created by 揭康伟 on 2017/10/29.
//  Copyright © 2017 kamto. All rights reserved.
//
/*

1.SAX是一种基于事件驱动的解析模式。解析XML的时候，程序从上到下读取XML文档，如果遇到开始标签、结束标签、属性等，就会触发相应的事件。

优点：解析速度快，iOS重点推荐使用SAX模式解析
缺点：只能读取XML文档，不能写入XML文档，遇到特殊字符容易失败，需要注意数据中的空格，key之间需要有空格

2.DOM模式是将XML文档作为一颗树状结构进行分析，提供获取节点的内容，以及相关属性，或是新增、删除和修改节点的内容。XML解析器在加载XML文件以后，DOM将XML文件的元素视为一个树状结构的节点，一次性读入到内存中。

优点：能够修改XML文档
缺点：如果文档比较大，解析速度就会变慢

NSXMLParser是iOS SDK自带的，也是苹果默认的解析框架，采用SAX模式解析

 */

#import "KMXMLParser.h"

@interface KMXMLParser ()<NSXMLParserDelegate>
@property (nonatomic, strong) NSXMLParser         *parser;
@property (nonatomic, strong) NSMutableDictionary *configXmlDict;// 解析结果字典
@property (nonatomic, strong) NSString            *currentTagKey;// 当前标签头key
@property (nonatomic , copy ) void(^completionBlock)(id , BOOL);
@end

@implementation KMXMLParser
implementationSingleton(KMXMLParser)

- (void)readSystemConfigXML:(NSString *)xml compleBlock:(void(^)(id result,BOOL success))compleBlock;
{
    self.completionBlock = compleBlock ?: nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:xml ofType:nil];
    NSData   *data = [NSData dataWithContentsOfFile:path];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
}

//开始加载文档
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _configXmlDict = [NSMutableDictionary dictionary];
}

//开始解析标签
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (elementName == nil) return;
    NSString *name = attributeDict[@"name"];
    if (name == nil) return;
    NSString *value = attributeDict[@"value"];
    if (value == nil)
    {
        _currentTagKey = name;
    }else
    {
        NSString *key = [NSString stringWithFormat:@"%@.%@",_currentTagKey,name];
        [_configXmlDict setObject:value forKey:key];
    }
    
}
//标签解析结束
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
}
//读取标签之间的文本
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

}

// 文档出错的时候触发
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"%@", parseError);
}

//结束加载文档
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    BOOL success = _configXmlDict.allKeys > 0;
    self.completionBlock(_configXmlDict,success);
}
@end
