//
//  XibViewUtils.h
//  Reindeer
//  utils for all UIViews using xib to layout  
//
//  Created by Sword on 1/31/15.
//  Copyright 2011 Sword. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XibViewUtils : NSObject

+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner;

//  the view must not have any connecting to the file owner
+ (id)loadViewFromXibNamed:(NSString*)xibName;
@end
