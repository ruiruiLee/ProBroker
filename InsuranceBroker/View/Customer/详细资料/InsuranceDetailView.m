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
#import "SepLineLabel.h"

@implementation InsuranceDetailView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self.tableview registerNib:[UINib nibWithNibName:@"InsuranceTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.lbTitle.text = @"车险资料";
        [self.btnEdit setImage:ThemeImage(@"edit_profile") forState:UIControlStateNormal];
        [self.btnEdit setTitle:@"详情" forState:UIControlStateNormal];
        [self.btnEdit setTitleColor:_COLOR(0x75, 0x75, 0x75) forState:UIControlStateNormal];
        self.btnHConstraint.constant = 54;
        
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, INTMAX_MAX)];
        
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectZero];
        [_footView addSubview:bgview];
        bgview.translatesAutoresizingMaskIntoConstraints = NO;
        
        UILabel *lbTitle = [ViewFactory CreateLabelViewWithFont:_FONT_B(15) TextColor:_COLOR(0x66, 0x90, 0xab)];
        [bgview addSubview:lbTitle];
        lbTitle.text = @"如何进行车险报价？";
        
        _btnShut = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnShut.translatesAutoresizingMaskIntoConstraints = NO;
        [bgview addSubview:_btnShut];
        [_btnShut setImage:ThemeImage(@"info_zhankai") forState:UIControlStateSelected];
        [_btnShut setImage:ThemeImage(@"info_guanbi") forState:UIControlStateNormal];
        
        UIButton *btnClicked = [[UIButton alloc] initWithFrame:CGRectZero];
        btnClicked.translatesAutoresizingMaskIntoConstraints = NO;
        [bgview addSubview:btnClicked];
        [btnClicked addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        SepLineLabel *sepline = [[SepLineLabel alloc] initWithFrame:CGRectZero];
        [bgview addSubview:sepline];
        sepline.translatesAutoresizingMaskIntoConstraints = NO;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_footView addSubview:_contentView];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.clipsToBounds = YES;
        
        
        UIButton *btnQuote = [[UIButton alloc] init];
        [_footView addSubview:btnQuote];
        [btnQuote setTitle:@"立即\n报价" forState:UIControlStateNormal];
        btnQuote.translatesAutoresizingMaskIntoConstraints = NO;
        btnQuote.layer.cornerRadius = 24;
        btnQuote.backgroundColor = _COLOR(0xff, 0x66, 0x19);
        btnQuote.titleLabel.font = _FONT_B(14);
        btnQuote.titleLabel.numberOfLines = 2;
        btnQuote.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnQuote.layer.shadowColor = _COLOR(0xff, 0x66, 0x19).CGColor;
        btnQuote.layer.shadowOffset = CGSizeMake(0, 0);
        btnQuote.layer.shadowOpacity = 0.5;
        btnQuote.layer.shadowRadius = 1;
        [btnQuote addTarget:self action:@selector(doBtnCarInsurPlan:) forControlEvents:UIControlEventTouchUpInside];
        
        lb1 = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0x75, 0x75, 0x75)];
        [_contentView addSubview:lb1];
        lb1.attributedText = [self getInsuranceRules:@"＊优快保经纪人提供以下三种报价方式\n \n  1 上传车主［行驶证正本］清晰照片 或者 进入（详情）填写行驶证信息可快速报价，此报价可能与真实价格存在一点偏差，成交最终以真实价格为准。\n\n  2 上传车主［行驶证正本］和［身份证正面］清晰照片 进行精准报价。\n\n  3 续保车辆 只需进入（详情）填写［车牌号］(或传行驶证照片) 并选择［上年度保险］，就可精准报价。"];
        

        lb1.preferredMaxLayoutWidth = ScreenWidth - 40;
        lb1.numberOfLines = 0;
        lb2 = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0x75, 0x75, 0x75)];
        [_contentView addSubview:lb2];
        lb2.preferredMaxLayoutWidth = ScreenWidth - 40;
        lb2.attributedText = [Util getWarningString:@"＊注：客户确认投保后，应保监会规定需要补齐以上所有证件照片方可出单。优快保经纪人将保证所有证件资料仅用于车辆报价或投保，绝不用作其它用途，请放心上传。"];
        lb2.numberOfLines = 0;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(lbTitle, _btnShut, _contentView, lb1, lb2, btnClicked, bgview, sepline, btnQuote);
        [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=24-[lbTitle]-10-[_btnShut]-24-|" options:0 metrics:nil views:views]];
        [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-90-[btnClicked]-20-|" options:0 metrics:nil views:views]];
        [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[sepline]-24-|" options:0 metrics:nil views:views]];
        [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[lbTitle]-10-|" options:0 metrics:nil views:views]];
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentView]-0-|" options:0 metrics:nil views:views]];
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bgview]-0-|" options:0 metrics:nil views:views]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lb1]-20-|" options:0 metrics:nil views:views]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lb2]-20-|" options:0 metrics:nil views:views]];
        
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[bgview(40)]-0-[_contentView]-0-|" options:0 metrics:nil views:views]];
        [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[btnClicked(40)]-0-|" options:0 metrics:nil views:views]];
        [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[sepline(1)]-0-|" options:0 metrics:nil views:views]];
        
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btnQuote(48)]->=0-|" options:0 metrics:nil views:views]];
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnQuote(48)]->=0-|" options:0 metrics:nil views:views]];
        [_footView addConstraint:[NSLayoutConstraint constraintWithItem:btnQuote attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sepline attribute:NSLayoutAttributeBottom multiplier:1 constant:-6]];
        
        vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[lb1]-20-[lb2]-20-|" options:0 metrics:nil views:views];
        [_contentView addConstraints:vConstraint];
        [bgview addConstraint:[NSLayoutConstraint constraintWithItem:_btnShut attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self doBtnClicked:_btnShut];
        
        [_footView setNeedsLayout];
        [_footView layoutIfNeeded];
        CGSize size = [_footView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        _footView.frame = CGRectMake(0, 0, ScreenWidth, size.height);
        
        self.tableview.tableFooterView = _footView;
    }
    
    return self;
}

