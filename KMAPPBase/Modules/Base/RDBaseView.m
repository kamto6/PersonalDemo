//
//  RDBaseView.m
//  Reindeer
//
//  Created by 揭康伟 on 17/10/17.
//  Copyright © 2017年 Sword. All rights reserved.
//

#import "RDBaseView.h"
#import "RDNoNetworkBgView.h"

@interface RDBaseView ()

@end
static RDNoNetworkBgView   *_noNetworkBgView = nil;

@implementation RDBaseView
- (void)showNoNetworkView:(UIView *)view tableView:(UIView *)tableView off:(CGFloat)off{
    
    if ([tableView isKindOfClass:[PullTableView class]]) {
        PullTableView * pullTableView = (PullTableView *)tableView;
        [pullTableView setRefreshViewHidden:TRUE];
        [pullTableView setLoadMoreViewHidden:TRUE];
    }
  
    _noNetworkBgView = nil;
    if (!_noNetworkBgView) {
        _noNetworkBgView = [RDNoNetworkBgView loadFromXib];
    }
   
    [_noNetworkBgView showView:view tableView:tableView off:off];
}
- (void)removeNoNetworkView{
    
    if (_noNetworkBgView) {
        [_noNetworkBgView remove];
    }
}

@end
