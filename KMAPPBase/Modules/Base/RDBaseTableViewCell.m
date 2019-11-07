//
//  RDBaseTableViewCell.m
//  Reindeer
//
//  Created by Sword on 1/30/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import "RDBaseTableViewCell.h"
#import "XibViewUtils.h"

@implementation RDBaseTableViewCell

- (void)dealloc {
    ITTDINFO(@"%@ is dealloced!", [self class]);
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            UITableView *tableView = obj;
            tableView.dataSource = nil;
            tableView.delegate = nil;
        }else if ([obj isKindOfClass:[UICollectionView class]]){
            UICollectionView *collectionView = obj;
            collectionView.dataSource = nil;
            collectionView.delegate = nil;
        }
    }];
    
    
}

- (void)setDefaultSelectedBackgroundView {
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    selectedBackgroundView.backgroundColor = COLOR_FONT;
    selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.selectedBackgroundView = selectedBackgroundView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setDefaultSelectedBackgroundView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.showLineView = TRUE;
    [self setDefaultSelectedBackgroundView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (id)cellFromXib
{
    return [XibViewUtils loadViewFromXibNamed:NSStringFromClass([self class])];
}

+ (CGFloat)cellHeight:(id)data
{
    return [[self class] cellHeight:data];
}
+ (CGFloat)cellHeight:(id)data planDay:(id)model{
    
    return [[self class] cellHeight:data planDay:model];
}
@end
