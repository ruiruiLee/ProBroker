//
//  NoticeDetailListVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/30.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "NoticeDetailListVC.h"
#import "define.h"
#import "NoticeDetailTableViewCell.h"
#import "NetWorkHandler+news.h"
#import "NewsModel.h"
#import "UIImageView+WebCache.h"
#import "OrderManagerVC.h"

@interface NoticeDetailListVC ()
{
    NSArray *_newsArray;
}


@end

@implementation NoticeDetailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubViews
{
    self.pulltable = [[PullTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.pulltable];
    self.pulltable.delegate = self;
    self.pulltable.dataSource = self;
    self.pulltable.pullDelegate = self;
    self.pulltable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.pulltable.translatesAutoresizingMaskIntoConstraints = NO;
    self.pulltable.backgroundColor = [UIColor clearColor];//_COLOR(242, 242, 242);//TableBackGroundColor;
    self.pulltable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.pulltable registerNib:[UINib nibWithNibName:@"NoticeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UITableView *tableview = self.pulltable;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(tableview);
    
    self.hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.hConstraints];
    self.vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.vConstraints];
    
    //弹出下拉刷新控件刷新数据
    self.pulltable.pullTableIsRefreshing = YES;
}

- (void) loadDataInPages:(NSInteger)page
{
    UserInfoModel *model = [UserInfoModel shareUserInfoModel];
    [NetWorkHandler requestToNews:self.category userId:model.userId offset:page limit:LIMIT keyValue:nil completion:^(int code, id content) {
        [self refreshTable];
        [self loadMoreDataToTable];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            if(page == 0)
                [self.data removeAllObjects];
            [self.data addObjectsFromArray:[NewsModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]]];
            [self initData];
            self.total = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
            [self.pulltable reloadData];
        }
    }];
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if([_newsArray count] == 0){
        [self showNoDatasImage:ThemeImage(@"no_data")];
    }
    else{
        [self hidNoDatasImage];
    }
    return [_newsArray count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_newsArray objectAtIndex:section] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *model = [[_newsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return [self getCellHeightWithModel:model];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    NoticeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"NoticeDetailTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }

    NewsModel *model = [[_newsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(model.isRedirect){
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.lbTitle.text = model.title;
    cell.lbContent.text = model.content;
    CGFloat w = ScreenWidth - 40;
    CGFloat h = (ScreenWidth - 40) / 3;
    NSString *path = FormatImage_1(model.imgUrl,(int) w, (int) h);
    [cell.photoImgV sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:Normal_Image];
    if(model.imgUrl == nil && [model.imgUrl length] == 0){
        cell.imgVConstraint.constant = 0.1;
    }else{
        cell.imgVConstraint.constant = h;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NewsModel *model = [[_newsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(model.keyType == 1){//订单信息
        OrderManagerVC *vc = [[OrderManagerVC alloc] initWithNibName:nil bundle:nil];
        vc.filterString = model.keyId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.keyType == 2){//私信
        PrivateMsgVC *web = [IBUIFactory CreatePrivateMsgVC];
        web.title = model.title;
        web.type = enumShareTypeNo;
        web.toUserId = model.senderId;
        [self.navigationController pushViewController:web animated:YES];
        [web loadHtmlFromUrl:model.url];

    }
    else{
        if(model.isRedirect){
            WebViewController *web = [IBUIFactory CreateWebViewController];
//            web.title = model.title;
            web.type = enumShareTypeNo;
//            web.shareTitle = model.title;
//            web.shareContent = model.content;
//            if(model.imgUrl != nil)
//                web.shareImgArray = [NSArray arrayWithObject:model.imgUrl];
            [self.navigationController pushViewController:web animated:YES];
            if(model.url == nil){
                [web loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", model.nid]];
            }else{
                [web loadHtmlFromUrlWithUserId:model.url];
            }
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    
    NewsModel *model = [[_newsArray objectAtIndex:section] objectAtIndex:0];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, ScreenWidth, 20)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = _FONT(12);
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = _COLOR(0x75, 0x75, 0x75);
    [view addSubview:lb];
    lb.text = [Util getDayString:model.createdAt];
    
    return view;
}

- (CGFloat) getCellHeightWithModel:(NewsModel *) model
{
    CGFloat h = 0;
    h += 15;
    h += [self getHeightWithFont:_FONT(15) text:model.title];
    h += 10;
    if(model.imgUrl == nil && [model.imgUrl length] == 0){
        
    }else{
        h += 100;
    }
    h += 12;
    h += [self getHeightWithFont:_FONT(13) text:model.content];
    h += 10;
    if(model.isRedirect || model.keyType == 1){
        h += 3;
        h += 48;
    }
    h += 18;
    return h;
}

- (CGFloat) getHeightWithFont:(UIFont *) font text:(NSString *) text
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(ScreenWidth - 40, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
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
            if([[Util getDayString:model.createdAt] isEqualToString:[Util getDayString:model1.createdAt]]){
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
    
    _newsArray = result;
    [self.pulltable reloadData];
}

@end
