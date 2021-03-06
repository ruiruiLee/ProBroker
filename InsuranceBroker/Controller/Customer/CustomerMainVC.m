//
//  CustomerMainVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/18.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "CustomerMainVC.h"
#import "CustomerTableViewCell.h"
#import "CustomerTagTableCell.h"
#import "define.h"
#import "UserServicePushVC.h"
#import "NetWorkHandler+queryForPageList.h"
#import "CustomerInfoModel.h"
#import "BackGroundView.h"
#import "NetWorkHandler+saveOrUpdateCustomer.h"

@interface CustomerMainVC ()<BackGroundViewDelegate>
{
    UISearchBar *searchbar;
    NSString *filterString;
    
    BackGroundView *_addview;
}

@end

@implementation CustomerMainVC

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppContext *context = [AppContext sharedAppContext];
    [context removeObserver:self forKeyPath:@"pushCustomerNum"];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        filterString = @"";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppContext *context = [AppContext sharedAppContext];
    [context addObserver:self forKeyPath:@"pushCustomerNum" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyToInsertPushCustomer:) name:Notify_PushCustomer_Got object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyToInsertPushCustomer:) name:Notify_Refresh_OrderList1 object:nil];
    
    self.title = @"客 户";
    
    [self setLeftBarButtonWithImage:nil];
    [self setRightBarButtonWithImage:ThemeImage(@"add")];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCustomerAdd:) name:Notify_Add_NewCustomer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyToInsertPushCustomer:) name:Notify_Insert_Customer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyToRemoveCustomer:) name:Notify_Logout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyToRefreshCustomer:) name:Notify_Login object:nil];
    self.pulltable.backgroundColor = [UIColor whiteColor];
    self.pulltable.tableFooterView = [[UIView alloc] init];
    self.pulltable.tableFooterView.backgroundColor = [UIColor whiteColor];
    
    if([UserInfoModel shareUserInfoModel].uuid == nil || [[UserInfoModel shareUserInfoModel].uuid isEqualToString:youKeUUId])
        [self initNoLoginView];
}

- (void) initNoLoginView
{
    _noLoginView = [[CustomerPageNoLoginView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT - 49) block:^{
        [self login];
    }];
    [self.navigationController.navigationBar addSubview:_noLoginView];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.pulltable reloadData];
}

- (void) notifyToInsertPushCustomer:(NSNotification *)notify
{
    [self refresh2Loaddata];
}

- (void) notifyCustomerAdd:(NSNotification *) notify
{
    [self pullTableViewDidTriggerRefresh:self.pulltable];
}

- (void) notifyToRemoveCustomer:(NSNotification *) notify
{
    [self.data removeAllObjects];
    self.total = 0;
    [self.pulltable reloadData];
}

- (void) notifyToRefreshCustomer:(NSNotification *) notify
{
    [self refresh2Loaddata];
    if(_noLoginView){
        [_noLoginView removeFromSuperview];
        _noLoginView = nil;
    }
}

