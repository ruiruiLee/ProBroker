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

#import "LMDropdownView.h"
#import "LMDefaultMenuItemCell.h"

@interface OrderManagerVC () <UISearchBarDelegate>
{
    NSArray *insurArray;
    
//    UISearchBar *searchbar;
//    NSString *filterString;
}

@property (strong, nonatomic) UITableView *menuTableView;
@property (strong, nonatomic) LMDropdownView *dropdownView;

@end

@implementation OrderManagerVC
@synthesize searchbar;
@synthesize filterString;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)viewControllerTitle
{
    return self.viewTitle ? self.viewTitle : self.title;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
        self.insuranceType = @"1";
        
        filterString = @"";
        
        self.mapTypes = @[@{@"orderOfferStatus": @"-1", @"name":@"全部保单"}, @{@"orderOfferStatus": @"1", @"name":@"等待报价"}, @{@"orderOfferStatus": @"2", @"name":@"报价失败"}, @{@"orderOfferStatus": @"3", @"name":@"报价完成"}, @{@"orderOfferStatus": @"4,6", @"name":@"出单配送"}, @{@"orderOfferStatus": @"7", @"name":@"交易失败"}, @{@"orderOfferStatus": @"8", @"name":@"交易成功"}, @{@"orderOfferStatus": @"9", @"name":@"保单过期"}, @{@"orderOfferStatus": @"10", @"name":@"核保失败"}];
        self.currentMapTypeIndex = 0;
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
    
//    self.title = @"我的保单";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePaySuccess) name:Notify_Pay_Success object:nil];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    self.navigationItem.titleView = titleView;
    
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 160, 22)];
    lb.text = @"我的保单";
    lb.font = _FONT_B(18);
    lb.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:lb];
    UIImageView *image = [[UIImageView alloc] initWithImage:ThemeImage(@"xialaliebiao")];
    image.frame = CGRectMake(70, 24, 19, 16);
    [titleView addSubview:image];
    
    HighNightBgButton *btn = [[HighNightBgButton alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    [titleView addSubview:btn];
    [btn addTarget:self action:@selector(doBtnSelectOrderStatus:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) handlePaySuccess
{
    [self refresh2Loaddata];
}

- (void) doBtnSelectOrderStatus:(id) sender
{
    [self.menuTableView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.mapTypes.count * 50)];
    [self.menuTableView reloadData];
    
    // Init dropdown view
    if (!self.dropdownView)
    {
        self.dropdownView = [[LMDropdownView alloc] init];
        self.dropdownView.menuContentView = self.menuTableView;
        self.dropdownView.menuBackgroundColor = [UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
    }
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen])
    {
        [self.dropdownView hide];
    }
    else
    {
        [self.dropdownView showInView:self.view withFrame:self.view.bounds];
    }
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

#pragma mark - DROPDOWN VIEW

- (void)setCurrentMapTypeIndex:(NSInteger)currentMapTypeIndex
{
    _currentMapTypeIndex = currentMapTypeIndex;
    
    
    [self pullTableViewDidTriggerRefresh:self.pulltable];
    
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
    self.pulltable.tag = 100001;
    
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
    
    //menu;
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.tag = 100002;
}

- (void) loadDataInPages:(NSInteger)page
{
    NSInteger offset = page;
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    if(self.insuranceType)
        [rules addObject:[self getRulesByField:@"insuranceType" op:@"eq" data:self.insuranceType]];
    [rules addObject:[self getRulesByField:@"userId" op:@"eq" data:user.userId]];
    [rules addObject:[self getRulesByField:@"customerName" op:@"cn" data:filterString]];
    [rules addObject:[self getRulesByField:@"customerPhone" op:@"cn" data:filterString]];
    [rules addObject:[self getRulesByField:@"carNo" op:@"cn" data:filterString]];
    [rules addObject:[self getRulesByField:@"insuranceOrderNo" op:@"cn" data:filterString]];
    if(_currentMapTypeIndex > 0){
        NSString *orderOfferStatus = [[self.mapTypes objectAtIndex:_currentMapTypeIndex] objectForKey:@"orderOfferStatus"];
        [rules addObject:[self getRulesByField:@"orderOfferStatus" op:@"eq" data:orderOfferStatus]];
    }
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    
    [NetWorkHandler requestToQueryForCustomerInsurPageList:nil
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
    NSInteger tag = tableView.tag;
    
    if( 100001 == tag){
        if([insurArray count] == 0){
            [self showNoDatasImage:ThemeImage(@"no_data")];
        }
        else{
            [self hidNoDatasImage];
        }
        return [insurArray count];
    }
    else
        return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tag = tableView.tag;
    
    if( 100001 == tag){
        NSArray *array = [insurArray objectAtIndex:section];
        return [array count];
    }else
    {
        return self.mapTypes.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag = tableView.tag;
    
    if( 100001 == tag)
        return 110.f;
    else
            
        return 50.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag = tableView.tag;
    
    if( 100001 == tag){
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
        
        cell.statusWidth.constant = 80;
        
        if(model.insuranceType == 1){
            cell.lbName.text = model.customerName;
            cell.lbPlate.text = model.carNo;
            cell.lbPlate.font = _FONT(13);
            
            CGFloat width = [model.carNo sizeWithAttributes:@{NSFontAttributeName:cell.lbPlate.font}].width;
            if(model.carNo && [model.carNo length] > 0)
                cell.width.constant = width + 2;
            else
                cell.width.constant = 0;
            if(model.planTypeName_ && [model.planTypeName_ length] > 0){
                cell.lbContent.text = [NSString stringWithFormat:@"（%@）", model.planTypeName_];//[Util getStringByPlanType:model.planType];
                cell.contentWidth.constant = 52;
            }
            else{
                cell.lbContent.text = @"";
                cell.contentWidth.constant = 10;
            }
            
            
            [cell.phoneNum setTitle:model.customerPhone forState:UIControlStateNormal];
            cell.lbStatus.attributedText = [OrderUtil getAttributedString:model.orderOfferStatusMsg orderOfferNums:model.orderOfferNums orderOfferStatus:model.orderOfferStatus orderOfferPayPrice:model.orderOfferPayPrice orderOfferStatusStr:(NSString *) model.orderOfferStatusMsg orderOfferGatherStatus:model.orderOfferGatherStatus];
            [OrderUtil setPolicyStatusWithCell:cell orderOfferStatusStr:model.orderOfferStatusStr orderImgType:model.orderImgType];
            cell.statusImgV.hidden = YES;
            cell.btnStatus.hidden = NO;
        }else{
            cell.lbName.attributedText = [self getAttributeString:[NSString stringWithFormat:@"投保人:%@", model.customerName] subString:@"投保人:"];
            cell.lbPlate.font = _FONT(13);
            NSString *insuredName = [NSString stringWithFormat:@"被保人:%@", model.insuredName];
            CGFloat width = [insuredName sizeWithAttributes:@{NSFontAttributeName:cell.lbPlate.font}].width;
            if(insuredName && [insuredName length] > 0)
                cell.width.constant = width + 2;
            else
                cell.width.constant = 0;
            cell.lbPlate.attributedText = [self getAttributeString:insuredName subString:@"被保人:"];
            
            cell.lbContent.text = @"";
            cell.contentWidth.constant = 10;
            [cell.phoneNum setTitle:model.customerPhone forState:UIControlStateNormal];
            //        cell.lbStatus.attributedText = [OrderUtil getAttributedString:model.orderOfferStatusMsg orderOfferNums:model.orderOfferNums orderOfferStatus:model.orderOfferStatus orderOfferPayPrice:model.orderOfferPayPrice orderOfferStatusStr:(NSString *) model.orderOfferStatusMsg orderOfferGatherStatus:model.orderOfferGatherStatus];
            //        cell.lbStatus.text = model.orderOfferStatusMsg;
            if(model.orderOfferPayPrice > 0){
                NSString *string = [NSString stringWithFormat:@"价格:¥%.2f", model.orderOfferPayPrice];
                cell.lbStatus.attributedText = [OrderUtil attstringWithString:string range:NSMakeRange(3, [string length] - 3) font:_FONT(18) color:_COLOR(0xf4, 0x43, 0x36)];
            }
            else
                cell.lbStatus.text = @"";
            [OrderUtil setPolicyStatusWithCell:cell orderOfferStatusStr:model.orderOfferStatusStr orderImgType:model.orderImgType];
            
            cell.statusImgV.hidden = NO;
            cell.btnStatus.hidden = NO;
            
            cell.statusWidth.constant = 80;
            CGFloat statusWidth = [model.orderOfferStatusStr sizeWithAttributes:@{NSFontAttributeName:cell.btnStatus.titleLabel.font}].width;
            if(statusWidth + 26 > 80)
                cell.statusWidth.constant = statusWidth + 26;
            else
                cell.statusWidth.constant = 80;
            
            //1等待生效，2保单生效，3保单过期
            if(model.gxbzStatus == 2){
                cell.statusImgV.image = ThemeImage(@"orderValued");
                cell.btnStatus.hidden = YES;
            }
            else if (model.gxbzStatus == 3){
                cell.statusImgV.image = ThemeImage(@"orderExpressed");
                cell.btnStatus.hidden = YES;
            }
            else{
                cell.statusImgV.hidden = YES;
            }
        }
        
        [cell.logoImgV sd_setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:ThemeImage(@"chexian")];
        
        return cell;
    }else{
        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"LMDefaultMenuItemCell" owner:self options:nil];
        LMDefaultMenuItemCell *cell = [xibs firstObject];
        
        // Set data for cell
        NSString *mapType = [[self.mapTypes objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.menuItemLabel.text = mapType;
        cell.selectedMarkView.hidden = (indexPath.row != self.currentMapTypeIndex);
        
        return cell;
    }
}

- (NSMutableAttributedString *) getAttributeString:(NSString *) string subString:(NSString *) subString
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:subString];
    [attString addAttribute:NSFontAttributeName value:_FONT(11) range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:_COLOR(0x75, 0x75, 0x75) range:range];
    return attString;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag = tableView.tag;
    
    if( 100001 == tag){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        NSArray *array = [insurArray objectAtIndex:indexPath.section];
        InsurInfoModel *model = [array objectAtIndex:indexPath.row];
        
        if(model.insuranceType == 1){
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
                    NSString *url = [NSString stringWithFormat:@"%@?insuranceType=%@&orderId=%@&planOfferId=%@", model.clickUrl, @"1", model.insuranceOrderUuid, model.planOfferId];
                    [web initShareUrl:model.insuranceOrderUuid insuranceType:@"1" planOfferId:model.planOfferId];
                    [web loadHtmlFromUrl:url];
                }else{
                    NSString *url = [NSString stringWithFormat:@"%@?insuranceType=%@&orderId=%@", model.clickUrl, @"1", model.insuranceOrderUuid];
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
                NSString *url = [NSString stringWithFormat:@"%@?insuranceType=%@&orderId=%@", model.clickUrl, @"1", model.insuranceOrderUuid];
                [web loadHtmlFromUrl:url];
            }
        }else
        {
            ProductDetailWebVC *web = [IBUIFactory CreateProductDetailWebVC];
            web.title = @"保单详情";
            [self.navigationController pushViewController:web animated:YES];
            NSString *url = [NSString stringWithFormat:@"%@?&orderId=%@", model.clickUrl,  model.insuranceOrderUuid];
            [web loadHtmlFromUrl:url];
        }
    }else{
        [self.menuTableView deselectRowAtIndexPath:indexPath animated:NO];
        
        [self.dropdownView hide];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.dropdownView.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.currentMapTypeIndex = indexPath.row;
        });
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSInteger tag = tableView.tag;
    if( 100001 == tag)
        return 31;
    else
        return 0.01;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger tag = tableView.tag;
    
    if( 100001 == tag){
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
    }else
        return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tag = tableView.tag;
    if( 100001 == tag)
        return YES;
    else
        return NO;
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
                self.total--;
                if(self.total <0)
                    self.total = 0;
            }
            [self.pulltable reloadData];
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
    NSInteger tag = tableView.tag;
    
    if( 100001 == tag)
        return YES;
    else
        return NO;
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
