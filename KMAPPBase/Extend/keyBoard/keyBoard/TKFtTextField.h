//
//  YYTextField.h
//  testKeyBoard
//
//  Created by thinkive on 2017/2/26.
//  Copyright © 2017年 com.thinkive.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKFtKeyBoardDelegate.h"

@class TKFtTextField,TKFtCapitalBean,TKFtInstrumentBean,TKFtmarketBean;
@class TKFtHsmarketBean,TKFtHsInstrumentBean,TKFtHsCapitalBean;
@protocol TKFtTextFieldDelegate <NSObject>

@optional

/**
 拼接或者删除字符
 
 @param ftTextField 输入框
 @param changeString 需要拼接或者删除的字符
 */
-(void)ftTextField:(TKFtTextField *)ftTextField andChangeString:(NSString *)changeString;

/**
 输入框里面做加或减
 
 @param ftTextField 输入框
 @param string 需要加减的字符
 */
-(void)ftTextField:(TKFtTextField *)ftTextField andPlusOrMinusString:(NSString *)string;


/**
 使用合约名称键盘需要设置代理，传入字符数组

 @param ftTextField 输入框
 */
-(NSArray *)fetchStringItemsWithftTextField:(TKFtTextField *)ftTextField;

/**
 选中标题

 @param ftTextField 输入框
 @param index 标题下标
 @param titleStr 标题
 */
-(void)ftTextField:(TKFtTextField *)ftTextField didSelectItemAtIndex:(NSInteger )index titleStr:(NSString *)titleStr;

/**
 *  返回错误提示
 */
- (void)ftTextField:(TKFtTextField *)ftTextField failInfo:(NSString *)failInfo;
@end

@interface TKFtTextField : UITextField

/**
 输入框输入限制输入长度
 */
@property (nonatomic,assign) NSInteger inputLimitLength;

/**
 是否允许copy，默认不允许
 */
@property (nonatomic,assign) BOOL enableCopy;

/**
 是否允许全选，默认不允许
 */
@property (nonatomic,assign) BOOL enableSelectAll;

/**
 是否允许选择，默认不允许
 */
@property (nonatomic,assign) BOOL enableChoose;

/**
 键盘类型
 */
@property (nonatomic,assign) TKFtKeyBoardType boardType;

/**
 toolBar的内容文字
 */
@property (nonatomic,copy  ) NSString *contentString;

/**
 输入框宽度
 */
@property (nonatomic,assign) CGFloat textFiledWidth;

/**
 输入框代理
 */
@property (nonatomic,weak  ) id<TKFtTextFieldDelegate>ftdelegate;

/**
 合约信息模型
 */
@property (nonatomic,strong) TKFtInstrumentBean *instrumentBean;

/**
 合约行情模型
 */
@property (nonatomic,strong) TKFtmarketBean *marketBean;


//hs
@property (nonatomic,strong) TKFtHsInstrumentBean *hsinstrumentBean;//恒生合约信息模型
@property (nonatomic,strong) TKFtHsmarketBean *hsmarketBean;//恒生合约行情模型


/**
 给输入框设置赋值数据
 
 @param marketBean 行情模型
 @param capitalBean 资金模型
 @param instrumentBean 合约信息模型
 @param formName 模块名称
 */
-(void)doFreshToolBarWithMarketBean:(TKFtmarketBean *)marketBean
                     andCapitalBean:(TKFtCapitalBean *)capitalBean
                     InstrumentBean:(TKFtInstrumentBean *)instrumentBean
                        andFormName:(NSString *)formName;

/**
 给输入框设置赋值数据
 
 @param instrumentBean 合约信息模型
 @param marketBean 行情模型
 @param formName 模块名称
 */
-(void)doFreshToolBarWithInstrumentBean:(TKFtInstrumentBean *)instrumentBean
                             MarketBean:(TKFtmarketBean *)marketBean
                            andFormName:(NSString *)formName;

/**
 设置最小变动价位
 
 @param showString 最小变动价位
 */
-(void)doFreshToolBarWithShowString:(NSString *)showString;

/**
 设置可平数
 
 @param canFlatStr 可平数
 */
-(void)doFreshToolBarWithcanFlatStr:(NSString *)canFlatStr;

/**
 刷新自选股键盘

 @param stringArray 字符数组
 @param instrumentName 当前界面显示合约名称
 */
-(void)doFreshChooseKeyBoardWithStringArray:(NSMutableArray *)stringArray instrumentName:(NSString *)instrumentName;

/**
 * 重新输入
 */
-(void)doFreshFirstEdit;


//hs
-(void)doHsFreshToolBarWithMarketBean:(TKFtHsmarketBean *)marketBean andCapitalBean:(TKFtHsCapitalBean *)capitalBean InstrumentBean:(TKFtHsInstrumentBean *)instrumentBean andFormName:(NSString *)formName;
-(void)doHsFreshToolBarWithMarketBean:(TKFtHsmarketBean *)marketBean andCapitalBean:(TKFtHsCapitalBean *)capitalBean InstrumentBean:(TKFtHsInstrumentBean *)instrumentBean completion:(void(^)(NSString *canOpenStr))completion;
-(void)doHsFreshToolBarWithInstrumentBean:(TKFtHsInstrumentBean *)instrumentBean MarketBean:(TKFtHsmarketBean *)marketBean andFormName:(NSString *)formName;

//云条件单
-(void)doFreshToolBarWithMarketBean:(TKFtHsmarketBean *)marketBean andCapitalBean:(TKFtCapitalBean *)capitalBean InstrumentBean:(TKFtHsInstrumentBean *)instrumentBean completion:(void(^)(NSString *canOpenStr))completion;

@end

