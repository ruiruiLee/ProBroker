//
//  OrderManagerVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/28.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "OrderManagerVC.h"
#import "OrderManagerTableViewCell.h"
#import "NetWorkHandler+queryForCustomerInsurPageList.h"
#import "define.h"
#import "InsurInfoModel.h"
#import "WebViewController.h"
#import "UIImageView+WebCache.h"
#import "NetWorkHandler+deleteInsuranceOrder.h"
#import "OrderUtil.h"

@interface OrderManagerVC () <UISearchBarDelegate>
{
    NSArray *insurArray;
    
//    UISearchBar *searchbar;
//    NSString *filterString;
}

@end

@implementation OrderManagerVC
@synthesize searchbar;
@synthesize filterString;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        filterString = @"";
    }
    
    return self;
}

- (void) handleLeftBarButtonClicked:(id)sender
{
    [searchbar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的保单";
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.pulltable registerNib:[UINib nibWithNibName:@"OrderManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.pulltable.showsVerticalScrollIndicator = NO;
    
    //弹出下拉刷新控件刷新数据
    self.pulltable.pullTableIsRefreshing = YES;
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3];
    
    PullTableView *pulltable = self.pulltable;
    
    searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    searchbar.placeholder = @"搜索";
    searchbar.showsCancelButton = YES;
    self.pulltable.tableHeaderView = searchbar;
    searchbar.returnKeyType = UIReturnKeySearch;
    searchbar.delegate = self;
    searchbar.text = filterString;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(pulltable);
    
    self.vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pulltable]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.vConstraints];
    
    self.hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pulltable]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.hConstraints];
}

