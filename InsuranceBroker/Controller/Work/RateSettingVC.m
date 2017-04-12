//
//  RateSettingVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/4/1.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "RateSettingVC.h"
#import "define.h"
#import "NetWorkHandler+queryUserInfo.h"
#import "UIImageView+WebCache.h"
#import "NetWorkHandler+querySpecialtyUserInfo.h"
#import "ProductInfoModel.h"
#import "CommissionSetTableViewCell.h"
#import "NetWorkHandler+setSpecialtyUserProductRatio.h"
#import "MyTeamsVC.h"
#import <MessageUI/MessageUI.h>
#import "BaseLineView.h"

@interface RateSettingVC ()<PickViewDelegate>
{
    PickView *_datePicker;
}

@property (nonatomic, strong) NSArray *productList;

@end

@implementation RateSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"设置推广费";
    
    [self loadCommissionInfo];
    
    self.tableView.tableFooterView = [self newFootView];
//    self.tableView.backgroundColor = _COLOR(0xe9, 0xe9, 0xe9);
}

- (UIView *) newFootView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
//    view.backgroundColor = _COLOR(0xe9, 0xe9, 0xe9);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    [view addSubview:line];
    line.backgroundColor = _COLOR(0xe9, 0xe9, 0xe9);
    
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, ScreenWidth, 445*ScreenWidth / 375)];
    [view addSubview:imagev];
    imagev.image = ThemeImage(@"img_Explain");
    
    view.frame = CGRectMake(0, 0, ScreenWidth, 15 + 445*ScreenWidth / 375);
    
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    [self.gradientView setGradientColor:_COLOR(0xff, 0x8c, 0x19) end:_COLOR(0xff, 0x66, 0x19)];
}

- (void) loadData
{
/*    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
    [NetWorkHandler requestToQueryUserInfo:model.userId Completion:^(int code, id content) {
        [self  handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            [self.userinfo setDetailContentWithDictionary1:[content objectForKey:@"data"]];
            [self resetViews];
        }
    }];*/
}
     
- (void) loadCommissionInfo
{
    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
    [NetWorkHandler requestToQuerySpecialtyUserInfo:model.userId insuranceType:@"1" Completion:^(int code, id content) {
        [self  handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            self.productList = [ProductInfoModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"ratioMaps"]];
            [self.tableView reloadData];
        }
    }];
}


#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productList count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    CommissionSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CommissionSetTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    ProductInfoModel *model = [self.productList objectAtIndex:indexPath.row];
    [cell.logo sd_setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:Normal_Image];
    cell.lbAccount.text = model.productName;
    if (model.productRatioStr == nil ){
        cell.lbDetail.text = @"未设置";
    }
    else{
        
        cell.lbDetail.text = [NSString stringWithFormat:@"%.2f%@", model.productRatio, @"%"];
        
        cell.lbDetail.text = [NSString stringWithFormat:@"%d%@", (int)model.productRatio, @"%"];
        
    }
    cell.btnEdit.tag = indexPath.row;
    [cell.btnEdit addTarget:self action:@selector(doBtnModifyRatio:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma ACTION
- (void) doBtnModifyRatio:(UIButton *)sender
{
    
    ProductInfoModel *model = [self.productList objectAtIndex:sender.tag];
    
    
    if(model.productMinRatioStr == nil || model.productMaxRatioStr == nil){
        [Util showAlertMessage:@"该产品还未设置折扣率，请联系你的上级设置！"];
        return;
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = (int)model.productMinRatio; i <= (int)model.productMaxRatio; i++) {
        [array addObject:[NSString stringWithFormat:@"%d%@", i, @"%"]];
    }
    
    [_datePicker removeFromSuperview];
    
    _datePicker = [[PickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
    _datePicker.delegate = self;
    _datePicker.lbTitle.text = [NSString stringWithFormat:@"%@,佣金范围(%d%@－%d%@)", model.productName, (int)model.productMinRatio, @"%", (int)model.productMaxRatio, @"%"];
    //    }
    [_datePicker show];
    _datePicker.tag = sender.tag;
    if(model.productRatio - model.productMinRatio < 0)
        [_datePicker setCurrentSelectIdx:0];
    else
        [_datePicker setCurrentSelectIdx:model.productRatio - model.productMinRatio];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat y = self.tableView.frame.origin.y + 50;//包含picker toolbar的50像素
        y += (sender.tag + 1) * 60;
        if(y - _datePicker.frame.origin.y > 0)
            self.tableView.contentOffset = CGPointMake(0, y - _datePicker.frame.origin.y );
    }];
    
}

#pragma ZHPickViewDelegate

-(void)toobarDonBtnHaveClick:(PickView *)pickView resultString:(NSString *)resultString
{
    ProductInfoModel *model = [self.productList objectAtIndex:pickView.tag];
    [self submitRadio:model.productId productRatio:[resultString floatValue]];
    model.productRatio = [resultString floatValue];
    model.productRatioStr = [NSString stringWithFormat:@"%d", (int)model.productRatio];
    [self.tableView reloadData];
}

- (void) toobarDonBtnCancel:(PickView *)pickView
{
    [UIView animateWithDuration:0.25 animations:^{
//        self.scrollview.contentOffset = CGPointMake(0, 0);
    }];
}

- (void) submitRadio:(NSString *) productId productRatio:(CGFloat) productRatio
{
    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
    [NetWorkHandler requestToSetSpecialtyUserProductRatio:model.userId productId:productId productRatio:productRatio selfDefault:@"1" Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            [Util showAlertMessage:@"设置成功"];
        }
    }];
}


@end
