//
//  InsuranceDetailView.m
//  
//
//  Created by LiuZach on 15/12/25.
//
//

#import "InsuranceDetailView.h"
#import "InsuranceTableViewCell.h"
#import "define.h"
#import "UIButton+WebCache.h"
#import "NetWorkHandler+saveOrUpdateCustomerCar.h"
#import "NetWorkHandler+saveOrUpdateCustomer.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation InsuranceDetailView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self.tableview registerNib:[UINib nibWithNibName:@"InsuranceTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.lbTitle.text = @"投保资料";
        [self.btnEdit setImage:ThemeImage(@"edit_profile") forState:UIControlStateNormal];
        [self.btnEdit setTitle:@"详情" forState:UIControlStateNormal];
        [self.btnEdit setTitleColor:_COLOR(0x75, 0x75, 0x75) forState:UIControlStateNormal];
        self.btnHConstraint.constant = 54;
        
//        self.tableview.hidden = YES;
    }
    
    return self;
}

- (CGFloat) resetSubviewsFrame
{
    NSInteger num = [self tableView:self.tableview numberOfRowsInSection:0];
    CGFloat tableheight = 0;
    for (int i = 0; i < num; i++) {
        tableheight += [self tableView:self.tableview heightForRowAtIndexPath:[NSIndexPath indexPathForRow:num inSection:0]];
    }
    
    return tableheight + 58 + 18;
}

- (void) doEditButtonClicked:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyModifyInsuranceInfo:)]){
        [self.delegate NotifyModifyInsuranceInfo:self];
    }
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *content ;
    if(row == 0){
        content = _carInfo.carNo;
    }
    else{
        content = _carInfo.carOwnerCard;
    }
    if(content == nil || [content length] == 0)
    {
        return 70;
    }
    return 102;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    InsuranceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"InsuranceTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    
    cell.imgV1.tag = 100 + row * 2;
    cell.imgV2.tag = 100 + row * 2 + 1;
    [cell.imgV1 addTarget:self action:@selector(doBtnAddImage:) forControlEvents:UIControlEventTouchUpInside];
    [cell.imgV2 addTarget:self action:@selector(doBtnAddImage:) forControlEvents:UIControlEventTouchUpInside];
    
    if(row == 0){
        [self setCellData:cell title:@"行驶证" value:@"(正本／副本)" content:_carInfo.carNo img1:self.carInfo.travelCard1 placeholderImage1:@"driveLisence1" img2:self.carInfo.travelCard2 placeholderImage2:@"driveLisence2"];
        if(driveLisence1 != nil){
            [cell.imgV1 setImage:driveLisence1 forState:UIControlStateNormal];
        }
        if(driveLisence2 != nil){
            [cell.imgV2 setImage:driveLisence2 forState:UIControlStateNormal];
        }
    }
    else if (row == 1){
        [self setCellData:cell title:@"车主身份证" value:@"(正面／反面)" content:_carInfo.carOwnerCard img1:self.customerInfo.detailModel.cardNumberImg1 placeholderImage1:@"cert1" img2:self.customerInfo.detailModel.cardNumberImg2 placeholderImage2:@"cert2"];
        if(cert1 != nil){
            [cell.imgV1 setImage:cert1 forState:UIControlStateNormal];
        }
        if(cert2 != nil){
            [cell.imgV2 setImage:cert2 forState:UIControlStateNormal];
        }
    } ;
    
    return cell;
}

- (void) setCellData:(InsuranceTableViewCell *) cell title:(NSString *)title value:(NSString *) value content:(NSString *) content img1:(NSString *) img1 placeholderImage1:(NSString *)placeholderImage1 img2:(NSString *)img2 placeholderImage2:(NSString *)placeholderImage2
{
    cell.lbTitle.text = title;
    cell.lbDetail.text = value;
    cell.lbContent.text = content;
    if(content == nil || [content length] == 0){
        cell.contentVConstraint.constant = 0;
        cell.spaceVConstraint.constant = 0;
    }else{
        cell.contentVConstraint.constant = 22;
        cell.spaceVConstraint.constant = 10;
    }
    [cell.imgV1 sd_setImageWithURL:[NSURL URLWithString:img1] forState:UIControlStateNormal placeholderImage:ThemeImage(placeholderImage1)];
    [cell.imgV2 sd_setImageWithURL:[NSURL URLWithString:img2] forState:UIControlStateNormal placeholderImage:ThemeImage(placeholderImage2)];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void) setCarInfo:(CarInfoModel *)model
{
    _carInfo = model;
    [self.tableview reloadData];
}

- (void) doBtnAddImage:(UIButton *) sender
{
    int tag = sender.tag - 100;
    BOOL flag = YES;
    if(tag == 0){
        if(self.carInfo.travelCard1 == nil)
            flag = NO;
    }
    else if (tag == 1){
        if(self.carInfo.travelCard2 == nil)
            flag = NO;
    }
    else if (tag ==2 ){
        if(self.customerInfo.detailModel.cardNumberImg1 == nil)
            flag = NO;
    }
    else{
        if(self.customerInfo.detailModel.cardNumberImg2 == nil)
            flag = NO;
    }
    [self addImage:flag];
    addImgButton = sender;
}

/*
 flag : YES，显示查看原图
 flag : NO, 不显示查看原图
 */
