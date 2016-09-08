//
//  AgentStrategyViewController.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/12.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "AgentStrategyViewController.h"
#import "AgentStrategyTableViewCell.h"
#import "define.h"
#import "NetWorkHandler+news.h"
#import "NewsModel.h"
#import "UIButton+WebCache.h"

@interface AgentStrategyViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchbar;
@property (nonatomic, strong) NSString *filterString;

@end

@implementation AgentStrategyViewController
@synthesize bannerImageView;
@synthesize totalModel;
@synthesize searchbar;
@synthesize filterString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.pulltable registerNib:[UINib nibWithNibName:@"AgentStrategyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    if(self.totalModel.bannerImg){
        bannerImageView = [[HighNightBgButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, [Util getHeightByWidth:3 height:1 nwidth:ScreenWidth])];
        [bannerImageView addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bannerImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:self.totalModel.bannerImg] forState:UIControlStateNormal placeholderImage:Normal_Image];
        
        if(!self.totalModel.isRedirect){
            bannerImageView.userInteractionEnabled = NO;
        }
        
        self.pulltable.tableHeaderView = bannerImageView;
    }
}

- (void) initSubViews
{
    searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    searchbar.placeholder = @"搜索";
    searchbar.showsCancelButton = YES;
    searchbar.returnKeyType = UIReturnKeySearch;
    searchbar.delegate = self;
    self.pulltable.tableHeaderView = searchbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) doButtonClicked:(UIButton *)sender
{
    if(totalModel.isRedirect){
        WebViewController *web = [IBUIFactory CreateWebViewController];
        web.title = totalModel.title;
        web.type = enumShareTypeShare;
        web.shareTitle = totalModel.title;
        if(totalModel.imgUrl != nil)
            web.shareImgArray = [NSArray arrayWithObject:totalModel.imgUrl];
        [self.navigationController pushViewController:web animated:YES];
        [web loadHtmlFromUrlWithUserId:totalModel.url];
    }
}
/**
 重载此函数获取数据
 */
- (void) loadDataInPages:(NSInteger)page
{
    [NetWorkHandler requestToNews:self.category userId:[UserInfoModel shareUserInfoModel].userId offset:page limit:LIMIT completion:^(int code, id content) {
        [self refreshTable];
        [self loadMoreDataToTable];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            if(page == 0)
                [self.data removeAllObjects];
            
            [self.data addObjectsFromArray:[NewsModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]]];
            self.total = [[[content objectForKey:@"data"] objectForKey:@"total"] integerValue];
            [self.pulltable reloadData];
        }
    }];
}

#pragma UITableViewDataSource UITableViewDelegate

//- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
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
    return 94.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    AgentStrategyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        //        cell = [[AgentStrategyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"AgentStrategyTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    NewsModel *model = [self.data objectAtIndex:indexPath.row];
    
    if(model.isRedirect){
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.photoImgV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:Normal_Image];
    cell.lbTitle.text = model.title;
    cell.lbContent.text = model.content;
    cell.lbTime.text = [Util getShowingTime:model.createdAt];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NewsModel *model = [self.data objectAtIndex:indexPath.row];
    if(model.isRedirect){
        WebViewController *web = [IBUIFactory CreateWebViewController];
        web.title = model.title;
        web.type = enumShareTypeShare;
        if(model.imgUrl)
            web.shareImgArray = [NSArray arrayWithObject:model.imgUrl];
        web.shareTitle = model.title;
        web.shareContent = model.content;
        [self.navigationController pushViewController:web animated:YES];
        if(model.url == nil){
            [web loadHtmlFromUrlWithUserId:[NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", model.nid]];
        }else{
            [web loadHtmlFromUrlWithUserId:model.url];
        }
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

@end
