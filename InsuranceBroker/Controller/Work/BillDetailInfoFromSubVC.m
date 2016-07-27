//
//  BillDetailInfoFromSubVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/3/2.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BillDetailInfoFromSubVC.h"
#import "BIllDetailTableViewCell.h"
#import "define.h"

@implementation BillDetailInfoFromSubVC

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) initData
{
    [self setDataFromSub];
    self.lbTotalAmount.text = [NSString stringWithFormat:@"+%@",self.billInfo.billMoney];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    BIllDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"BIllDetailTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    if(indexPath.row == 0){
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.lbTitle.text = [self.titleArray objectAtIndex:indexPath.row];
    if([self.contentArray count] > indexPath.row)
        cell.lbDetail.text = [self.contentArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //        title = @"报价中";
    
    if(indexPath.row == 0){
        WebViewController *web = [IBUIFactory CreateWebViewController];
        web.title = @"报价详情";
        [self.navigationController pushViewController:web animated:YES];
        NSString *uri = [NSString stringWithFormat:@"%@&shareBut=2", self.billInfo.clickUrl];
        [web loadHtmlFromUrl:uri];
    }
    
}

@end
