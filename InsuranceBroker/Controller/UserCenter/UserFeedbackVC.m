//
//  UserFeedbackVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/14.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "UserFeedbackVC.h"
#import "define.h"
#import "IQKeyboardManager.h"
#import "UserInfoModel.h"
#import <objc/runtime.h>
#import "UserFeedbackImageVC.h"

//
#define OBJECTID @"57104fc12e958a005c97b437"

@implementation UserFeedbackVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.objectId = OBJECTID;
    }
    return self;
}

+ (void) load
{
    Method addobject = class_getInstanceMethod([LCUserFeedbackViewController class], @selector(didSelectImageViewOnFeedbackReply:));
    Method logAddobject = class_getInstanceMethod([UserFeedbackVC class], @selector(didSelectImageViewOnFeedbackReplyNew:));
    method_exchangeImplementations(addobject, logAddobject);
    
    Method old = class_getInstanceMethod([LCUserFeedbackViewController class], @selector(addImageButtonClicked:));
    Method new = class_getInstanceMethod([UserFeedbackVC class], @selector(doBtnAddImage:));
    method_exchangeImplementations(old, new);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"消息"];
    self.feedbackTitle = [NSString stringWithFormat:@"%@的记录", [UserInfoModel shareUserInfoModel].phone];
}

- (void) didSelectImageViewOnFeedbackReplyNew:(LCUserFeedbackReply *)feedbackReply
{
    UserFeedbackImageVC *imageViewController = [[UserFeedbackImageVC alloc] initWithNibName:nil bundle:nil];
    imageViewController.image = feedbackReply.attachmentImage;
    [self.navigationController pushViewController:imageViewController animated:YES];
}

- (void) doBtnAddImage:(UIButton *)sender
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.navigationBar.barStyle = UIBarStyleDefault;
    [pickerController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : _COLOR(0x21, 0x21, 0x21)}];
    pickerController.delegate = self;
    pickerController.editing = NO;
    pickerController.allowsEditing = NO;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerController animated:YES completion:nil];
}

////UINavigationController delegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    UIColor *color = _COLOR(0xff, 0x66, 0x19);
//
////    UIBarButtonItem *barButtonItemLeft=[[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(handleLeftBarButtonClicked:)];
////    UIImage *image = ThemeImage(@"arrow_left");
////    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////    barButtonItemLeft.image = image;
////    [viewController.navigationItem setLeftBarButtonItem:barButtonItemLeft];
////    viewController.navigationItem.leftBarButtonItem.tintColor = color;
//
//    viewController.navigationItem.rightBarButtonItem.tintColor = color;
//    [viewController.navigationController.navigationBar addObserver:self forKeyPath:@"backItem" options:NSKeyValueObservingOptionNew context:nil];
//    
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [viewController.navigationController.navigationBar removeObserver:self forKeyPath:@"backItem"];
//    
////    UINavigationItem *back = viewController.navigationController.navigationBar.backItem;
////    if(back){
////        UIBarButtonItem *barButtonItemLeft=[[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(handleLeftBarButtonClicked:)];
////        UIImage *image = ThemeImage(@"arrow_left");
////        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////        barButtonItemLeft.image = image;
////        [viewController.navigationItem setLeftBarButtonItem:barButtonItemLeft];
////        [back setLeftBarButtonItem:barButtonItemLeft];
////    }
//}
//
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    UINavigationItem *back = [change objectForKey:@"new"];
//    if(back){
//        UIBarButtonItem *barButtonItemLeft=[[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(handleLeftBarButtonClicked:)];
//        UIImage *image = ThemeImage(@"arrow_left");
//        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        barButtonItemLeft.image = image;
//        [back setLeftBarButtonItem:barButtonItemLeft];
//    }
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 记录最后阅读时，看到了多少条反馈
}

- (void)setupNavigaionBar {
    switch (self.navigationBarStyle) {
        case LCUserFeedbackNavigationBarStyleBlue: {
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
            UIColor *blue =[UIColor colorWithRed:85.0f/255 green:184.0f/255 blue:244.0f/255 alpha:1];
            self.navigationController.navigationBar.barTintColor = blue;
//            self.closeButtonItem.tintColor = [UIColor whiteColor];
            break;
        }
        case LCUserFeedbackNavigationBarStyleNone:{
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : _COLOR(0x21, 0x21, 0x21)}];
            [self setLeftBarButtonWithImage:ThemeImage(@"arrow_left")];
        }
            break;
        default:
            break;
    }
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
