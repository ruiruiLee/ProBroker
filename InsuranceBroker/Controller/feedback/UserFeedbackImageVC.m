//
//  UserFeedbackImageVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "UserFeedbackImageVC.h"
#import "IQKeyboardManager.h"
#import "define.h"

@implementation UserFeedbackImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : _COLOR(0x21, 0x21, 0x21)}];
    [self setLeftBarButtonWithImage:ThemeImage(@"arrow_left")];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void) setLeftBarButtonWithImage:(UIImage *) image
{
    UIBarButtonItem *barButtonItemLeft=[[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(handleLeftBarButtonClicked:)];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    barButtonItemLeft.image = image;
    [[self navigationItem] setLeftBarButtonItem:barButtonItemLeft];
}

- (void) handleLeftBarButtonClicked:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
