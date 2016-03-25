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
        self.lbTitle.text = @"车辆信息";
        [self.btnEdit setImage:ThemeImage(@"edit_profile") forState:UIControlStateNormal];
        [self.btnEdit setTitle:@"详情" forState:UIControlStateNormal];
        [self.btnEdit setTitleColor:_COLOR(0x75, 0x75, 0x75) forState:UIControlStateNormal];
        self.btnHConstraint.constant = 54;
        
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, INTMAX_MAX)];
        _footView.backgroundColor = SepLine_color;
        UILabel *lbTitle = [ViewFactory CreateLabelViewWithFont:_FONT(15) TextColor:_COLOR(0x66, 0x90, 0xab)];
        [_footView addSubview:lbTitle];
        lbTitle.text = @"如何进行车险报价？";
        
        _btnShut = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnShut.translatesAutoresizingMaskIntoConstraints = NO;
        [_footView addSubview:_btnShut];
        _btnShut.titleLabel.font = _FONT(15);
        [_btnShut setTitleColor:_COLOR(0xff, 0x66, 0x19) forState:UIControlStateNormal];
        [_btnShut setTitleColor:_COLOR(0xff, 0x66, 0x19) forState:UIControlStateSelected];
        [_btnShut setTitle:@"展开" forState:UIControlStateSelected];
        [_btnShut setTitle:@"关闭" forState:UIControlStateNormal];
        
        UIButton *btnClicked = [[UIButton alloc] initWithFrame:CGRectZero];
        btnClicked.translatesAutoresizingMaskIntoConstraints = NO;
        [_footView addSubview:btnClicked];
        [btnClicked addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_footView addSubview:_contentView];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.clipsToBounds = YES;
        
        lb1 = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0x75, 0x75, 0x75)];
        [_contentView addSubview:lb1];
        lb1.attributedText = [Util getWarningString:@"*   至少需要上传车主［行驶证正本］和［身份证正面］清晰照片方可报价，也可进入［详情］选择填写资料明细（续保车辆只需填写车牌和选择上年保险公司）进行报价。客户确认投保后，应保监会规定需要补齐所有照片方可出单。"];
        lb1.preferredMaxLayoutWidth = ScreenWidth - 40;
        lb1.numberOfLines = 0;
        lb2 = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0x75, 0x75, 0x75)];
        [_contentView addSubview:lb2];
        lb2.preferredMaxLayoutWidth = ScreenWidth - 40;
        lb2.attributedText = [Util getWarningString:@"*   优快保经纪人将保证所有证件资料仅用于车辆报价或投保，绝不用作其它用途，请放心上传。"];
        lb2.numberOfLines = 0;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(lbTitle, _btnShut, _contentView, lb1, lb2, btnClicked);
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbTitle]->=10-[_btnShut(60)]-8-|" options:0 metrics:nil views:views]];
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btnClicked]-20-|" options:0 metrics:nil views:views]];
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentView]-0-|" options:0 metrics:nil views:views]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lb1]-20-|" options:0 metrics:nil views:views]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lb2]-20-|" options:0 metrics:nil views:views]];
        
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[lbTitle(20)]-10-[_contentView]-0-|" options:0 metrics:nil views:views]];
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[btnClicked(40)]->=0-|" options:0 metrics:nil views:views]];
        
        vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[lb1]-20-[lb2]-20-|" options:0 metrics:nil views:views];
        [_contentView addConstraints:vConstraint];
        [_footView addConstraint:[NSLayoutConstraint constraintWithItem:_btnShut attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self doBtnClicked:_btnShut];
        
        [_footView setNeedsLayout];
        [_footView layoutIfNeeded];
        CGSize size = [_footView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        _footView.frame = CGRectMake(0, 0, ScreenWidth, size.height);
        
        self.tableview.tableFooterView = _footView;
    }
    
    return self;
}

