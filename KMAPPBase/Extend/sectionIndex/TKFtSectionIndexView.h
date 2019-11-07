//
//  TKFtSectionIndexView.h
//  TKFtSDK
//
//  Created by 揭康伟 on 2019/1/22.
//  Copyright © 2019年 com.thinkive.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKFtSectionIndexView,TKFtSectionIndexItem;

@protocol TKFtSectionIndexViewDataSource <NSObject>

- (TKFtSectionIndexItem *)sectionIndexView:(TKFtSectionIndexView *)sectionIndexView
                         itemViewForSection:(NSInteger)section;

- (NSInteger)numberOfItemViewForSectionIndexView:(TKFtSectionIndexView *)sectionIndexView;

@end

@protocol TKFtSectionIndexViewDelegate <NSObject>

- (void)sectionIndexView:(TKFtSectionIndexView *)sectionIndexView
        didSelectSection:(NSInteger)section;

@end

@interface TKFtSectionIndexView : UIView

@property (nonatomic, weak) id<TKFtSectionIndexViewDataSource>dataSource;
@property (nonatomic, weak) id<TKFtSectionIndexViewDelegate>delegate;

- (void)reloadItemViews;

- (void)setBackgroundViewFrame;

- (void)sectionIndexViewScrollToSection:(NSInteger)section;

@end


@interface TKFtSectionIndexItem : UIView
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setSelected:(BOOL)selected;
@end
