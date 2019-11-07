//
//  TKFtChooseKeyBoard.m
//  TKFtSDK
//
//  Created by thinkive on 2018/5/31.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import "TKFtChooseKeyBoard.h"
#import "TKFtChooseViewCell.h"
static NSString *identifier = @"TKFtChooseViewCell";

@interface TKFtChooseKeyBoard ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;//选择器
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UILabel *tipLabel;//当前无自选合约标签
@property (nonatomic,assign) NSInteger selectRow;//这中行

@end

@implementation TKFtChooseKeyBoard


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupView];
    }
    
    return self;
}

-(void)setupView
{
//    self.selectRow = 100000;
    [self addCssClass:@".ftBaseBackgroundColor"];
    [self addSubview:self.tipLabel];
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[TKFtChooseViewCell class] forCellWithReuseIdentifier:identifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TKFtChooseViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.title = self.dataSource[indexPath.row];
//    [self refreshCssAndSubViewsCss];
//    if (self.selectRow == indexPath.row) {
//        [cell freshSelectCellBgColor];
//    }else{
//    [cell freshNormalCellBgColor];
//    }
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleStr = self.dataSource[indexPath.row];
    if ([TKStringHelper isEmpty:titleStr]) {
        return;
    }
    
//    TKFtChooseViewCell *cell = (TKFtChooseViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    self.selectRow = indexPath.item;
//    [cell freshSelectCellBgColor];
    
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:titleStr:)]) {
        
        NSString *titleStr = self.dataSource[indexPath.item];
        [self.delegate didSelectItemAtIndex:indexPath.item titleStr:titleStr];
    }
}

#pragma mark - private method

/**
 键盘弹起，接到数据刷新界面
 
 @param freshData 自选股数据
 @param instrumentName 合约名称
 */
-(void)freshChooseView:(NSMutableArray *)freshData instrumentName:(NSString *)instrumentName
{
    self.dataSource = [freshData mutableCopy];
    if (self.dataSource.count == 0) {
        self.tipLabel.hidden = NO;
        self.collectionView.hidden = YES;
    }else{
        NSInteger nullInt = self.dataSource.count %3;
        if (nullInt != 0) {
            for (NSInteger i = 0; i < 3-nullInt; i++) {
                [self.dataSource addObject:@""];
            }
        }
        
//        self.selectRow = 100000;
//        for (NSString *nameStr in self.dataSource) {
//            if ([nameStr isEqualToString:instrumentName]) {
//                self.selectRow = [self.dataSource indexOfObject:nameStr];
//            }
//        }
        
        self.tipLabel.hidden = YES;
        self.collectionView.hidden = NO;
    }
    
    [self.collectionView reloadData];
}


#pragma mark - layout method

-(void)layoutSubviews
{
    self.collectionView.frame = self.bounds;
    self.tipLabel.frame = CGRectMake(0, 0, 200, 40);
    self.tipLabel.center = CGPointMake(self.centerX, self.height/2+2);
    [super layoutSubviews];
}

#pragma mark - setter and getter

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        CGFloat btnWith = (TKFT_SCREEN_WIDTH - 1)/3;
        CGFloat btnHeight = ft750AdaptationWidth(45.1);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(btnWith, btnHeight);
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 35, 0, 0)
                                            collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView addCssClass:@".ftBaseBackgroundColor"];
    }
    return _collectionView;
}

-(UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.text = @"当前无自选合约";
        _tipLabel.font = [UIFont ftk750AdaptationFont:16];
        [_tipLabel addCssClass:@".ftLightTextColor"];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _tipLabel;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

@end
