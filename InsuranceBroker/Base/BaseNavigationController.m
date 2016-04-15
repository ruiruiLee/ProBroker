//
//  BaseNavigationController.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/14.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UINavigationBar+statusBarColor.h"
#import "define.h"

@implementation BaseNavigationController

//- (void) viewDidLoad
//{
//    [super viewDidLoad];
////    if ([[NetManager defaultReachability] currentReachabilityStatus]==NotReachable) {
////        [KGStatusBar showErrorWithStatus:@"无法连接网络，请稍后再试！"];
////    }
////    [self performSelector:@selector(regitserSystemAsObserver) withObject:nil afterDelay:0.5f];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    
//    [self.navigationController.navigationBar lt_setBackgroundColor:_COLOR(255, 255, 255)];
//    
//    //    self.navigationController.navigationBar.barStyle = UIBaselineAdjustmentNone;
//    
//    self.view.backgroundColor = _COLOR(0xf5, 0xf5, 0xf5);
//    
//    UIColor * color = _COLOR(0x21, 0x21, 0x21);
//    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
//    self.navigationController.navigationBar.titleTextAttributes = dict;
//    
//    //    [self setBackBarButton];
//    [self setLeftBarButtonWithImage:ThemeImage(@"arrow_left")];
//}
//
//- (void) setLeftBarButtonWithImage:(UIImage *) image
//{
//    UIBarButtonItem *barButtonItemLeft=[[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(handleLeftBarButtonClicked:)];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    barButtonItemLeft.image = image;
//    [[self navigationItem] setLeftBarButtonItem:barButtonItemLeft];
//}

@end
