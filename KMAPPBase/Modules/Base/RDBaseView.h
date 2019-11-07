//
//  RDBaseView.h
//  Reindeer
//
//  Created by 揭康伟 on 17/10/17.
//  Copyright © 2017年 Sword. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDBaseView : UIView
- (void)showNoNetworkView:(UIView *)view tableView:(UIView *)tableView off:(CGFloat)off;
- (void)removeNoNetworkView;
@end
