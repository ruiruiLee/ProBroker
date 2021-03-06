//
//  RealNameAuthenticationVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/29.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "RealNameAuthenticationVC.h"
#import "define.h"
#import "AVOSCloud/AVOSCloud.h"
#import "UIButton+WebCache.h"
#import "NetWorkHandler+modifyUserInfo.h"

#define imageSize CGSizeMake(200, 120)

@interface RealNameAuthenticationVC ()
{
    NSString *cert1path;
    NSString *cert2path;
}

@end

@implementation RealNameAuthenticationVC

- (void) handleLeftBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) resignFirstResponder
{
    [self.tfCertNo resignFirstResponder];
    [self.tfName resignFirstResponder];
    return [super resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"实名认证";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (void) initData
{
    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
    
    self.tfName.text = model.realName;
    self.tfCertNo.text = model.cardNumber;
    
    self.tfCertNo.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    if(model.cardNumberImg1 != nil && ![model.cardNumberImg1 isKindOfClass:[NSNull class]]){
        [self.btnCert1 sd_setBackgroundImageWithURL:[NSURL URLWithString:FormatImage(model.cardNumberImg1, (int)imageSize.width, (int)imageSize.height)] forState:UIControlStateNormal placeholderImage:ThemeImage(@"add_cert") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imgCer1 = image;
        }];
    }else{
        
    }
    if(model.cardNumberImg2 != nil && ![model.cardNumberImg2 isKindOfClass:[NSNull class]]){
        [self.btnCert2 sd_setBackgroundImageWithURL:[NSURL URLWithString:FormatImage(model.cardNumberImg2, (int)imageSize.width, (int)imageSize.height)] forState:UIControlStateNormal placeholderImage:ThemeImage(@"add_cert") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imgCer2 = image;
        }];
    }else{
        
    }
    
    cert1path = model.cardNumberImg1;
    cert2path = model.cardNumberImg2;
    
    self.viewHConstraint.constant = ScreenWidth;
    
    self.btnSubmit.layer.cornerRadius = 5;
    self.lbWarning.attributedText = [Util getWarningString:@"＊实名认证信息需与持卡人身份一致，否则无法提现！"];
    [self.btnCert1 addTarget:self action:@selector(btnPhotoPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCert2 addTarget:self action:@selector(btnPhotoPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.btnCert1.tag = 1002;
    self.btnCert2.tag = 1003;
    
    [self.btnSubmit addTarget:self action:@selector(doBtnSubmit:) forControlEvents:UIControlEventTouchUpInside];
    self.lbErrorInfo.hidden = YES;
    self.submitVConstraint.constant = 42;
    if(model.cardVerifiy == 1){
        self.btnSubmit.hidden = YES;
        self.tfName.userInteractionEnabled = NO;
        self.tfCertNo.userInteractionEnabled = NO;
        self.submitVConstraint.constant = 0;
        self.submitOffsetVConstraint.constant = 0;
    }
    else if (model.cardVerifiy == 2){
        self.lbErrorInfo.hidden = NO;
        self.lbErrorInfo.text = model.cardVerifiyMsg;
    }
    else if (model.cardVerifiy == 3){
        self.btnSubmit.hidden = YES;
        self.tfName.userInteractionEnabled = NO;
        self.tfCertNo.userInteractionEnabled = NO;
        self.submitVConstraint.constant = 0;
        self.submitOffsetVConstraint.constant = 0;
    }
}

- (void) doBtnSubmit:(UIButton *)sender
{
    [self resignFirstResponder];
    
    NSString *realName = self.tfName.text;
    if(realName == nil || [realName length] <= 1)
    {
        [Util showAlertMessage:@"名字不正确，请重新输入"];
        [self.tfName becomeFirstResponder];
        return;
    }
    NSString *cardNumber = self.tfCertNo.text;
    
    if(![Util validateIdentityCard:cardNumber]){
        [Util showAlertMessage:@"身份证号码不正确，请重新输入"];
        [self.tfCertNo becomeFirstResponder];
        return;
    }
    
    if(imgCer1==nil)
    {
        [Util showAlertMessage:@"请上传身份证正面照片"];
        return;
    }
    
    if(imgCer2==nil)
    {
        [Util showAlertMessage:@"请上传身份证背面照片"];
        return;
    }
    
    [ProgressHUD show:@"正在上传"];
            //添加文件名
    @autoreleasepool {
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
            // cert1

            AVFile *file = [AVFile fileWithName:@"cert1.jpg" data:UIImageJPEGRepresentation(imgCer1, 0.5f)];
            [file save];
            cert1path = file.url;
        });
        dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
            // cert2
            AVFile *file = [AVFile fileWithName:@"cert2.jpg" data: UIImageJPEGRepresentation(imgCer2, 0.5f)];
       
            [file save];

            cert2path = file.url;
        });
        dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
            // 汇总结果
            UserInfoModel *model = [UserInfoModel shareUserInfoModel];
            [NetWorkHandler requestToModifySaveUser:model.userId realName:realName userName:nil phone:nil cardNumber:cardNumber cardNumberImg1:cert1path cardNumberImg2:cert2path liveProvinceId:nil liveCityId:nil liveAreaId:nil liveAddr:nil userSex:nil headerImg:nil cardVerifiy:@"1" Completion:^(int code, id content) {
                
               // [ProgressHUD dismiss];
//                imgCer1=nil;
//                imgCer2=nil;
                [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
                if(code == 200){
                  //  [Util showAlertMessage:@"资料上传成功，等客服人员处理"];
                    model.cardVerifiy = 1;
                    [self.navigationController popViewControllerAnimated:YES];
                    [ProgressHUD showSuccess:@"资料上传成功，等客服人员审核"];
                   
                }else{
                    [ProgressHUD showError:@"资料上传失败，请检测网络"];
                }

            }];

        });
         }
}

