//
//  NSArray+Addition.m
//  Reindeer
//
//  Created by 揭康伟 on 16/8/22.
//  Copyright © 2016年 Sword. All rights reserved.
//

#import "NSArray+Addition.h"
#import "RDDayAnnotation.h"

@implementation NSArray (Addition)
- (NSArray *)sortArrayByDecending{
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    return [self sortedArrayUsingComparator:cmptr];
}

- (NSArray *)sortArrayByDecendingByDay{
    
    NSComparator cmptr = ^(RDDayAnnotation *obj1, RDDayAnnotation *obj2){
        if ([obj1.day integerValue] < [obj2.day integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([obj1.day integerValue] > [obj2.day integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    return [self sortedArrayUsingComparator:cmptr];
}

- (NSArray *)sortArrayByDecending:(id)key{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:descriptor, nil];
    return [self sortedArrayUsingDescriptors:sortDescriptors];
}
@end
