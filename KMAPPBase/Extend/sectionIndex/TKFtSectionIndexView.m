//
//  TKFtSectionIndexView.m
//  TKFtSDK
//
//  Created by 揭康伟 on 2019/1/22.
//  Copyright © 2019年 com.thinkive.www. All rights reserved.
//

#import "TKFtSectionIndexView.h"

static CGFloat const KIndexItemHeight = 16.f;
static CGFloat const KIndexItemMargin = 2.f;

@interface TKFtSectionIndexView ()
{
    CGFloat   itemViewHeight;
    NSInteger highlightedItemIndex;
}
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIView *calloutView;
@property (nonatomic, retain) NSMutableArray *itemViewList;

@end

@implementation TKFtSectionIndexView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.clipsToBounds = YES;
        _backgroundView.layer.cornerRadius = 12.f;
        [self addSubview:self.backgroundView];
        [self.backgroundView setHidden:YES];
        
        _itemViewList = [[NSMutableArray alloc] init];
        highlightedItemIndex = -1;
    }
    return self;
}

#define kBackgroundViewLeftMargin  3.f
- (void)setBackgroundViewFrame
{
    self.backgroundView.frame = CGRectMake(kBackgroundViewLeftMargin, 0, CGRectGetWidth(self.frame) - kBackgroundViewLeftMargin*2, CGRectGetHeight(self.frame));
}

- (void)sectionIndexViewScrollToSection:(NSInteger)section
{
    [self selectItemViewForSection:section scroll:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutItemViews];
}

- (void)layoutItemViews
{
    CGFloat offsetY = 0.f;
    if (self.itemViewList.count) {
        NSInteger count = self.itemViewList.count;
        CGFloat allItemViewHeight = count*KIndexItemHeight+(count -1)*KIndexItemMargin;
        CGFloat viewHeight = CGRectGetHeight(self.bounds);
        offsetY = (viewHeight - allItemViewHeight)/2.0;
    }

    for (UIView *itemView in self.itemViewList) {
        itemView.frame = CGRectMake(5, offsetY, KIndexItemHeight, KIndexItemHeight);
        offsetY += KIndexItemHeight+KIndexItemMargin;
    }
}

- (void)reloadItemViews
{
    for (UIView *itemView in self.itemViewList) {
        [itemView removeFromSuperview];
    }
    [self.itemViewList removeAllObjects];
    
    NSInteger numberOfItems = 0;
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfItemViewForSectionIndexView:)]) {
        numberOfItems = [_dataSource numberOfItemViewForSectionIndexView:self];
    }
    
    for (int i = 0; i < numberOfItems; i++) {
        if (_dataSource && [_dataSource respondsToSelector:@selector(sectionIndexView:itemViewForSection:)]) {
            TKFtSectionIndexItem *itemView = [_dataSource sectionIndexView:self itemViewForSection:i];
            itemView.section = i;
            [self.itemViewList addObject:itemView];
            [self addSubview:itemView];
        }
    }
    
    [self layoutItemViews];
}


- (void)selectItemViewForSection:(NSInteger)section scroll:(BOOL)scroll
{
    [self highlightItemForSection:section];
    if (scroll) return;
    if (_delegate && [_delegate respondsToSelector:@selector(sectionIndexView:didSelectSection:)]) {
        [_delegate sectionIndexView:self didSelectSection:section];
    }
}

- (void)highlightItemForSection:(NSInteger)section
{
    if (self.itemViewList.count) {
        [self unhighlightAllItems];
        NSInteger targetSection = highlightedItemIndex == -1?section:highlightedItemIndex;
        TKFtSectionIndexItem *itemView = [self.itemViewList objectAtIndex:targetSection];
        [itemView setSelected:YES];
    }
    
}

- (void)unhighlightAllItems
{
    for (TKFtSectionIndexItem *itemView  in self.itemViewList) {
         [itemView setSelected:NO];
    }
}


#pragma mark methods of touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.hidden = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (TKFtSectionIndexItem *itemView in self.itemViewList) {
        if (CGRectContainsPoint(itemView.frame, touchPoint)) {
            highlightedItemIndex = itemView.section;
            [self selectItemViewForSection:itemView.section scroll:NO];
            break;
        }
    }
    
    highlightedItemIndex = -1;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.hidden = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (TKFtSectionIndexItem *itemView in self.itemViewList) {
        if (CGRectContainsPoint(itemView.frame, touchPoint)) {
            if (itemView.section != highlightedItemIndex) {
                 highlightedItemIndex  = itemView.section;
                [self selectItemViewForSection:itemView.section scroll:NO];
                break;
                
            }
        }
    }
    highlightedItemIndex = -1;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    self.backgroundView.hidden = YES;
//    [self unhighlightAllItems];
//    highlightedItemIndex = -1;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self touchesCancelled:touches withEvent:event];
}


@end


@interface TKFtSectionIndexItem ()
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIView *backgroundView;
@end

@implementation TKFtSectionIndexItem


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contentView = [[UIView alloc] init];
        [self addSubview:self.contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _backgroundView = [[UIView alloc] init];
        
        [self.contentView addSubview:_backgroundView];
        
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel addCssId:@".ftPortIndexNormalText"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_backgroundView layoutIfNeeded];
    _backgroundView.layer.cornerRadius = 8;
    _backgroundView.layer.masksToBounds = YES;
}
-(void)setSelected:(BOOL)selected
{
    
    if (selected) {
        _titleLabel.textColor = [UIColor whiteColor];
        _backgroundView.backgroundColor = TKFT_HEXCOLOR(0XFF5656);
    }else{
        _titleLabel.textColor = TKFT_HEXCOLOR(0X2A2A2A);
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
}



@end
