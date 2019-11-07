//
//  ViewController.m
//  KMAPPBase
//
//  Created by 揭康伟 on 2018/10/15.
//  Copyright © 2017年 kamto. All rights reserved.
//

#import "ViewController.h"
#import "KMAppBase.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self test0];
}

- (void)test0
{
//    NSString *content = @"1223";
//    NSString *ducopath = [KMFileHelper documentFolder];
//    NSString *path = [ducopath stringByAppendingPathComponent:@"content.txt"];
//    if ([KMFileHelper writeContent:content inFilePath:path]) {
//        NSLog(@"1");
//    }
//
//    NSObject *data = [KMFileHelper readContentOfFilePath:path];
//    NSLog(@"1");
    
    [[KMXMLParser shareKMXMLParser] readSystemConfigXML:@"TKFtConfig.xml" compleBlock:^(id result, BOOL success) {
        NSLog(@"1");
    }];
}

- (void)test1
{
    NSLog(@"-------%@",[KMNumberHelper formatNumber:0.12367 decimal:3 fillZero:YES]);
    NSLog(@"-------%@",[KMNumberHelper formatNumber:0.12347 decimal:3 fillZero:YES]);
    NSLog(@"-------%@",[KMNumberHelper formatNumber:1.15 decimal:3 fillZero:YES]);
    NSLog(@"-------%@",[KMNumberHelper formatNumber:1.115000 decimal:3 fillZero:YES]);
    NSLog(@"-------%@",[KMNumberHelper formatNumber:1.135 decimal:3 fillZero:YES]);
    NSLog(@"-------%@",[KMNumberHelper formatNumber:0 decimal:3 fillZero:YES]);
    NSLog(@"-------%@",[KMNumberHelper formatPerNumber:0 decimal:3 isRound:YES]);
    NSLog(@"-------%@",[KMNumberHelper formatPerNumber:0.1255667 decimal:2 isRound:YES]);
    NSLog(@"-------%@",[KMNumberHelper formatMoneyNumber:124555566.5666 decimal:3 isRound:YES]);
    
}

@end
