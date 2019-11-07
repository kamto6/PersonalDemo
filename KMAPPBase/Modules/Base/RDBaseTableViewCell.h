//
//  RDBaseTableViewCell.h
//  Reindeer
//
//  Created by Sword on 1/30/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import <UIKit/UIKit.h>


#define RD_CELL_SELECTED_BACKGROUND_COLOR  [UIColor colorWithHexString:@"0xd4f1f9"]

@interface RDBaseTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL showLineView;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) id imageData;
+ (id)cellFromXib;

+ (CGFloat)cellHeight:(id)data;

+ (CGFloat)cellHeight:(id)data planDay:(id)model;

- (void)setDefaultSelectedBackgroundView;

@end