- (void) doBtnClicked:(UIButton *)sender
{
    BOOL selected = _btnShut.selected;
    [_contentView removeConstraints:vConstraint];
    NSDictionary *views = NSDictionaryOfVariableBindings( lb1, lb2);
    if(!selected){
        vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lb1(0)]-0-[lb2(0)]-0-|" options:0 metrics:nil views:views];
    }
    else{
        vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[lb1]-20-[lb2]-20-|" options:0 metrics:nil views:views];
    }
    [_contentView addConstraints:vConstraint];
    [_footView setNeedsLayout];
    [_footView layoutIfNeeded];
    CGSize size = [_footView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    _footView.frame = CGRectMake(0, 0, ScreenWidth, size.height);
    _btnShut.selected = !selected;
    self.tableview.tableFooterView = _footView;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToRefreshSubviewFrames)]){
        [self.delegate NotifyToRefreshSubviewFrames];
    }
}

- (CGFloat) resetSubviewsFrame
{
    NSInteger num = [self tableView:self.tableview numberOfRowsInSection:0];
    CGFloat tableheight = 0;
    for (int i = 0; i < num; i++) {
        tableheight += [self tableView:self.tableview heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    return tableheight + 58 + 18 + _footView.frame.size.height;
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
    else if(row == 1){
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
        [self setCellData:cell title:@"车主身份证" value:@"(正面／反面)" content:_carInfo.carOwnerCard img1:self.carInfo.carOwnerCard1 placeholderImage1:@"cert1" img2:self.carInfo.carOwnerCard2 placeholderImage2:@"cert2"];
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
        if(self.carInfo.carOwnerCard1 == nil)
            flag = NO;
    }
    else{
        if(self.carInfo.carOwnerCard2 == nil)
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

#pragma mark- UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.pVc dismissViewControllerAnimated:YES completion:^{
        NSData * imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],0.5);
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
        if(actionSheet.tag == 1002){
            [Util openPhotoLibrary:self.pVc delegate:self allowEdit:NO completion:nil];
            return;
        }else{
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            [self addObject:self.carInfo.travelCard1 array:array];
            [self addObject:self.carInfo.travelCard2 array:array];
            [self addObject:self.carInfo.carOwnerCard1 array:array];
            [self addObject:self.carInfo.carOwnerCard2 array:array];
            
            _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
            [_imageList addImagesURL:array withSmallImage:nil];
            [self.window addSubview:_imageList];
            if(addImgButton.tag == 100){}
            else if (addImgButton.tag == 101){
                if(self.carInfo.travelCard1 == nil)
                    [_imageList setIndex:0];
                else
                    [_imageList setIndex: 1];
            }
            else if (addImgButton.tag == 102){
                if(self.carInfo.carOwnerCard2 == nil)
                    [_imageList setIndex:[array count] - 1];
                else
                    [_imageList setIndex: [array count] - 2];
            }
            else{
                [_imageList setIndex:[array count] - 1];
            }
            addImgButton = nil;
        }
        
    }else if (buttonIndex == 1)
    {
        if(actionSheet.tag == 1002){
            [Util openCamera:self.pVc delegate:self allowEdit:NO completion:nil];
        }else{
           [Util openPhotoLibrary:self.pVc delegate:self allowEdit:NO completion:nil];
        }
    }
    else if (buttonIndex == 2){
        if(actionSheet.tag == 1002){
            addImgButton = nil;
            return;
        }
        else{
            [Util openCamera:self.pVc delegate:self allowEdit:NO completion:nil];
        }
    }
    else{
        addImgButton = nil;
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

- (void) saveOrUpdateCustomerCar:(UIImage *) travelCard1 travelCard2:(UIImage *)travelCard2
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToSubmitImage:travelCard2:image1:cert2:)]){
        [self.delegate NotifyToSubmitImage:travelCard1 travelCard2:travelCard2 image1:nil cert2:nil];
    }
}

- (void) saveOrUpdateCustomer:(UIImage *) image1 cert2:(UIImage *)image2
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToSubmitImage:travelCard2:image1:cert2:)]){
        [self.delegate NotifyToSubmitImage:nil travelCard2:nil image1:image1 cert2:image2];
    }
}


@end
