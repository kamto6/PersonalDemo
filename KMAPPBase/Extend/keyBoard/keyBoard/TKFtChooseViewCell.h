//
//  TKFtChooseViewCell.h
//  TKFtSDK
//
//  Created by thinkive on 2018/5/25.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKFtChooseViewCell : UICollectionViewCell

@property (copy,nonatomic) NSString *title;

-(void)freshSelectCellBgColor;

-(void)freshNormalCellBgColor;

@end
