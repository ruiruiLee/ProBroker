//
//  InsurCompanySelectVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/14.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "InsurCompanySelectVC.h"
#import "InsuranceCompanyModel.h"
#import "UIImageView+WebCache.h"
#import "define.h"
#import "InsurCompanySelectTableViewCell.h"

@implementation InsurCompanySelectVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.btnCancel = [[HighNightBgButton alloc] initWithFrame:CGRectMake(ScreenWidth - 48, 19, 40, 30)];
    [self.headView addSubview:self.btnCancel];
    [self.btnCancel setTitle:@"其他" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:_COLOR(0xff, 0x99, 0x16) forState:UIControlStateNormal];
    self.btnCancel.titleLabel.font = _FONT(15);
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.table.separatorColor = SepLineColor;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:insets];
    }
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.table setLayoutMargins:insets];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell1";
    InsurCompanySelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[InsurCompanySelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = _FONT(15);
        cell.textLabel.textColor = _COLOR(0x75, 0x75, 0x75);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIButton *btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [btnSelect setImage:ThemeImage(@"unselect") forState:UIControlStateNormal];
        [btnSelect setImage:ThemeImage(@"select") forState:UIControlStateSelected];
        cell.accessoryView = btnSelect;
        [btnSelect addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnSelect.userInteractionEnabled = NO;
    }
    
    InsuranceCompanyModel *model = [self.titleArray objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:Normal_Logo];
    cell.textLabel.text = model.productName;
    UIButton *btn = (UIButton*)cell.accessoryView;
    if(self.selectIdx == indexPath.row)
        btn.selected = YES;
    else
        btn.selected = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InsurCompanySelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton*)cell.accessoryView;
    btn.selected = YES;
    [self.menuDelegate menuViewController:self AtIndex:indexPath.row];
    self.selectIdx = indexPath.row;
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:insets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
}

- (void) doButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

@end
