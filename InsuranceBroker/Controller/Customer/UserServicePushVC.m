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
#import "UIButton+WebCache.h"
#import "SharedCustomerModel.h"
#import "NetWorkHandler+shareCustomerAccept.h"
#import "AgentStrategyViewController.h"
#import "HomeVC.h"
#import "RootViewController.h"

@interface UserServicePushVC ()
{
    UIButton *btnInfotips;
}

@end

@implementation UserServicePushVC

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.title = @"分享获客";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分享获客";
    [self.tableview registerNib:[UINib nibWithNibName:@"ServicePushCustomerTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
//    [self SetRightBarButtonWithTitle:@"编辑" color:_COLORa(0xff, 0x66, 0x19, 1) action:YES];
}

- (void) doBtnClicked:(UIButton *)sender
{
    NewUserModel *model = [App_Delegate customerBanner];
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
    return 78.f;
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
    if(model.name == nil)
        cell.lbName.text = model.phone;
    [cell.logoImageV sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:ThemeImage(@"user_head")];
    cell.lbTime.text = [Util getShowingTime:model.createdAt];
    cell.lbType.text = model.insuranceType;
    cell.lbActive.text = model.cooperationSource;

    cell.imageFromV.hidden = NO;
    cell.logoWConstraint.constant = 18;
    cell.logoSepConstraint.constant = 4;
    
    if(model.shareSource == 3 ){
        cell.imageFromV.image = ThemeImage(@"wechat_talk");
    }
    else if (model.shareSource == 4){
        cell.imageFromV.image = ThemeImage(@"qq_talk");
    }
    else if (model.shareSource == 9){
        cell.imageFromV.image = ThemeImage(@"wechat_pengyouquan");
    }
    else if (model.shareSource == 6){
        cell.imageFromV.image = ThemeImage(@"mail_talk");
    }
    else if (model.shareSource == 5){
        cell.imageFromV.image = ThemeImage(@"huodong");
    }else{
        cell.imageFromV.hidden = YES;
        cell.logoWConstraint.constant = 0;
        cell.logoSepConstraint.constant = 0;
    }

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
            [KGStatusBar showSuccessWithStatus:@"获客成功，请返回客户列表查看！"];
            if([self.data count] == 0){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }

    }];
}

- (void) showNoDatasImage:(UIImage *) image
{
    if(!self.explainBgView){
        self.explainBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT - 64)];
        self.imgWithNoData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT - 64)];
        self.imgWithNoData.image = image;
        self.imgWithNoData.contentMode = UIViewContentModeScaleToFill;
        [self.explainBgView addSubview:self.imgWithNoData];
        [self.view addSubview:self.explainBgView];
        
        HighNightBgButton *btnAdd = [[HighNightBgButton alloc] initWithFrame:CGRectMake(0, 0, 200, 41)];
        [self.explainBgView addSubview:btnAdd];
        [btnAdd setImage:ThemeImage(@"fenxianghuoke_btnbg") forState:UIControlStateNormal];
        [btnAdd addTarget:self action:@selector(doBtnShared:) forControlEvents:UIControlEventTouchUpInside];
        btnAdd.center = CGPointMake(self.explainBgView.center.x, self.explainBgView.frame.size.height * 7/8);
    }
}

- (void) doBtnShared:(UIButton *) sender
{
    AgentStrategyViewController *vc = [[AgentStrategyViewController alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    RootViewController *root = [App_Delegate root];
    HomeVC *home = root.homevc;
    vc.category = home.jiHuaShu.category;
    vc.title = home.jiHuaShu.title;
    vc.totalModel = home.jiHuaShu;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
