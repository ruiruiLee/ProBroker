//
//  CustomDetailHeaderView.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/21.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "CustomDetailHeaderView.h"
#import "define.h"

@implementation CustomDetailHeaderView
@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.clipsToBounds = YES;
        
        if (nil != self) {
            self.photoImageV = [self.contentView viewWithTag:1001];
            self.lbName = [self.contentView viewWithTag:1002];
            self.lbMobile = [self.contentView viewWithTag:1003];
            self.lbTag = [self.contentView viewWithTag:1004];
            self.lbSepLine1 = [self.contentView viewWithTag:1005];
            self.lbSepLine2 = [self.contentView viewWithTag:1006];
            self.btnEditUser = [self.contentView viewWithTag:1007];
            self.btnPhone = [self.contentView viewWithTag:1008];
            self.btnMsg = [self.contentView viewWithTag:1009];
            self.btnTageEdit = [self.contentView viewWithTag:1010];
            UIButton *btnEdit = [self.contentView viewWithTag:1011];
            [btnEdit addTarget:self action:@selector(btnPhotoPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.btnEditUser addTarget:self action:@selector(EditUserInfo:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnTageEdit addTarget:self action:@selector(EditUserInfo:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnPhone addTarget:self action:@selector(PhoneUser:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnMsg addTarget:self action:@selector(SendMsgToUser:) forControlEvents:UIControlEventTouchUpInside];
            
            self.lbSepLine1.backgroundColor = _COLOR(222, 222, 222);
            self.lbSepLine2.backgroundColor = _COLOR(222, 222, 222);
        }
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.lbSepLine1.layer.borderWidth = 0.25;
    self.lbSepLine1.layer.borderColor = [UIColor clearColor].CGColor;
    self.lbSepLine2.layer.borderWidth = 0.25;
    self.lbSepLine2.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

- (IBAction)EditUserInfo:(id)sender
{
    if(delegate && [delegate respondsToSelector:@selector(NotifyToEditUserInfo:)]){
        [delegate NotifyToEditUserInfo:self];
    }
}

- (IBAction)PhoneUser:(id)sender
{
    
}

- (IBAction)SendMsgToUser:(id)sender
{
    
}

#pragma mark- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if(actionSheet.tag == 1002){
            [Util openPhotoLibrary:self.pvc delegate:self allowEdit:YES completion:nil];
            return;
        }else{
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            [self addObject:((CustomerDetailVC*) self.pvc).customerinfoModel.headImg array:array];
            
            _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
            [_imageList addImagesURL:array withSmallImage:nil];
            [self.window addSubview:_imageList];
        }
    }else if (buttonIndex == 1)
    {
        if(actionSheet.tag == 1002){
            [Util openCamera:self.pvc delegate:self allowEdit:YES completion:nil];
            return;
        }else
            [Util openPhotoLibrary:self.pvc delegate:self allowEdit:YES completion:nil];
    }
    else if (buttonIndex == 2){
        if(actionSheet.tag == 1002){
            return;
        }
        else
            [Util openCamera:self.pvc delegate:self allowEdit:YES completion:nil];
    }
}

- (BOOL) addObject:(NSString *) path array:(NSMutableArray *) array;
{
    if(path != nil){
        [array addObject:path];
        return YES;
    }else
        return NO;
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
    [self.pvc dismissViewControllerAnimated:YES completion:^{
        NSData * imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"],0.5);
        UIImage *image= [UIImage imageWithData:imageData];
        self.photoImageV.image = image;
        if(delegate && [delegate respondsToSelector:@selector(NotifyToSubmitCustomerHeadImg:)]){
            [delegate NotifyToSubmitCustomerHeadImg:image];
        }
    }];

}
#pragma ACTION
- (IBAction) btnPhotoPressed:(UIButton*)sender{
    if(((CustomerDetailVC*) self.pvc).customerinfoModel.headImg != nil){
        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@""
                                                        delegate:(id)self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"查看原图", @"从相册选取", @"拍照",nil];
        ac.actionSheetStyle = UIBarStyleBlackTranslucent;
        [ac showInView:self];
        ac.tag = 1001;
    }else{
        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@""
                                                        delegate:(id)self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"从相册选取", @"拍照",nil];
        ac.actionSheetStyle = UIBarStyleBlackTranslucent;
        [ac showInView:self];
        ac.tag = 1002;
    }

}

@end
