//
//  BindBankCardVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/3.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BindBankCardVC.h"
#import "define.h"
#import "NetWorkHandler+saveOrUpdateUserBackCard.h"
#import "NetWorkHandler+getBacks.h"
#import "BankInfoModel.h"
#import "BankSelectVC.h"
#import "ProgressHUD.h"
#import "BaseTableViewCell.h"
#import "HighNightBgButton.h"

@interface BindBankCardVC ()<MenuDelegate>
{
    HighNightBgButton *btnSubmit;
    UITextField *_tfName;
    UITextField *_tfCardNum;
    UILabel *_lbBankName;
    
    NSInteger _selectBankIdx;
}

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) BankSelectVC *menu;

@end

@implementation BindBankCardVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"绑定账户";
    _selectBankIdx = -1;
}

- (void) initSubViews
{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableview.backgroundColor = [UIColor clearColor];//_COLOR(242, 242, 242);//TableBackGroundColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.separatorColor = SepLineColor;
    self.tableview.scrollEnabled = NO;
    
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, ScreenWidth - 40, 30)];
    lb.backgroundColor = [UIColor clearColor];
    [header addSubview:lb];
    lb.font = _FONT(11);
    lb.textColor = _COLOR(0x75, 0x75, 0x75);
    lb.attributedText = [Util getWarningString:@"＊请绑定您本人的账户"];
    
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.tableHeaderView = header;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:insets];
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableview setLayoutMargins:insets];
    }
    
    btnSubmit = [[HighNightBgButton alloc] initWithFrame:CGRectZero];
    btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:btnSubmit];
    btnSubmit.layer.cornerRadius = 3;
    btnSubmit.backgroundColor = _COLOR(0xff, 0x66, 0x19);
    [btnSubmit setTitle:@"确定" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:_COLOR(0xff, 0xff, 0xff) forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = _FONT(18);
    [btnSubmit addTarget:self action:@selector(doBtnSubmit:) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView *tableview = self.tableview;
    NSDictionary *views = NSDictionaryOfVariableBindings(tableview, btnSubmit);
    
    self.hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.hConstraints];
    self.hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btnSubmit]-20-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.hConstraints];
    self.vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableview(190)]-60-[btnSubmit(45)]->=0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.vConstraints];
    
    _tfName = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth - 120, 30)];
    _tfName.font = _FONT(15);
    _tfName.textColor = _COLOR(0x21, 0x21, 0x21);
    _tfName.placeholder = @"账户所有人姓名";
    
    _tfCardNum = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth - 120, 30)];
    _tfCardNum.font = _FONT(15);
    _tfCardNum.textColor = _COLOR(0x21, 0x21, 0x21);
    _tfCardNum.placeholder = @"银行卡号／支付宝账户／微信账户";
//    _tfCardNum.keyboardType = UIKeyboardTypeNumberPad;
    
    _lbBankName = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth - 120, 30)];
    _lbBankName.font = _FONT(15);
    _lbBankName.textColor = _COLOR(0x21, 0x21, 0x21);
    _lbBankName.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadData
{
    [ProgressHUD show:nil];
    [NetWorkHandler requestTogetBanks:^(int code, id content) {
        [ProgressHUD dismiss];
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            self.data = [BankInfoModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]];
        }
    }];
}

- (BOOL) resignFirstResponder
{
    [_tfCardNum resignFirstResponder];
    [_tfName resignFirstResponder];
    return [super resignFirstResponder];
}

- (void) handleLeftBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
    
    BOOL result = [self isModify];
    if(result){
        if([self getIOSVersion] < 8.0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确认放弃保存填写资料吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert show];
        }
        else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"确认放弃保存填写资料吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else{
        [super handleLeftBarButtonClicked:sender];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = _FONT(15);
        cell.textLabel.textColor = _COLOR(0x21, 0x21, 0x21);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    if(indexPath.row == 0){
        cell.textLabel.text = @"所有人姓名";
        cell.accessoryView = _tfName;
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"卡号／账户";
        cell.accessoryView = _tfCardNum;
    }
    else{
        cell.textLabel.text = @"所属机构";
        cell.accessoryView = _lbBankName;
        if(_selectBankIdx >= 0){
            _lbBankName.text = ((BankInfoModel*)[self.data objectAtIndex:_selectBankIdx]).backShortName;
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row == 2){
        [self doSelectBank:nil];
    }
}

- (void) doBtnSubmit:(UIButton *)sender
{
    [self resignFirstResponder];
    
    BankInfoModel *model = [self.data objectAtIndex:_selectBankIdx];
    
    if(_selectBankIdx < 0)
    {
        [Util showAlertMessage:@"请选择所属机构"];
        return;
    }
    
    if([_tfName.text length] == 0)
    {
        [Util showAlertMessage:@"请填写银行卡卡主姓名"];
        return;
    }

    NSString *bankName = model.backName;
    if([bankName rangeOfString:@"支付宝"].length > 0 || [bankName rangeOfString:@"微信"].length > 0){
        if(_tfCardNum.text == 0){
            [Util showAlertMessage:@"请填写正确账户信息"];
            return;
        }
    }
    else{
        if(![self checkCardNo:_tfCardNum.text])
        {
            [Util showAlertMessage:@"请填写正确的银行卡卡号"];
            return;
        }
    }
    
    [NetWorkHandler requestToSaveOrUpdateUserBackCard:nil backId:model.backId userId:[UserInfoModel shareUserInfoModel].userId defaultStatus:@"1" backCardNo:_tfCardNum.text moneyStatus:@"1" cardholder:_tfName.text openBackName:model.backName Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Add_BankCard object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void) doSelectBank:(UIButton *)sender
{
    [self resignFirstResponder];
    
    if(self.data == nil){
        [self loadData];
        return;
    }
    
    if (!self.menu) {
        NSArray *titles = self.data;
        _menu = [[BankSelectVC alloc]initWithTitles:titles];
        _menu.menuDelegate = self;
        
    }
    
    _menu.titleArray = self.data;
    _menu.title = @"账户所属机构";
    _menu.selectIdx = _selectBankIdx;
    
    [_menu show:self.view];
}

-(void)menuViewController:(MenuViewController *)menu AtIndex:(NSUInteger)index
{
    [menu hide];
    _selectBankIdx = index;
    
    [self.tableview reloadData];
//    [self isModify];
}
-(void)menuViewControllerDidCancel:(MenuViewController *)menu
{
    [menu hide];
}

- (BOOL) isModify
{
    BOOL result = NO;
    if(_selectBankIdx >= 0)
        result = YES;
    
    if([_tfName.text length] > 0)
        result = YES;
    
    if([_tfCardNum.text length] > 0)
        result = YES;
    
    return result;
}

- (BOOL) checkCardNo:(NSString*) cardNo{
    if([cardNo length] < 13 || [cardNo length] > 19)
        return NO;
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

@end
