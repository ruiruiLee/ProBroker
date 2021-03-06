//
//  IncomeWithdrawVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/3.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "IncomeWithdrawVC.h"
#import "define.h"
#import "NetWorkHandler+queryUserBackCardList.h"
#import "BankCardModel.h"
#import "UIImageView+WebCache.h"
#import "NetWorkHandler+applyForEarn.h"
#import "NetWorkHandler+queryUserNowAdvanceMoney.h"
#import "NetWorkHandler+saveOrUpdateUserBackCard.h"
#import "BaseTableViewCell.h"

@interface IncomeWithdrawVC ()
{
    NSInteger _selectbank;
    
    CGFloat _advanceMoney;//可提现余额
    CGFloat _minLimitMoney;//
    CGFloat _maxLimitMoney;//
}

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation IncomeWithdrawVC

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) notifyToReloadBankList:(NSNotification *) notify
{
    [self loadData];
}

- (void) handleLeftBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) resignFirstResponder
{
    [self.tfAmount resignFirstResponder];
    return [super resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"收益提现";
    _selectbank = -1;
    _advanceMoney = 0;
    
    self.data = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyToReloadBankList:) name:Notify_Add_BankCard object:nil];
    
    UIButton *btnDetail = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
    [btnDetail setTitle:@"提现说明" forState:UIControlStateNormal];
    btnDetail.layer.cornerRadius = 12;
    btnDetail.layer.borderWidth = 0.5;
    btnDetail.layer.borderColor = _COLOR(0xff, 0x66, 0x19).CGColor;
    [btnDetail setTitleColor:_COLOR(0xff, 0x66, 0x19) forState:UIControlStateNormal];
    btnDetail.titleLabel.font = _FONT(12);
    [self setRightBarButtonWithButton:btnDetail];
    
    self.btnSubmit.layer.cornerRadius = 3;
    self.viewHConstraint.constant = ScreenWidth;
    self.tableview.separatorColor = SepLineColor;
    
    self.tableview.tableFooterView = [[UIView alloc] init];
    
//    self.lbExplain.attributedText = [Util getWarningString:@"＊提现金额需大于50元，两个工作日内到账"];
    [self.btnSubmit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:insets];
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableview setLayoutMargins:insets];
    }
    
    [self loadAdvanceMoney];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadData
{
    [NetWorkHandler requesToQueryUserBackCardList:[UserInfoModel shareUserInfoModel].userId backCardStatus:@"1" Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            [self.data removeAllObjects];
            [self.data addObjectsFromArray:[BankCardModel modelArrayFromArray:[content objectForKey:@"data"]]];
            if([self.data count] > 0)
                _selectbank = 0;
            [self.tableview reloadData];
        }
    }];
}

- (void) loadAdvanceMoney
{
    [NetWorkHandler requestToQueryUserNowAdvanceMoney:[UserInfoModel shareUserInfoModel].userId Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            _advanceMoney = [[[content objectForKey:@"data"] objectForKey:@"advanceNowMoney"] floatValue];
            _maxLimitMoney = [[[content objectForKey:@"data"] objectForKey:@"maxLimitMoney"] floatValue];
            _minLimitMoney = [[[content objectForKey:@"data"] objectForKey:@"minLimitMoney"] floatValue];
//            _lbAmmount.text = [NSString stringWithFormat:@"%@元", [Util getDecimalStyle:_advanceMoney]];
            self.lbExplain.attributedText = [Util getWarningString:[NSString stringWithFormat:@"＊提现金额需大于%.2f元，两个工作日内到账", _minLimitMoney]];
            [self.tableview reloadData];
        }
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void) handleRightBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
    
    WebViewController *web = [IBUIFactory CreateWebViewController];
    web.title = @"提现说明";
    [self.tfAmount resignFirstResponder];
    [self.navigationController pushViewController:web animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, @"/news/view/", Withdrawal_Instructions];
    [web loadHtmlFromUrl:url];
}

