//
//  UserServicePushVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/22.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "UserServicePushVC.h"
#import "ServicePushCustomerTableViewCell.h"
#import "define.h"
#import "NetWorkHandler+shareCustomerList.h"
#import "CustomerInfoModel.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"
#import "SharedCustomerModel.h"
#import "NetWorkHandler+shareCustomerReject.h"
#import "NetWorkHandler+shareCustomerAccept.h"

@interface UserServicePushVC ()
{
    UIButton *btnInfotips;
}

@end

@implementation UserServicePushVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分享获客";
    [self.tableview registerNib:[UINib nibWithNibName:@"ServicePushCustomerTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [self setRightBarButtonWithButton:btnEdit];
    btnEdit.backgroundColor = _COLOR(0xff, 0x66, 0x19);
    [btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
    [btnEdit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnEdit.titleLabel.font = _FONT(14);
    [btnEdit addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) doBtnClicked:(UIButton *)sender
{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    NewUserModel *model = appdelegate.customerBanner;
    if(model.isRedirect){
        WebViewController *web = [IBUIFactory CreateWebViewController];
        web.title = model.title;
        [self.navigationController pushViewController:web animated:YES];
        if(model.url){
            [web loadHtmlFromUrl:model.url];
        }else{
            NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", model.nid];
            [web loadHtmlFromUrl:url];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadData
{
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    
    [NetWorkHandler requestToShareCustomerList:user.userId Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            self.data = [[NSMutableArray alloc] initWithArray:[SharedCustomerModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]]];
            [self.tableview reloadData];
            [AppContext sharedAppContext].pushCustomerNum = [self.data count];
            [[AppContext sharedAppContext] saveData];
        }

    }];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if([self.data count] == 0){
//        [self showNoDatasImage:ThemeImage(@"no_data")];
//    }
//    else{
//        [self hidNoDatasImage];
//    }
    return [self.data count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    ServicePushCustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ServicePushCustomerTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnApply.hidden = NO;
    cell.btnApply.tag = indexPath.row;
    [cell.btnApply addTarget:self action:@selector(doBtnAcceptClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    SharedCustomerModel *model = [self.data objectAtIndex:indexPath.row];

    cell.lbName.text = model.name;
    [cell.logoImageV sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:ThemeImage(@"customer_head")];
    cell.lbTime.text = [Util getShowingTime:model.createdAt];
//
//    NSMutableString *label = [[NSMutableString alloc] init];
//    for (int i = 0; i < [model.customerLabel count]; i++) {
//        [label appendString:[model.customerLabel objectAtIndex:i]];
//        if(i < [model.customerLabel count] - 1){
//            [label appendString:@","];
//        }
//    }
//    
//    cell.lbStatus.text = label;
//    cell.lbTimr.text = [Util getShowingTime:model.createdAt];
//    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:ThemeImage(@"customer_head")];

    return cell;
}

#pragma ACTION
- (void) doBtnAcceptClicked:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    SharedCustomerModel *model = [self.data objectAtIndex:tag];
    [NetWorkHandler requestToAcceptCustomer:model.objectId Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Insert_Customer object:nil];
            [AppContext sharedAppContext].pushCustomerNum --;
            [[AppContext sharedAppContext] saveData];
            [self.data removeObject:model];
            [self.tableview reloadData];
        }

    }];
}

@end