#pragma mark- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1001){
        if(buttonIndex == 0){
            NSMutableArray *array = [[NSMutableArray alloc] init];

            if(newimgCer1 ){
                [array addObject:newimgCer1];
            }else{
                if(cert1path)
                    [array addObject:cert1path];
            }
            
            if(newimgCer2 ){
                [array addObject:newimgCer2];
            }else{
                if(cert2path)
                    [array addObject:cert2path];
            }

            
            _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
            [_imageList addImageObjs:array];
            
            [self.view.window addSubview:_imageList];
            if(currentcertType == enumCertType1){
                [_imageList setIndex:0];
            }else{
                if(cert1path || newimgCer1)
                    [_imageList setIndex:1];
            }
        }
        else if (buttonIndex == 1) {
            UserInfoModel *model = [UserInfoModel shareUserInfoModel];
            if (model.cardVerifiy == 1 || model.cardVerifiy == 3){}
            else
                [Util openPhotoLibrary:self allowEdit:NO completion:^{
                }];
            
        }else if (buttonIndex == 2)
        {
            [Util openCamera:self allowEdit:NO completion:^{}];
        }
        else{
            
        }
    }else if(actionSheet.tag == 1002){
        if (buttonIndex == 0) {
            [Util openPhotoLibrary:self allowEdit:NO completion:^{
            }];
            
        }else if (buttonIndex == 1)
        {
            [Util openCamera:self allowEdit:NO completion:^{}];
        }
        else{
            
        }
    }
}

-(void)dismissImageAction:(UIImageView*)sender
{
    NSLog(@"dismissImageAction");
    [_imageList removeFromSuperview];
    _imageList = nil;
}
#pragma mark- UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSData * imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1);
        UIImage *image= [UIImage imageWithData:imageData];
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp)
        {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
        image = [Util scaleToSize:image scaledToSize:CGSizeMake(1500, 1500)];
        if(currentcertType == enumCertType1){
            imgCer1 = image;
            newimgCer1 = image;
            [self.btnCert1 setBackgroundImage: image forState:UIControlStateNormal];
        }
        else{
            imgCer2 = image;
            newimgCer2 = image;
            [self.btnCert2 setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];
    
}
#pragma ACTION
- (void) btnPhotoPressed:(UIButton*)sender{
    [self resignFirstResponder];
    
    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
    UIActionSheet *ac = nil;
    if(sender.tag == 1002){
        currentcertType = enumCertType1;
        if(cert1path != nil){
            if (model.cardVerifiy == 1 || model.cardVerifiy == 3){
                ac = [[UIActionSheet alloc] initWithTitle:@""
                                                 delegate:(id)self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"查看原图",nil];
            }
            else{
                ac = [[UIActionSheet alloc] initWithTitle:@""
                                                 delegate:(id)self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"查看原图", @"从相册选取", @"拍照",nil];
            }
            ac.tag = 1001;
        }else if (newimgCer1){
            ac = [[UIActionSheet alloc] initWithTitle:@""
                                             delegate:(id)self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"查看原图", @"从相册选取", @"拍照",nil];
            ac.tag = 1001;
        }
        else{
            ac = [[UIActionSheet alloc] initWithTitle:@""
                                             delegate:(id)self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"从相册选取", @"拍照",nil];
            ac.tag = 1002;
        }
    }
    else{
        currentcertType = enumCertType2;
        if(cert2path != nil){
            if (model.cardVerifiy == 1 || model.cardVerifiy == 3){
                ac = [[UIActionSheet alloc] initWithTitle:@""
                                                 delegate:(id)self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"查看原图",nil];
            }
            else{
                ac = [[UIActionSheet alloc] initWithTitle:@""
                                                 delegate:(id)self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"查看原图", @"从相册选取", @"拍照",nil];
            }
            ac.tag = 1001;
        }else if (newimgCer2){
            ac = [[UIActionSheet alloc] initWithTitle:@""
                                             delegate:(id)self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"查看原图", @"从相册选取", @"拍照",nil];
            ac.tag = 1001;
        }else{
            ac = [[UIActionSheet alloc] initWithTitle:@""
                                             delegate:(id)self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"从相册选取", @"拍照",nil];
            ac.tag = 1002;
        }
    }
    
    ac.actionSheetStyle = UIBarStyleBlackTranslucent;
    [ac showInView:self.view];
}

@end
