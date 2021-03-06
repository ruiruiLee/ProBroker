//
//  QRCodeVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/29.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "QRCodeVC.h"
#import "UIImageView+WebCache.h"
#import "define.h"
#import "QRCodeGenerator.h"

@interface QRCodeVC ()

@end

@implementation QRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"二维码名片";
    self.viewHConstraint.constant = ScreenWidth;
    self.photoImg.layer.cornerRadius = 25;
    self.photoImg.layer.borderWidth = 0.5;
    self.photoImg.layer.borderColor = _COLOR(0xe6, 0xe6, 0xe6).CGColor;
    self.photoImg.clipsToBounds = YES;
    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
    UIImage *placeHolderImage = ThemeImage(@"head_male_edit");
    if(model.sex == 2){
        placeHolderImage = ThemeImage(@"head_famale_edit");
    }
    [self.photoImg sd_setImageWithURL:[NSURL URLWithString:model.headerImg] placeholderImage:placeHolderImage];
    self.lbName.text = model.nickname;
    self.lbAdd.text = [Util getAddrWithProvience:model.liveProvince city:model.liveCity];
    self.imgQR.backgroundColor = _COLOR(245, 245, 245);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    NewUserModel *model = [App_Delegate workBanner];
    
    NSString *url = [NSString stringWithFormat:@"%@appId=%@&appShare=1", model.url, [UserInfoModel shareUserInfoModel].uuid];
//    NSString *url = [NSString stringWithFormat:@"%@?uuid=%@&appShare=1", model.url, [UserInfoModel shareUserInfoModel].uuid];
    
    self.imgQR.image = [QRCodeGenerator qrImageForString:url imageSize:self.imgQR.bounds.size.width];
}

@end
