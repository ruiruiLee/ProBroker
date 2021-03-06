//
//  BaseStrategyView.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/13.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseStrategyView.h"
#import "define.h"
#import "ProductListTableViewCell.h"
#import "NetWorkHandler+queryForProductAttrPageList.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "productAttrModel.h"
#import "UIImageView+WebCache.h"
#import "AVOSCloud.h"
#import "KGStatusBar.h"

@implementation BaseStrategyView
@synthesize pulltable;
@synthesize imgWithNoData;
@synthesize delegate;


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.total = INT_MAX;
        
        self.handler = [[NetWorkHandler alloc] init];
        _data = [[NSMutableArray alloc] init];
        
        [self initSubViews];
        
//        [self refresh2Loaddata];
    }
    
    return self;
}

- (void) initSubViews
{
    pulltable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 580)];
    [self addSubview:pulltable];
    pulltable.delegate = self;
    pulltable.dataSource = self;
    pulltable.pullDelegate = self;
    pulltable.separatorStyle = UITableViewCellSeparatorStyleNone;
    pulltable.translatesAutoresizingMaskIntoConstraints = NO;
     [self.pulltable registerNib:[UINib nibWithNibName:@"ProductListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    pulltable.backgroundColor = [UIColor clearColor];
    pulltable.tableFooterView = [[UIView alloc] init];
    
//    UIEdgeInsets insets = UIEdgeInsetsMake(0, 16, 0, 16);
//    self.pulltable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.pulltable.separatorColor = SepLineColor;
//    if ([pulltable respondsToSelector:@selector(setSeparatorInset:)]) {
//        [pulltable setSeparatorInset:insets];
//    }
//    if ([pulltable respondsToSelector:@selector(setLayoutMargins:)]) {
//        [pulltable setLayoutMargins:insets];
//    }
    
    //弹出下拉刷新控件刷新数据
//    pulltable.pullTableIsRefreshing = YES;
    //    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(pulltable);
    
    self.vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pulltable]-0-|" options:0 metrics:nil views:views];
    [self addConstraints:self.vConstraints];
    
    self.hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pulltable]-0-|" options:0 metrics:nil views:views];
    [self addConstraints:self.hConstraints];
}

- (void) refreshAndReloadData:(NSString *) category list:(NSMutableArray *) list
{
    [self.handler removeAllRequest];
    
    self.category = category;
    self.data = list;
    
    if(list == nil)
        self.data = [[NSMutableArray alloc] init];
    if(list == nil || [list count] == 0){
        [self refresh2Loaddata];
    }else{
        self.pageNum = [list count] / LIMIT;
        if([list count] % LIMIT > 0)
            self.pageNum ++;
    }
    
    [self.pulltable reloadData];
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_data count] == 0){
        [self showNoDatasImage:ThemeImage(@"no_data")];
    }
    else{
        [self hidNoDatasImage];
    }
    return [_data count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 178.f;
    if(indexPath.row < [_data count] - 1)
        return 178.f;
    else
        return 163.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
     ProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ProductListTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    productAttrModel *model = [self.data objectAtIndex:indexPath.row];
    
    [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:Normal_Image];
    cell.lbTitle.text = model.productName;
    cell.lbContent.text = model.productIntro;
    if(model.productSellNums){
        cell.lbCount.hidden = NO;
        cell.lbCount.text = [NSString stringWithFormat:@"已售 %@ 份", model.productSellNums];
    }else{
        cell.lbCount.hidden = YES;
    }
    
    if(model.showPrice){
        cell.lbPrice.hidden = NO;
        cell.lbPrice.text = model.showPrice;
    }
    else{
        cell.lbPrice.hidden = YES;
    }
    
    if(model.productMaxRatio != nil)
        cell.lbRate.text = [self attstringwithRate:model.productMaxRatio];
    else
        cell.lbRate.text = @"";//[self attstringwithRate:@"0"];
    
    if(indexPath.row < [_data count] - 1)
        cell.sepHeight.constant = 15;
    else
        cell.sepHeight.constant = 0;
    
    if(kShenHeBeiAn){
        cell.lbRate.hidden = YES;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(delegate && [delegate respondsToSelector:@selector(NotifyItemSelectIndex:view:)]){
        productAttrModel *model = [self.data objectAtIndex:indexPath.row];
        [self.delegate NotifyItemSelectIndex:model view:self];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 16, 0, 16);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:insets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
}

#pragma PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    [self refresh2Loaddata];
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    [self pullLoadMore];
}

