//
//  UserPolicyListView.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/25.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "UserPolicyListView.h"
#import "PolicyInfoTableViewCell.h"
#import "define.h"
#import "FooterView.h"
#import "InsurInfoModel.h"
#import "UIImageView+WebCache.h"
#import "NetWorkHandler+deleteInsuranceOrder.h"
#import "OrderUtil.h"

@implementation UserPolicyListView
@synthesize footer;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self.tableview registerNib:[UINib nibWithNibName:@"PolicyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.lbTitle.text = @"保单信息";
        [self.btnEdit setImage:ThemeImage(@"refresh") forState:UIControlStateNormal];
        [self.btnEdit setTitle:@"刷新" forState:UIControlStateNormal];
        [self.btnEdit setTitleColor:_COLOR(0x75, 0x75, 0x75) forState:UIControlStateNormal];

        self.btnHConstraint.constant = 54;
        
        footer = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        self.tableview.tableFooterView = footer;
        footer.delegate = self;
    }
    
    return self;
}

- (void) doEditButtonClicked:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToRefresh:)]){
        [self startAnimation];
        [self.delegate NotifyToRefresh:self];
    }
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    PolicyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
//        cell = [[PolicyInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"PolicyInfoTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    InsurInfoModel *model = [self.data objectAtIndex:indexPath.row];
    cell.lbNo.text = model.insuranceOrderNo;
    cell.lbUpdateTime.text = [Util getTimeString:model.updatedAt];
    if(model.insuranceType == 1){
        NSString *carNo = model.carNo;
        if(carNo == nil)
            carNo = @"";
        cell.lbName.text = [NSString stringWithFormat:@"%@", model.customerName];
        cell.lbPlate.text = carNo;
        CGFloat width = [model.carNo sizeWithAttributes:@{NSFontAttributeName:cell.lbPlate.font}].width;
        if(carNo == nil || [carNo length] == 0)
            cell.width.constant = 0;
        else
            cell.width.constant = width + 2;
        if(model.planTypeName_ && [model.planTypeName_ length] > 0)
            cell.lbContent.text = [NSString stringWithFormat:@"（%@）", model.planTypeName_];
        else
            cell.lbContent.text = @"";
        
        if(model.planTypeName_ && [model.planTypeName_ length] > 0)
            cell.contentWidth.constant = 52;
        else
            cell.contentWidth.constant = 10;
        
        cell.lbStatus.attributedText = [OrderUtil getAttributedString:model.orderOfferStatusMsg orderOfferNums:model.orderOfferNums orderOfferStatus:model.orderOfferStatus orderOfferPayPrice:model.orderOfferPayPrice orderOfferStatusStr:(NSString *) model.orderOfferStatusMsg orderOfferGatherStatus:model.orderOfferGatherStatus];
        [OrderUtil setPolicyStatusWithTableCell:cell orderOfferStatusStr:model.orderOfferStatusStr orderImgType:model.orderImgType];
        
        [cell.logoImgV sd_setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:ThemeImage(@"chexian")];
    }
    else{
        NSString *carNo = model.carNo;
        if(carNo == nil)
            carNo = @"";
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
        
//        cell.lbStatus.text = model.orderOfferStatusMsg;
        if(model.orderOfferPayPrice > 0){
            NSString *string = [NSString stringWithFormat:@"价格:¥%.2f", model.orderOfferPayPrice];
            cell.lbStatus.attributedText = [OrderUtil attstringWithString:string range:NSMakeRange(3, [string length] - 3) font:_FONT(18) color:_COLOR(0xf4, 0x43, 0x36)];
        }else
            cell.lbStatus.text = @"";
        [OrderUtil setPolicyStatusWithTableCell:cell orderOfferStatusStr:model.orderOfferStatusStr orderImgType:model.orderImgType];
        
        [cell.logoImgV sd_setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:ThemeImage(@"chexian")];
    }
    
    return cell;
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyHandlePolicyClicked:idx:)]){
        [self.delegate NotifyHandlePolicyClicked:self idx:indexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"commitEditingStyle");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        InsurInfoModel *model = [self.data objectAtIndex:indexPath.row];
        if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyHandleItemDelegateClicked:model:)]){
            [self.delegate NotifyHandleItemDelegateClicked:self model:model];
        }
            // Delete the row from the data source.
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

- (void) deleteItemWithOrderId:(NSString *) orderId Completion:(Completion)completion
{
    [NetWorkHandler requestToDeleteInsuranceOrder:orderId userId:[UserInfoModel shareUserInfoModel].userId Completion:completion];
}

- (void) NotifyToLoadMore:(FooterView *) view
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToLoadMorePloicy:)])
        [self.delegate NotifyToLoadMorePloicy:self];
}

- (void) endLoadMore
{
    FooterView *view = (FooterView*)self.tableview.tableFooterView;
    [view endLoading];
}

@end