- (void) initSubViews
{
    self.pulltable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 580) style:UITableViewStyleGrouped];
    [self.view addSubview:self.pulltable];
    self.pulltable.delegate = self;
    self.pulltable.dataSource = self;
    self.pulltable.pullDelegate = self;
    self.pulltable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pulltable.translatesAutoresizingMaskIntoConstraints = NO;
    self.pulltable.backgroundColor = [UIColor clearColor];
    self.pulltable.tableFooterView = [[UIView alloc] init];
    self.pulltable.showsVerticalScrollIndicator = NO;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 16, 0, 16);
    self.pulltable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.pulltable.separatorColor = SepLineColor;
    if ([self.pulltable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.pulltable setSeparatorInset:insets];
    }
    if ([self.pulltable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.pulltable setLayoutMargins:insets];
    }
    
    searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    searchbar.placeholder = @"搜索";
    searchbar.showsCancelButton = YES;
    searchbar.returnKeyType = UIReturnKeySearch;
    searchbar.delegate = self;
    self.pulltable.tableHeaderView = searchbar;
    
    //弹出下拉刷新控件刷新数据
    self.pulltable.pullTableIsRefreshing = YES;
    //    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3];
    
    PullTableView *pulltable = self.pulltable;
    NSDictionary *views = NSDictionaryOfVariableBindings(pulltable);
    
    self.vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pulltable]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.vConstraints];
    
    self.hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pulltable]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.hConstraints];
    
    [self.pulltable registerNib:[UINib nibWithNibName:@"CustomerTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.pulltable registerNib:[UINib nibWithNibName:@"CustomerTagTableCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
}

- (void) handleRightBarButtonClicked:(id)sender
{
    [searchbar resignFirstResponder];
    NewCustomerVC *vc = [IBUIFactory CreateNewCustomerViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    vc.presentvc = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.pulltable reloadData];
    if([UserInfoModel shareUserInfoModel].uuid == nil && _noLoginView == nil)
        [self initNoLoginView];
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if([self.data count] == 0)
        return 1;
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.data count] == 0){
        if(!_addview){
            _addview = [[BackGroundView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 2 / 5 + 6, ScreenWidth, 100)];
            _addview.delegate = self;
        }else{
            [_addview removeFromSuperview];
        }
        [self.pulltable addSubview:_addview];
    }
    else{
        [_addview removeFromSuperview];
    }
    if(section == 0){
        return 2;
    }
    else{
        return [self.data count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        NSString *deq = @"cell1";
        CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
        if(!cell){
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CustomerTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        
        CustomerInfoModel *model = [self.data objectAtIndex:indexPath.row];
        cell.lbName.text = model.customerName;
        if(model.customerName == nil || [model.customerName isKindOfClass:[NSNull class]] || [model.customerName length] == 0)
        {
            cell.lbName.text = Default_Customer_Name;
        }
        cell.lbStatus.text = model.visitType;
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:FormatImage(model.headImg, (int)cell.photoImage.frame.size.width, (int)cell.photoImage.frame.size.height)] placeholderImage:ThemeImage(@"customer_head")];
        cell.headImg = model.headImg;
        if(model.visitType == nil)
            cell.lbStatus.text = @"";
        cell.lbTimr.text = [Util getShowingTime:model.updatedAt];//@"今天 19:08";
        if(model.isAgentCreate == 4)
        {
            cell.logoImage.hidden = NO;
        }else{
            cell.logoImage.hidden = YES;
        }
        return cell;
    }else{
        NSString *deq = @"cell2";
        CustomerTagTableCell *cell = [self.pulltable dequeueReusableCellWithIdentifier:deq];
        if(!cell){
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CustomerTagTableCell" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        
        UIImage *image = nil;
        if(indexPath.row == 0){
            image = ThemeImage(@"push_style_customer");
            cell.lbTitle.text = @"分享获客";
            cell.lbCount.hidden = NO;
            AppContext *context = [AppContext sharedAppContext];
            cell.lbCount.text = [NSString stringWithFormat:@"%ld", (long)context.pushCustomerNum];
            if(context.pushCustomerNum == 0)
                cell.lbCount.hidden = YES;
            else
                cell.lbCount.hidden = NO;
        }
        else{
            image = ThemeImage(@"tag");
            cell.lbTitle.text = @"标签";
            cell.lbCount.hidden = YES;
        }
        cell.photoImage.image = image;
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            UserServicePushVC *vc = [[UserServicePushVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            TagListViewController *vc = [IBUIFactory CreateTagListViewController];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        CustomerDetailVC *vc = [IBUIFactory CreateCustomerDetailViewController];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        CustomerInfoModel *model = [self.data objectAtIndex:indexPath.row];
        vc.customerinfoModel = model;
        [vc performSelector:@selector(loadDetailWithCustomerId:) withObject:model.customerId afterDelay:0.2];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
        view.image = ThemeImage(@"shadow");
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
        imgv.image = ThemeImage(@"shadow");
        imgv.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:imgv];
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        lbTitle.text = @"客户数量";
        lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
        lbTitle.textColor = _COLOR(0x75, 0x75, 0x75);
        lbTitle.font = _FONT(12);
        [view addSubview:lbTitle];
        
        UILabel *lbCount= [[UILabel alloc] initWithFrame:CGRectZero];
        lbCount.translatesAutoresizingMaskIntoConstraints = NO;
        lbCount.textColor = _COLOR(0x75, 0x75, 0x75);
        lbCount.font = _FONT(12);
        lbCount.text = [NSString stringWithFormat:@"%ld人", (long)self.total];
        [view addSubview:lbCount];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(imgv, lbTitle, lbCount);
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imgv]-0-|" options:0 metrics:nil views:views]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[lbTitle]->=10-[lbCount]-12-|" options:0 metrics:nil views:views]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imgv(15)]-0-[lbTitle]-0-|" options:0 metrics:nil views:views]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imgv(15)]-0-[lbCount]-0-|" options:0 metrics:nil views:views]];
        
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 15;
    else
        return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0)
        return NO;
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"commitEditingStyle");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *userId = [UserInfoModel shareUserInfoModel].userId;
        CustomerInfoModel *model = [self.data objectAtIndex:indexPath.row];
        [NetWorkHandler requestToSaveOrUpdateCustomerWithUID:userId isAgentCreate:model.isAgentCreate customerId:model.customerId customerName:nil customerPhone:nil customerTel:nil headImg:nil cardNumber:nil cardNumberImg1:nil cardNumberImg2:nil cardProvinceId:nil cardCityId:nil cardAreaId:nil cardVerifiy:model.detailModel.cardVerifiy cardAddr:nil verifiyTime:nil liveProvinceId:nil liveCityId:nil liveAreaId:nil liveAddr:nil customerStatus:-1 drivingCard1:nil drivingCard2:nil customerLabel:nil customerLabelId:nil customerEmail:nil customerMemo:nil sex:0 Completion:^(int code, id content) {
            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            if(code == 200){
                [self.data removeObject:model];
                [self.pulltable reloadData];
                self.total--;
                if(self.total <0)
                    self.total = 0;
            }
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

//编辑删除按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//这个方法用来告诉表格 某一行是否可以移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete; //每行左边会出现红的删除按钮
}


#pragma UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchbar resignFirstResponder];
    filterString = searchbar.text;
    self.pageNum = 0;
    [self loadDataInPages:self.pageNum];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchbar resignFirstResponder];
    searchbar.text = @"";
    filterString = @"";
    self.pageNum = 0;
    [self loadDataInPages:self.pageNum];
}