- (void) addImage:(BOOL) flag
{
    if(flag){
        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@""
                                                        delegate:(id)self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"从相册选取", @"拍照",@"查看原图",nil];
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

#pragma mark- UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.pVc dismissViewControllerAnimated:YES completion:^{
        NSData * imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"],0.5);
        UIImage *image= [UIImage imageWithData:imageData];
        image = [Util fitSmallImage:image scaledToSize:imgLicenseSize];
//        self.imgLicense.image = image;
        [addImgButton setImage:image forState:UIControlStateNormal];
        int tag = addImgButton.tag - 100;
        if(tag == 0){
            driveLisence1 = image;
            [self saveOrUpdateCustomerCar:image travelCard2:nil];
        }
        else if (tag == 1){
            driveLisence2 = image;
            [self saveOrUpdateCustomerCar:nil travelCard2:image];
        }
        else if (tag ==2 ){
            cert1 = image;
            [self saveOrUpdateCustomer:image cert2:nil];
        }
        else{
            cert2 = image;
            [self saveOrUpdateCustomer:nil cert2:image];
        }
    }];
}

#pragma mark- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        //
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            pickerImage.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            pickerImage.delegate      = (id)self;
            pickerImage.allowsEditing = YES;
            //
            [self.pVc presentViewController:pickerImage animated:YES completion:nil];
        }
        
    }else if (buttonIndex == 1)
    {
//        [Util openCamera:self.pVc allowEdit:YES completion:^{}];
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        //
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            pickerImage.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            pickerImage.delegate      = (id)self;
            pickerImage.allowsEditing = YES;
            //
            [self.pVc presentViewController:pickerImage animated:YES completion:nil];
        }
    }
    else if (buttonIndex == 2){
        if(actionSheet.tag == 1002){
            addImgButton = nil;
            return;
        }
        int tag = addImgButton.tag - 100;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if(tag / 2 == 0){
            [self addObject:self.carInfo.travelCard1 array:array];
            [self addObject:self.carInfo.travelCard2 array:array];
        }
        else{
            [self addObject:self.customerInfo.detailModel.cardNumberImg1 array:array];
            [self addObject:self.customerInfo.detailModel.cardNumberImg2 array:array];
        }
        _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
        [_imageList addImagesURL:array withSmallImage:nil];
        [self.window addSubview:_imageList];
        addImgButton = nil;
    }
    else{
        addImgButton = nil;
    }
}

- (void) addObject:(NSString *) path array:(NSMutableArray *) array;
{
    if(path != nil)
        [array addObject:path];
}

-(void)dismissImageAction:(UIImageView*)sender
{
    NSLog(@"dismissImageAction");
    [_imageList removeFromSuperview];
    _imageList = nil;
}

- (void) saveOrUpdateCustomerCar:(UIImage *) travelCard1 travelCard2:(UIImage *)travelCard2
{
    [ProgressHUD show:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        NSString *filePahe1 = [self fileupMothed:travelCard1];
        NSString *filePahe2 = [self fileupMothed:travelCard2];
        
        [NetWorkHandler requestToSaveOrUpdateCustomerCar:self.carInfo.customerCarId customerId:self.carInfo.customerId carNo:nil carProvinceId:nil carCityId:nil driveProvinceId:nil driveCityId:nil carTypeNo:nil carShelfNo:nil carEngineNo:nil carOwnerName:nil carOwnerCard:nil carOwnerPhone:nil carOwnerTel:nil carOwnerAddr:nil travelCard1:filePahe1 travelCard2:filePahe2 carRegTime:nil newCarNoStatus:nil carTradeStatus:nil carTradeTime:nil carInsurStatus1:nil carInsurCompId1:nil Completion:^(int code, id content) {
            [ProgressHUD dismiss];
//            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            if(code == 200){
                CarInfoModel *model = self.carInfo;
                if(model == nil){
                    model = [[CarInfoModel alloc] init];
                    self.customerInfo.detailModel.carInfo = model;
                }
                model.customerCarId = [content objectForKey:@"data"];
                model.customerId = self.customerInfo.customerId;
                model.carOwnerName = self.customerInfo.customerName;
            }
        }];
    });
}

- (void) saveOrUpdateCustomer:(UIImage *) cert1 cert2:(UIImage *)cert2
{
    [ProgressHUD show:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        NSString *filePahe1 = [self fileupMothed:cert1];
        NSString *filePahe2 = [self fileupMothed:cert2];
        [NetWorkHandler requestToSaveOrUpdateCustomerWithUID:[UserInfoModel shareUserInfoModel].userId isAgentCreate:self.customerInfo.isAgentCreate customerId:self.carInfo.customerId customerName:nil customerPhone:nil customerTel:nil headImg:nil cardNumber:nil cardNumberImg1:filePahe1 cardNumberImg2:filePahe2 cardProvinceId:nil cardCityId:nil cardAreaId:nil cardVerifiy:self.customerInfo.detailModel.cardVerifiy cardAddr:nil verifiyTime:nil liveProvinceId:nil liveCityId:nil liveAreaId:nil liveAddr:nil customerStatus:self.customerInfo.detailModel.customerStatus drivingCard1:nil drivingCard2:nil customerLabel:nil customerLabelId:nil Completion:^(int code, id content) {
            [ProgressHUD dismiss];
            if(code == 200){
                if(filePahe1 != nil)
                    self.customerInfo.detailModel.cardNumberImg1 = filePahe1;
                if(filePahe2 != nil)
                    self.customerInfo.detailModel.cardNumberImg2 = filePahe2;
            }
        }];
    });
}

-(NSString *)fileupMothed:(UIImage *) image
{
    if(image == nil)
        return nil;
    //图片
    //添加文件名
    @autoreleasepool {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
        AVFile *file = [AVFile fileWithData:imageData];
        [file save];
        
        return file.url;
    }
    
    //文字内容
}

@end