- (void) refreshTable
{
    self.pulltable.pullLastRefreshDate = [NSDate date];
    self.pulltable.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    self.pulltable.pullTableIsLoadingMore = NO;
}

- (void) refresh2Loaddata
{
    NSLog(@"refresh2Loaddata");
    self.pageNum = 0;
    pulltable.pullTableIsRefreshing = YES;
    [self loadDataInPages:self.pageNum];
}

- (void) pullLoadMore
{
    NSLog(@"pullLoadMore");
    self.pageNum = [self.data count];
    if(self.pageNum >= self.total){
        [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:1];
    }else{
        [self loadDataInPages:self.pageNum];
    }
}


/**
 重载此函数获取数据
 */
- (void) loadDataInPages:(NSInteger)page
{
//    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
//    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
//    NSMutableArray *rules = [[NSMutableArray alloc] init];
//    [rules addObject:[self getRulesByField:@"insuranceType" op:@"eq" data:self.category]];
//    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    
    [self.handler requestToQueryForProductAttrPageList:page limit:LIMIT filters:nil userId:[UserInfoModel shareUserInfoModel].userId uuid:[UserInfoModel shareUserInfoModel].uuid insuranceType:self.category completion:^(int code, id content) {
        [self performSelector:@selector(resetTable) withObject:nil afterDelay:0.25];
        if(code == 200){
            if(page == 0)
                [self.data removeAllObjects];
            
            [self.data addObjectsFromArray:[productAttrModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]]];
            self.total = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
            [self.pulltable reloadData];
        }
    }];
}

- (void) resetTable
{
    [self refreshTable];
    [self loadMoreDataToTable];
}

- (NSDictionary *) getRulesByField:(NSString *) field op:(NSString *) op data:(NSString *) data
{
    NSMutableDictionary *rule = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:rule value:field key:@"field"];
    [Util setValueForKeyWithDic:rule value:op key:@"op"];
    [Util setValueForKeyWithDic:rule value:data key:@"data"];
    
    return rule;
}

- (NSAttributedString *) attstringwithPrice:(NSString *) price
{
    NSString *string = [NSString stringWithFormat:@"¥ %@ 起", price];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:@"起"];
    [attString addAttribute:NSFontAttributeName value:_FONT(10) range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:_COLOR(0x75, 0x75, 0x75) range:range];
    return attString;
}

- (NSString *) attstringwithRate:(NSString *) rate
{
    NSString *string = [NSString stringWithFormat:@"推广费:%@", rate];
    if(rate == nil || [rate length] == 0)
        return @"";
    return string;
}

#pragma 登录
- (BOOL) login
{
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    if(!user.uuid){
//        if([WXApi isWXAppInstalled]){
//            WXLoginVC *vc  = [IBUIFactory CreateWXLoginViewController];
//            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
//            [self.parentvc.navigationController presentViewController:naVC animated:YES completion:nil];
//        }
//        else{
            loginViewController *vc = [IBUIFactory CreateLoginViewController];
            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.parentvc.navigationController presentViewController:naVC animated:NO completion:nil];
//        }
        return NO;
    }else{
        return YES;
    }
}

//处理返回数据
- (BOOL) handleResponseWithCode:(NSInteger) code msg:(NSString *)msg
{
    return YES;
}

- (void) showNoDatasImage:(UIImage *) image
{
    if(!self.explainBgView){
        self.explainBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
        imgWithNoData = [[UIImageView alloc] initWithImage:image];
        [self.explainBgView addSubview:imgWithNoData];
        [self.pulltable addSubview:self.explainBgView];
        self.explainBgView.center = CGPointMake(ScreenWidth/2, self.pulltable.frame.size.height/2);
    }else{
        self.explainBgView.center = CGPointMake(ScreenWidth/2, self.pulltable.frame.size.height/2);
    }
}

- (void) hidNoDatasImage
{
    [self.explainBgView removeFromSuperview];
    [imgWithNoData removeFromSuperview];
    self.explainBgView = nil;
    self.imgWithNoData = nil;
}

@end