- (void) loadDataInPages:(NSInteger)page
{
    if([UserInfoModel shareUserInfoModel].uuid == nil)
        return;
    NSInteger offset = page;
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    [rules addObject:[self getRulesByField:@"customerName" op:@"cn" data:filterString]];
    [rules addObject:[self getRulesByField:@"customerPhone" op:@"cn" data:filterString]];
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    [rules addObject:[self getRulesByField:@"userId" op:@"eq" data:user.userId]];
    [rules addObject:[self getRulesByField:@"bindStatus" op:@"eq" data:@"1"]];
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    
    [NetWorkHandler requestQueryForPageList:offset limit:LIMIT sord:@"desc" filters:filters Completion:^(int code, id content) {
        [self refreshTable];
        [self loadMoreDataToTable];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            [self appendData:[[content objectForKey:@"data"] objectForKey:@"rows"]];
            self.total = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
        }
    }];
}

- (void) appendData:(NSArray *) list
{
    if(self.pageNum == 0)
        [self.data removeAllObjects];
    
    NSArray *array = [CustomerInfoModel modelArrayFromArray:list];
    [self.data addObjectsFromArray:array];
    [self.pulltable reloadData];
}

- (NSDictionary *) getRulesByField:(NSString *) field op:(NSString *) op data:(NSString *) data
{
    NSMutableDictionary *rule = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:rule value:field key:@"field"];
    [Util setValueForKeyWithDic:rule value:op key:@"op"];
    [Util setValueForKeyWithDic:rule value:data key:@"data"];
    
    return rule;
}

#pragma BackGroundViewDelegate
- (void) notifyToAddNewCustomer:(BackGroundView *) view
{
    [self handleRightBarButtonClicked:nil];
}

@end