- (void) submit:(UIButton *)sender
{
    [self resignFirstResponder];
    
    if(_selectbank < 0){
        [Util showAlertMessage:@"请选择使用银行卡"];
        return;
    }
    NSInteger num = [self.tfAmount.text integerValue];
    if(num < _minLimitMoney)
    {
        [Util showAlertMessage:[NSString stringWithFormat:@"提现金额必须大于%.2f元", _minLimitMoney]];
        return;
    }
    if(num > _advanceMoney){
        [Util showAlertMessage:@"超出你所能提取的现金总额"];
        return;
    }
    
    BankCardModel *model = [self.data objectAtIndex:_selectbank];
    [NetWorkHandler requestToApplyForEarn:model.backCardId useId:[UserInfoModel shareUserInfoModel].userId money:self.tfAmount.text Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            _advanceMoney = [[[content objectForKey:@"data"] objectForKey:@"advanceMoneyIng"] floatValue];
            [Util showAlertMessage:[[content objectForKey:@"data"] objectForKey:@"msg"]];
            self.tfAmount.text = @"";
            [self.tfAmount resignFirstResponder];
            [self.tableview reloadData];
            _advanceMoney -= num;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if([self.data count] == 0){
        self.lbExplain.hidden = YES;
        self.btnSubmit.hidden = YES;
        return 1;
    }else{
        self.lbExplain.hidden = NO;
        self.btnSubmit.hidden = NO;
        return 3;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.data count] == 0){
        self.tableVConstraint.constant =  55;
        return 1;
    }
    else{
        self.tableVConstraint.constant = [self.data count] * 60 + 55 + 50 * 2;
        if(section == 0)
            return [self.data count];
        else if(section == 1)
            return 1;
        else
            return 2;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.data count] == 0){
        return 55;
    }
    else{
        if(indexPath.section == 0)
            return 60.f;
        else if (indexPath.section == 1)
            return 55.f;
        else
            return 50;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.data count] == 0){
        NSString *deq = @"cell";
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
        if(!cell){
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
            cell.textLabel.font = _FONT(12);
            cell.textLabel.textColor = _COLOR(0x75, 0x75, 0x75);
            cell.contentView.backgroundColor = _COLOR(245, 245, 245);
        }
        
        cell.textLabel.text = @"添加银行卡";
        cell.imageView.image = ThemeImage(@"add_card");
        
        return cell;
    }
    else{
        if(indexPath.section == 0){
            NSString *deq = @"cell1";
            BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
            if(!cell){
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:deq];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.font = _FONT(15);
                cell.textLabel.textColor = _COLOR(0x21, 0x21, 0x21);
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
                cell.accessoryView = btn;
                [btn setImage:ThemeImage(@"unselect_point") forState:UIControlStateNormal];
                [btn setImage:ThemeImage(@"select_point") forState:UIControlStateSelected];
                
                cell.detailTextLabel.font = _FONT(11);
                cell.detailTextLabel.textColor = _COLOR(0x75, 0x75, 0x75);
                [btn addTarget:self action:@selector(doBankSelect:) forControlEvents:UIControlEventTouchUpInside];
                btn.userInteractionEnabled = NO;
            }
            
            BankCardModel *model = [self.data objectAtIndex:indexPath.row];
            
            cell.imageView.layer.cornerRadius = 20;
            cell.textLabel.text = model.openBackName;
            if(!model.openBackName)
                cell.textLabel.text = model.backName;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.backLogo] placeholderImage:Normal_Logo completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image != nil){
                    UIImage *newimage = [Util fitSmallImage:image scaledToSize:CGSizeMake(40, 40)];
                    cell.imageView.image = newimage;
                }
            }];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"尾号%@", model.backCardTailNo];
            UIButton *btn = (UIButton*)cell.accessoryView;
            btn.tag = 100 + indexPath.row;
            if(indexPath.row == _selectbank){
                btn.selected = YES;
            }else
            {
                btn.selected = NO;
            }
            
            return cell;
        }
        else if(indexPath.section == 1){
            NSString *deq = @"cell2";
            BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
            if(!cell){
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
                cell.textLabel.font = _FONT(12);
                cell.textLabel.textColor = _COLOR(0x75, 0x75, 0x75);
                cell.contentView.backgroundColor = _COLOR(245, 245, 245);
            }
            
            cell.textLabel.text = @"添加提现账户";
            cell.imageView.image = ThemeImage(@"add_card");
            
            return cell;
        }else{
            if(indexPath.row == 1){
                NSString *deq = @"cell3";
                BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
                if(!cell){
                    cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:deq];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.font = _FONT(15);
                    cell.textLabel.textColor = _COLOR(0x21, 0x21, 0x21);
                    
                    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 100, 36)];
                    cell.accessoryView = tf;
                    tf.font = _FONT(15);
                    tf.textColor = _COLOR(0x21, 0x21, 0x21);
                    tf.keyboardType = UIKeyboardTypeNumberPad;
                    
                }
                cell.textLabel.text = @"提现金额";
                self.tfAmount = (UITextField*)cell.accessoryView;
                self.tfAmount.placeholder = [NSString stringWithFormat:@"本次最多可提现%@元", [Util getDecimalStyle:_advanceMoney]];
                
                return cell;
            }else{
                NSString *deq = @"cell4";
                BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
                if(!cell) {
                    cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.font = _FONT(15);
                    cell.textLabel.textColor = _COLOR(0x21, 0x21, 0x21);
                    
                    UILabel *tf = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 160, 36)];
                    cell.accessoryView = tf;
                    tf.font = _FONT(15);
                    tf.textColor = _COLOR(0xff, 0x66, 0x19);
                    tf.textAlignment = NSTextAlignmentRight;
                }
                
                cell.textLabel.text = @"帐户余额（元）";
                UILabel *lb = (UILabel*)cell.accessoryView;
                lb.text = [Util getDecimalStyle:_advanceMoney];
                return cell;
            }
        }
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self resignFirstResponder];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if([self.data count] == 0){
        BindBankCardVC *vc = [IBUIFactory CreateBindBankCardViewController];
        [self.tfAmount resignFirstResponder];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        if(indexPath.section == 1){
            BindBankCardVC *vc = [IBUIFactory CreateBindBankCardViewController];
            [self.tfAmount resignFirstResponder];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.section == 0){
            _selectbank = indexPath.row;
            [self.tableview reloadData];
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    return view;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
     if([self.data count] == 0)
         return NO;
     else{
         if(indexPath.section == 0)
             return YES;
         return NO;
     }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"commitEditingStyle");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *userId = [UserInfoModel shareUserInfoModel].userId;
        BankCardModel *model = [self.data objectAtIndex:indexPath.row];
        
        [NetWorkHandler requestToRemoveBackCard:model.backCardId userId:userId Completion:^(int code, id content) {
            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            if(code == 200){
                [self.data removeObject:model];
                [self.tableview reloadData];

                _selectbank = -1;

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

- (void) doBankSelect:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    _selectbank = tag - 100;
    [self.tableview reloadData];
}

@end