- (void) loadDataInPages:(NSInteger)page
{
    NSInteger offset = page;
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    [rules addObject:[self getRulesByField:@"insuranceType" op:@"eq" data:@"1"]];
    [rules addObject:[self getRulesByField:@"userId" op:@"eq" data:user.userId]];
    [rules addObject:[self getRulesByField:@"customerName" op:@"cn" data:filterString]];
    [rules addObject:[self getRulesByField:@"customerPhone" op:@"cn" data:filterString]];
    [rules addObject:[self getRulesByField:@"carNo" op:@"cn" data:filterString]];
    [rules addObject:[self getRulesByField:@"insuranceOrderNo" op:@"cn" data:filterString]];
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    
    [NetWorkHandler requestToQueryForCustomerInsurPageList:@"1"
                                                    offset:offset
                                                     limit:LIMIT
                                                      sord:@"desc"
                                                   filters:filters
                                                Completion:^(int code, id content) {
                                                    [self refreshTable];
                                                    [self loadMoreDataToTable];
                                                    [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
                                                    if(code == 200){
                                                        NSArray *array = [[content objectForKey:@"data"] objectForKey:@"rows"];
                                                        if(page == 0)
                                                            [self.data removeAllObjects];
                                                        [self.data addObjectsFromArray:[InsurInfoModel modelArrayFromArray:array]];
                                                        self.total = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
                                                        [self initData];
                                                    }
                                                }];
}

- (NSDictionary *) getRulesByField:(NSString *) field op:(NSString *) op data:(NSString *) data
{
    NSMutableDictionary *rule = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:rule value:field key:@"field"];
    [Util setValueForKeyWithDic:rule value:op key:@"op"];
    [Util setValueForKeyWithDic:rule value:data key:@"data"];
    
    return rule;
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if([insurArray count] == 0){
        [self showNoDatasImage:ThemeImage(@"no_data")];
    }
    else{
        [self hidNoDatasImage];
    }
    return [insurArray count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [insurArray objectAtIndex:section];
    return [array count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    OrderManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
//        cell = [[OrderManagerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"OrderManagerTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    NSArray *array = [insurArray objectAtIndex:indexPath.section];
    InsurInfoModel *model = [array objectAtIndex:indexPath.row];
    
    cell.lbNo.text = model.insuranceOrderNo;
    cell.lbName.text = model.customerName;
    cell.lbPlate.text = model.carNo;
    cell.lbContent.text = model.planTypeName;//[Util getStringByPlanType:model.planType];
    [cell.phoneNum setTitle:model.customerPhone forState:UIControlStateNormal];
    cell.lbStatus.attributedText = [OrderUtil getAttributedString:model.orderOfferStatusMsg orderOfferNums:model.orderOfferNums orderOfferStatus:model.orderOfferStatus orderOfferPayPrice:model.orderOfferPayPrice orderOfferStatusStr:(NSString *) model.orderOfferStatusMsg orderOfferGatherStatus:model.orderOfferGatherStatus];
    [OrderUtil setPolicyStatusWithCell:cell orderOfferStatus:model.orderOfferStatus orderOfferStatusStr:model.orderOfferStatusStr orderOfferPrintStatus:model.orderOfferPrintStatus];
    [cell.logoImgV sd_setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:ThemeImage(@"chexian")];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray *array = [insurArray objectAtIndex:indexPath.section];
    InsurInfoModel *model = [array objectAtIndex:indexPath.row];
    NSInteger orderOfferStatus = model.orderOfferStatus;
    
    if (orderOfferStatus == 4 || orderOfferStatus == 5 || orderOfferStatus == 6 || orderOfferStatus == 7 || orderOfferStatus == 8){
        //        title = @"出单配送";
        OrderDetailWebVC *web = [IBUIFactory CreateOrderDetailWebVC];
        web.title = @"报价详情";
        web.type = enumShareTypeShare;
        if(model.productLogo){
            web.shareImgArray = [NSArray arrayWithObject:model.productLogo];
        }
        UserInfoModel *user = [UserInfoModel shareUserInfoModel];
        web.shareTitle = [NSString stringWithFormat:@"我是%@，我是优快保自由经纪人。这是为您定制的投保方案报价，请查阅。电话%@", user.realName, user.phone];
        [self.navigationController pushViewController:web animated:YES];
        web.insModel = model;
        if(model.planOfferId != nil){
            NSString *url = [NSString stringWithFormat:@"%@/car_insur/car_insur_detail.html?insuranceType=%@&orderId=%@&planOfferId=%@", Base_Uri, @"1", model.insuranceOrderUuid, model.planOfferId];
            [web initShareUrl:model.insuranceOrderUuid insuranceType:@"1" planOfferId:model.planOfferId];
            [web loadHtmlFromUrl:url];
        }else{
            NSString *url = [NSString stringWithFormat:@"%@/car_insur/car_insur_detail.html?insuranceType=%@&orderId=%@", Base_Uri, @"1", model.insuranceOrderUuid];
            [web initShareUrl:model.insuranceOrderUuid insuranceType:@"1" planOfferId:model.planOfferId];
            [web loadHtmlFromUrl:url];
        }
    }
    else if (orderOfferStatus == 3){
        OfferDetailsVC *vc = [IBUIFactory CreateOfferDetailsViewController];
        vc.orderId = model.insuranceOrderUuid;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        OrderDetailWebVC *web = [IBUIFactory CreateOrderDetailWebVC];
        web.title = @"报价详情";
        web.insModel = model;
        [self.navigationController pushViewController:web animated:YES];
        NSString *url = [NSString stringWithFormat:@"%@/car_insur/car_insur_detail.html?insuranceType=%@&orderId=%@", Base_Uri, @"1", model.insuranceOrderUuid];
        [web loadHtmlFromUrl:url];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 31)];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 31)];
    [view addSubview:imgv];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 20)];
    [view addSubview:lb];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = _FONT(12);
    lb.textColor = _COLOR(0x75, 0x75, 0x75);
    lb.textAlignment = NSTextAlignmentCenter;
    InsurInfoModel *model = [[insurArray objectAtIndex:section] objectAtIndex:0];
    lb.text = [Util getDayStringWithCh:model.updatedAt];
    
    return view;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"commitEditingStyle");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *array = [insurArray objectAtIndex:indexPath.section];
        InsurInfoModel *model = [array objectAtIndex:indexPath.row];
        [self deleteItemWithOrderId:model.insuranceOrderUuid Completion:^(int code, id content) {
            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            if(code == 200){
                [self.data removeObject:model];
                [self initData];
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


- (void) initData
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    int i = 0;
    while (i < [self.data count]) {
        InsurInfoModel *model = [self.data objectAtIndex:i];
        if((i - 1) < 0){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:model];
            [result addObject:array];
        }
        else{
            InsurInfoModel *model1 = [self.data objectAtIndex:i-1];
            if([[Util getDayString:model.updatedAt] isEqualToString:[Util getDayString:model1.updatedAt]]){
                NSMutableArray *array = [result lastObject];
                [array addObject:model];
            }else{
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:model];
                [result addObject:array];
            }
        }
        
        
        i++;
    }
    
    insurArray = result;
    [self.pulltable reloadData];
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

- (void) deleteItemWithOrderId:(NSString *) orderId Completion:(Completion)completion
{
    [NetWorkHandler requestToDeleteInsuranceOrder:orderId userId:[UserInfoModel shareUserInfoModel].userId Completion:completion];
}

@end
