//
//  TKFtContactLabel.m
//  TKFtSDK
//
//  Created by 揭康伟 on 2018/11/26.
//  Copyright © 2018年 com.thinkive.www. All rights reserved.
//

#import "TKFtContactLabel.h"

@interface TKFtContactLabel()
@property (nonatomic,strong) UILabel * contentLabel1;
@property (nonatomic,strong) UILabel * contentLabel2;
@property (nonatomic,assign) float fontSize;
@end

@implementation TKFtContactLabel

- (instancetype)initWithFontSize:(float)fontSize{
    if (self = [super init]) {
        _fontSize  = fontSize;
        [self addSubview:self.contentLabel1];
        [self addSubview:self.contentLabel2];
        
        [self.contentLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.contentLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

/**
 *  2019-06-28，update
 */
- (instancetype)initWithFontSize:(float)fontSize leadingContraint:(CGFloat)leading trailingContraint:(CGFloat)trailing
{
    if (self = [super init]) {
        _fontSize  = fontSize;
        [self addSubview:self.contentLabel1];
        [self addSubview:self.contentLabel2];
        
        [self.contentLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(leading);
            make.right.equalTo(self).offset(-trailing);
        }];
        [self.contentLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(leading);
            make.right.equalTo(self).offset(-trailing);
        }];
    }
    return self;
}
/**
 *  2019-06-28，update
 */
- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    self.contentLabel1.textAlignment = textAlignment;
    self.contentLabel2.textAlignment = textAlignment;
}
/*
 *  //测试
 //    _instrumentNameLabel.text = @"SP eg1909&\neg1909";
 //    _instrumentNameLabel.text = @"PRT SR901&\nSR901C4600";
 //    _instrumentNameLabel.text = @"cu1903C\n4900";
 //    _instrumentNameLabel.text = @"原三三油2003";
 //    _instrumentNameLabel.text = @"SR901C4600";
//    _instrumentNameLabel.text = @"T1903"; //期权
//    _contractNameLabel.text = @"乙二醇1909";
 //   text = @"原油原油原油原油原油20099";
 
 //换行符号与\n之间会有些问题，包含\n时不用lineBreakMode属性，其他用NSLineBreakByWordWrapping
 //    if ([_instrumentNameLabel.text rangeOfString:@"\n"].location != NSNotFound) {
 //        _instrumentNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
 //    }else{
 //        _instrumentNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
 //    }
 */
- (void)setText:(NSString *)text{
    _text = text;
    if ([_text rangeOfString:@"\n"].location != NSNotFound) {
        _contentLabel1.hidden = YES;
        _contentLabel2.hidden = NO;
        _contentLabel2.text = _text;
    }else{
        _contentLabel1.hidden = NO;
        _contentLabel2.hidden = YES;
        _contentLabel1.text = _text;
    }
}

- (void)addCssClass:(NSString *)cssClass{
    [_contentLabel1 addCssClass:cssClass];
    [_contentLabel2 addCssClass:cssClass];
}

#pragma mark - getter & setter
-(UILabel *)contentLabel1
{
    if (!_contentLabel1) {
        _contentLabel1 = [[UILabel alloc] init];
        _contentLabel1.textAlignment = NSTextAlignmentLeft;
        _contentLabel1.font = [UIFont ftk750AdaptationFont:_fontSize];
//        _contentLabel1.lineBreakMode = NSLineBreakByCharWrapping;
//        _contentLabel1.numberOfLines = 2;
        //普通合约不显示换行
        _contentLabel1.numberOfLines  = 1;
        [_contentLabel1 addCssClass:@".ftContractNametextColor"];
        _contentLabel1.adjustsFontSizeToFitWidth = YES;
    }
    return _contentLabel1;
}

- (UILabel *)contentLabel2
{
    if (!_contentLabel2) {
        _contentLabel2 = [[UILabel alloc]init];
        _contentLabel2.textAlignment = NSTextAlignmentLeft;
        _contentLabel2.font = [UIFont ftk750AdaptationFont:_fontSize];
        [_contentLabel2 addCssClass:@".ftContractNametextColor"];
        _contentLabel2.numberOfLines = 2;
        _contentLabel2.adjustsFontSizeToFitWidth = YES;
        _contentLabel2.hidden = YES;
    }
    return _contentLabel2;
}
@end
