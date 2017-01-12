//
//  ProductListViewController.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/27.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ProductListViewController.h"
#import "define.h"
#import "ProductListTableViewCell.h"
#import "NetWorkHandler+queryForProductAttrPageList.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "productAttrModel.h"
#import "UIImageView+WebCache.h"
#import "AVOSCloud/AVOSCloud.h"

@implementation ProductListViewController

- (NSString *)viewControllerTitle
{
    return self.viewTitle ? self.viewTitle : self.title;
}


//@synthesize delegate;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.handler = [[NetWorkHandler alloc] init];
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.pulltable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.data count] == 0){
        [self showNoDatasImage:ThemeImage(@"no_data")];
    }
    else{
        [self hidNoDatasImage];
    }
    return [self.data count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return 178.f;
    if(indexPath.row < [self.data count] - 1)
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
    
    [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:model.productImg] placeholderImage:Normal_Image];
    cell.lbTitle.text = model.productTitle;
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
    
    if(indexPath.row < [self.data count] - 1)
        cell.sepHeight.constant = 15;
    else
        cell.sepHeight.constant = 0;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    productAttrModel *m = [self.data objectAtIndex:indexPath.row];
    
    ProductDetailWebVC *web = [IBUIFactory CreateProductDetailWebVC];
    web.title = m.productTitle;
    if(m.productImg != nil)
        web.shareImgArray = [NSArray arrayWithObject:m.productImg];
    
    web.shareContent = m.productIntro;
    web.shareTitle = m.productTitle;
    web.selectProModel = m;
    [self.navigationController pushViewController:web animated:YES];
    [web loadHtmlFromUrlWithUserId:m.clickAddr productId:m.productAttrId];
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
    self.pulltable.pullTableIsRefreshing = YES;
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
    
    [self.handler requestToQueryForProductAttrPageList:page limit:LIMIT sidx:@"P_ProductAttr.seqNo" sord:@"asc" filters:filters userId:[UserInfoModel shareUserInfoModel].userId insuranceType:self.category completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
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

//- (void) showNoDatasImage:(UIImage *) image
//{
//    if(!self.explainBgView){
//        self.explainBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
//        imgWithNoData = [[UIImageView alloc] initWithImage:image];
//        [self.explainBgView addSubview:imgWithNoData];
//        [self.pulltable addSubview:self.explainBgView];
//        self.explainBgView.center = CGPointMake(ScreenWidth/2, self.pulltable.frame.size.height/2);
//    }else{
//        self.explainBgView.center = CGPointMake(ScreenWidth/2, self.pulltable.frame.size.height/2);
//    }
//}
//
//- (void) hidNoDatasImage
//{
//    [self.explainBgView removeFromSuperview];
//    [imgWithNoData removeFromSuperview];
//    self.explainBgView = nil;
//    self.imgWithNoData = nil;
//}

@end
