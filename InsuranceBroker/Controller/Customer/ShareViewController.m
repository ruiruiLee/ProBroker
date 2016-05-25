//
//  ShareViewController.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/24.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ShareViewController.h"
#import "define.h"
#import "AgentStrategyViewController.h"
#import "RootViewController.h"

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.explainBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT)];
    //        self.imgWithNoData = [[UIImageView alloc] initWithImage:image];
    self.imgWithNoData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT)];
    self.imgWithNoData.image = ThemeImage(@"fenxainghuoke");
    self.imgWithNoData.contentMode = UIViewContentModeScaleToFill;
    [self.explainBgView addSubview:self.imgWithNoData];
    [self.view addSubview:self.explainBgView];
    
    UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 182, 40)];
    [self.explainBgView addSubview:btnAdd];
    btnAdd.backgroundColor = _COLOR(0xf9, 0x15, 0x0a);
    btnAdd.layer.cornerRadius = 4;
    [btnAdd setTitle:@"分享获客" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnAdd.titleLabel.font = _FONT(17);
    [btnAdd addTarget:self action:@selector(doBtnShared:) forControlEvents:UIControlEventTouchUpInside];
    btnAdd.center = CGPointMake(self.explainBgView.center.x, self.explainBgView.frame.size.height * 2/3 + 34 + 60);
}

- (void) doBtnShared:(UIButton *) sender
{
    AgentStrategyViewController *vc = [[AgentStrategyViewController alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    RootViewController *root = appdelegate.root;
    HomeVC *home = root.homevc;
    vc.category = home.jiHuaShu.category;
    vc.title = home.jiHuaShu.title;
    vc.totalModel = home.jiHuaShu;
//    [self.navigationController pushViewController:vc animated:YES];
    UIViewController *pre = self.parentViewController;
    [self.view removeFromSuperview];
    [pre.navigationController pushViewController:vc animated:YES];
}



@end
