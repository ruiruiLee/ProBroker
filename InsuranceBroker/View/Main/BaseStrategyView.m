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
#import <AVOSCloud/AVOSCloud.h>
#import "KGStatusBar.h"

@implementation BaseStrategyView
@synthesize pulltable;
@synthesize imgWithNoData;


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
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 16, 0, 16);
    self.pulltable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.pulltable.separatorColor = SepLineColor;
    if ([pulltable respondsToSelector:@selector(setSeparatorInset:)]) {
        [pulltable setSeparatorInset:insets];
    }
    if ([pulltable respondsToSelector:@selector(setLayoutMargins:)]) {
        [pulltable setLayoutMargins:insets];
    }
    
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
    self.category = category;
    self.data = list;
    
    [self.handler removeAllRequest];
    
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
    return 110.f;
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
    
    [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:model.productImg] placeholderImage:Normal_Image];
    cell.lbTitle.text = model.productTitle;
    cell.lbContent.text = model.productIntro;
    if(model.productSellNums){
        cell.lbCount.hidden = NO;
        cell.lbCount.text = [NSString stringWithFormat:@"已售 %@ 份", model.productSellNums];
    }else{
        cell.lbCount.hidden = YES;
    }
    
    if(model.minPrice){
        cell.lbPrice.hidden = NO;
        cell.lbPrice.text = [self attstringwithPrice:model.minPrice];
    }
    else{
        cell.lbPrice.hidden = YES;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NewsModel *model = [self.data objectAtIndex:indexPath.row];
//    if(model.isRedirect){
//        WebViewController *web = [IBUIFactory CreateWebViewController];
//        web.title = model.title;
//        web.type = enumShareTypeShare;
//        if(model.imgUrl)
//            web.shareImgArray = [NSArray arrayWithObject:model.imgUrl];
//        web.shareTitle = model.title;
//        web.shareContent = model.content;
//        [self.parentvc.navigationController pushViewController:web animated:YES];
////        [web loadHtmlFromUrl:model.url];
//        if(model.url == nil){
//            [web loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", model.nid]];
//        }else{
//            [web loadHtmlFromUrlWithUserId:model.url];
//        }
//    }
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
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [Util setValueForKeyWithDic:filters value:@"and" key:@"groupOp"];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    [rules addObject:[self getRulesByField:@"insuranceType" op:@"eq" data:self.category]];
    [Util setValueForKeyWithDic:filters value:rules key:@"rules"];
    
    [self.handler requestToQueryForProductAttrPageList:page limit:LIMIT sidx:@"P_ProductAttr.seqNo" sord:@"asc" filters:filters completion:^(int code, id content) {
        [self refreshTable];
        [self loadMoreDataToTable];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            if(page == 0)
                [self.data removeAllObjects];
            
            [self.data addObjectsFromArray:[productAttrModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]]];
            self.total = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
            [self.pulltable reloadData];
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

- (NSString *) attstringwithPrice:(NSString *) price
{
    NSString *string = [NSString stringWithFormat:@"¥ %@", price];
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
//    NSRange range = [string rangeOfString:price];
//    [attString addAttribute:NSFontAttributeName value:_FONT_B(14) range:range];
    return string;
}

#pragma 登录
- (BOOL) login
{
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    if(!user.isLogin){
        if([WXApi isWXAppInstalled]){
            WXLoginVC *vc  = [IBUIFactory CreateWXLoginViewController];
            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.parentvc.navigationController presentViewController:naVC animated:YES completion:nil];
        }
        else{
            loginViewController *vc = [IBUIFactory CreateLoginViewController];
            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.parentvc.navigationController presentViewController:naVC animated:NO completion:nil];
        }
        return NO;
    }else{
        return YES;
    }
}

//处理返回数据
- (BOOL) handleResponseWithCode:(NSInteger) code msg:(NSString *)msg
{
    BOOL result = YES;
    if(code != 200){
        if (code == 504){
            UserInfoModel *user = [UserInfoModel shareUserInfoModel];
            user.isLogin = NO;
            AVInstallation *currentInstallation = [AVInstallation currentInstallation];
            [currentInstallation removeObject:@"ykbbrokerLoginUser" forKey:@"channels"];
            [currentInstallation removeObject:[UserInfoModel shareUserInfoModel].userId forKey:@"channels"];
            [currentInstallation saveInBackground];
            [self login];
        }
        else if(code<0){
            //[KGStatusBar showErrorWithStatus:@"无法连接网络，请稍后再试！"];
        }
        else
             if(msg.length>0)
                [KGStatusBar showErrorWithStatus:msg];
        result = NO;
    }
    return result;
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
