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
#import "NetWorkHandler+shareCustomerAccept.h"
#import "AgentStrategyViewController.h"
#import "HomeVC.h"
#import "RootViewController.h"
#import "ShareViewController.h"

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
    
//    [self SetRightBarButtonWithTitle:@"编辑" color:_COLORa(0xff, 0x66, 0x19, 1) action:YES];
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

//- (void) handleRightBarButtonClicked:(id)sender
//{
//    BOOL flag = self.tableview.editing;
//    if(flag){
//        [self SetRightBarButtonWithTitle:@"编辑" color:_COLORa(0xff, 0x66, 0x19, 1) action:YES];
//        self.tableview.editing = NO;
//    }else{
//        [self SetRightBarButtonWithTitle:@"完成" color:_COLORa(0xff, 0x66, 0x19, 1) action:YES];
//        self.tableview.editing = YES;
//    }
//}

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
//            if([self.data count] == 0)
//            {
//                ShareViewController *vc = [[ShareViewController alloc] initWithNibName:nil bundle:nil];
//                [self.view.window addSubview:vc.view];
//                [self addChildViewController:vc];
//                vc.view.alpha = 0;
//                [UIView animateWithDuration:1 animations:^{
//                    vc.view.alpha = 1;
//                }];
//            }
        }

    }];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.data count] == 0){
        [self showNoDatasImage:ThemeImage(@"fenxainghuoke")];
    }
    else{
        [self hidNoDatasImage];
    }
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
    cell.lbType.text = model.insuranceType;
    cell.lbActive.text = model.cooperationSource;

    if(model.shareSource == 1 ){
        cell.imageFromV.image = ThemeImage(@"wechat_talk");
    }
    else if (model.shareSource == 2){
        cell.imageFromV.image = ThemeImage(@"qq_talk");
    }
    else if (model.shareSource == 3){
        cell.imageFromV.image = ThemeImage(@"wechat_pengyouquan");
    }
    else if (model.shareSource == 4){
        cell.imageFromV.image = ThemeImage(@"mail_talk");
    }
    else if (model.shareSource == 5){
        cell.imageFromV.image = ThemeImage(@"huodong");
    }

    return cell;
}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        [self.data removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}

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

- (void) showNoDatasImage:(UIImage *) image
{
    if(!self.explainBgView){
        self.explainBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT)];
        self.imgWithNoData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT)];
        self.imgWithNoData.image = image;
        self.imgWithNoData.contentMode = UIViewContentModeScaleToFill;
        [self.explainBgView addSubview:self.imgWithNoData];
        [self.view addSubview:self.explainBgView];
        
        UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 182, 40)];
        [self.explainBgView addSubview:btnAdd];
        btnAdd.backgroundColor = _COLOR(0xf9, 0x15, 0x0a);
        btnAdd.layer.cornerRadius = 4;
        [btnAdd setTitle:@"分享获客" forState:UIControlStateNormal];
        [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnAdd.titleLabel.font = _FONT(17);
        [btnAdd addTarget:self action:@selector(doBtnShared:) forControlEvents:UIControlEventTouchUpInside];
        btnAdd.center = CGPointMake(self.explainBgView.center.x, self.explainBgView.frame.size.height * 2/3 + 34);
    }
}

- (void) doBtnShared:(UIButton *) sender
{
    AgentStrategyViewController *vc = [[AgentStrategyViewController alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    RootViewController *root = appdelegate.root;
    HomeVC *home = root.homevc;
    vc.category = home.jiHuaShu.category;
    vc.title = home.jiHuaShu.title;
    vc.totalModel = home.jiHuaShu;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
