//
//  KSBaseNavigationController.m
//  Reindeer
//
//  Created by Sword on 1/15/15.
//
//

#import "RDBaseNavigationController.h"

@interface RDBaseNavigationController ()

@end

@implementation RDBaseNavigationController

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.tintColor = COLOR_FONT;
    // [UIColor clearColor], UITextAttributeTextShadowColor,
    //text
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                              NAVIAGETION_BAR_TITLT_COLOR,NSForegroundColorAttributeName,
                                              [UIFont PingFangMediumFontOfSize:17],NSFontAttributeName,
                                              nil];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationBar.translucent = TRUE;
        self.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationBar.backgroundColor = [UIColor whiteColor];
        
    }
#endif
}

#pragma GCC diagnostic pop

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