- (void) doBtnCarInsurPlan:(id) sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToPlanCarInsurance)]){
        [self.delegate NotifyToPlanCarInsurance];
    }
}

- (NSMutableAttributedString *) getInsuranceRules:(NSString *) str{
    NSString *UnitPrice = str;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = [UnitPrice rangeOfString:@"＊"];
    [attString addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf4, 0x43, 0x36) range:range];
    [self setAttributes:attString attribute:NSFontAttributeName value:_FONT_B(13) substr:UnitPrice rootstr:@"1"];
    [self setAttributes:attString attribute:NSFontAttributeName value:_FONT_B(13) substr:UnitPrice rootstr:@"2"];
    [self setAttributes:attString attribute:NSFontAttributeName value:_FONT_B(13) substr:UnitPrice rootstr:@"3"];
    
    [self setAttributes:attString attribute:NSForegroundColorAttributeName value:[UIColor blackColor] substr:UnitPrice rootstr:@"1"];
    [self setAttributes:attString attribute:NSForegroundColorAttributeName value:[UIColor blackColor] substr:UnitPrice rootstr:@"2"];
    [self setAttributes:attString attribute:NSForegroundColorAttributeName value:[UIColor blackColor] substr:UnitPrice rootstr:@"3"];
    
    [self addAttributes:attString substr:UnitPrice rootstr:@"［行驶证正本］"];
    [self addAttributes:attString substr:UnitPrice rootstr:@"［车牌号］"];
    [self addAttributes:attString substr:UnitPrice rootstr:@"［身份证正面］"];
    [self addAttributesBack:attString substr:UnitPrice rootstr:@"［行驶证正本］"];
    [self addAttributes:attString substr:UnitPrice rootstr:@"［上年度保险］"];
    
    return attString;
}

- (void) setAttributes:(NSMutableAttributedString *) str attribute:(NSString *)attribute value:(id)value substr:(NSString *)substr rootstr:(NSString *) rootstr
{
    NSRange range = [substr rangeOfString:rootstr];
    [str addAttribute:attribute value:value range:range];
}

- (void) addAttributesBack:(NSMutableAttributedString *) str substr:(NSString *)substr rootstr:(NSString *) rootstr
{
    NSRange range = [substr rangeOfString:rootstr options:NSBackwardsSearch];
    [str addAttribute:NSFontAttributeName value:_FONT_B(12) range:range];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
}

- (void) addAttributes:(NSMutableAttributedString *) str substr:(NSString *)substr rootstr:(NSString *) rootstr
{
    NSRange range = [substr rangeOfString:rootstr];
    [str addAttribute:NSFontAttributeName value:_FONT_B(12) range:range];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
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
    
    return tableheight + 56 + 10 + 70 + _footView.frame.size.height;
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
    CGSize size1 = cell.imgV1.frame.size;
    [cell.imgV1 sd_setImageWithURL:[NSURL URLWithString:FormatImage(img1, (int)size1.width, (int)size1.height)] forState:UIControlStateNormal placeholderImage:ThemeImage(placeholderImage1)];
    
    CGSize size2 = cell.imgV2.frame.size;
    [cell.imgV2 sd_setImageWithURL:[NSURL URLWithString:FormatImage(img2, (int)size2.width, (int)size2.height)] forState:UIControlStateNormal placeholderImage:ThemeImage(placeholderImage2)];
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
        
        UIImage *new = [Util scaleToSize:image scaledToSize:CGSizeMake(1500, 1500)];
        
        [addImgButton setImage:new forState:UIControlStateNormal];
         NSInteger tag = addImgButton.tag - 100;
        if(tag == 0){
            driveLisence1 = new;
            [self saveOrUpdateCustomerCar:new travelCard2:nil];
        }
        else if (tag == 1){
            driveLisence2 = new;
            [self saveOrUpdateCustomerCar:nil travelCard2:new];
        }
        else if (tag ==2 ){
            cert1 = new;
            [self saveOrUpdateCustomer:new cert2:nil];
        }
        else{
            cert2 = new;
            [self saveOrUpdateCustomer:nil cert2:new];
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
