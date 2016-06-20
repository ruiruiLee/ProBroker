//
//  AddFollowUpVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/25.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "AddFollowUpVC.h"
#import "define.h"
#import "MenuViewController.h"
#import "NetWorkHandler.h"
#import "DictModel.h"
#import "ZHPickView.h"
#import "NetWorkHandler+saveOrUpdateCustomerVisits.h"
#import "ProgressHUD.h"

@interface AddFollowUpVC () <MenuDelegate, ZHPickViewDelegate, UITextViewDelegate>
{
    NSArray *_visitProgress;
    NSArray *_visitType;
    
    NSInteger _selectVisitProgressIdx;
    NSInteger _selectvisitTypeIdx;
    NSDate *_visitDate;
    
    ZHPickView *_datePicker;
}

@property (nonatomic, strong) MenuViewController *menuView;
@property (nonatomic, strong) NSArray *visitProgress;
@property (nonatomic, strong) NSArray *visitType;

@end

@implementation AddFollowUpVC

- (BOOL) resignFirstResponder
{
    [self.tfAdd resignFirstResponder];
    [self.tfStatus resignFirstResponder];
    [self.tfTIme resignFirstResponder];
    [self.tfview resignFirstResponder];
    [self.tfWay resignFirstResponder];
    
    if(_datePicker){
        [_datePicker remove];
    }
    
    return [super resignFirstResponder];
}

- (void) handleLeftBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
    
    BOOL flag = [self isHasModify];
    if(flag){
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
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"新增记录";
    [self SetRightBarButtonWithTitle:@"保存" color:_COLORa(0xff, 0x66, 0x19, 0.5) action:NO];
    
    _selectVisitProgressIdx = -1;
    _selectvisitTypeIdx = -1;
    
    self.viewHConstraint.constant = ScreenWidth;
    
    self.tfStatus.placeholder = @"最新进展情况";
    self.tfWay.placeholder = @"来源或跟进方式";
    self.tfTIme.placeholder = @"记录时间";
    self.tfAdd.placeholder = @"填写跟进地点或线索渠道";
    self.tfview.placeholder = @"记录详细进展内容";
    self.tfAdd.PlaceholderLabel.textAlignment = NSTextAlignmentRight;
    self.tfview.delegate = self;
    self.tfAdd.delegate = self;
    
    NSDate *date = [NSDate date];
    self.tfTIme.text = [Util getTimeString:date];
    _visitDate = date;
    self.tfAdd.text = LcationInstance.currentDetailAdrress;
    
    [self textViewDidChange:self.tfAdd];
    
    [self loadVisitDictionary];
    if(self.visitModel){
        [self setVisitModel:self.visitModel];
    }
    
}

- (void) valueChanged:(UITextField*) obj
{
    [self isHasModify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleRightBarButtonClicked:(id)sender
{
    [self resignFirstResponder];
    
    if(_selectVisitProgressIdx == -1){
        [Util showAlertMessage:@"请选择最新进展情况"];
        return;
    }
    if(_selectvisitTypeIdx == -1)
    {
        [Util showAlertMessage:@"请选择线索来源或跟进方式"];
        return;
    }
    
    DictModel *model = [_visitType objectAtIndex:_selectvisitTypeIdx];
    NSString *visitType = model.dictName;
    NSString *visitTypeId = model.dictValue;
    model = [_visitProgress objectAtIndex:_selectVisitProgressIdx];
    NSString *visitProgress = model.dictName;
    NSString *visitProgressId = model.dictValue;
    
    NSString *addr = self.tfAdd.text;
    NSString *visitTime = self.tfTIme.text;
    NSString *visitMemo = self.tfview.text;
    [NetWorkHandler requestToSaveOrUpdateCustomerVisits:self.customerId userId:[UserInfoModel shareUserInfoModel].userId visitTime:visitTime visitAddr:addr visitType:visitType visitTypeId:visitTypeId visitProgress:visitProgress visitProgressId:visitProgressId visitLon:nil visitLat:nil visitStatus:1 visitMemo:visitMemo visitId:nil Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            
            VisitInfoModel *model = [[VisitInfoModel alloc] init];
            model.visitAddr = addr;
            model.visitId = [content objectForKey:@"data"];
            model.visitMemo = visitMemo;
            model.visitProgress = visitProgress;
            model.visitProgressId = visitProgressId;
            model.visitTime = _visitDate;//[VisitInfoModel dateFromString:visitTime];
            model.visitType = visitType;
            model.visitTypeId = visitTypeId;
            model.userName = self.customerModel.customerName;
            
            [self.customerModel.detailModel.visitAttay insertObject:model atIndex:0];
            self.customerModel.detailModel.visitTotal += 1;
            self.customerModel.visitType = visitProgress;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

//- (void) viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//}


- (IBAction)menuChange:(UIButton *)sender {
    [self resignFirstResponder];
    
    if (!_menuView) {
        NSArray *titles = @[];
        _menuView = [[MenuViewController alloc]initWithTitles:titles];
        _menuView.menuDelegate = self;
        
    }
    if(sender.tag == 1001){
        _menuView.selectIdx = _selectVisitProgressIdx;
        _menuView.titleArray = self.visitProgress;
        _menuView.tag = 100;
        _menuView.title = @"最新进展";
    }
    else{
        _menuView.selectIdx = _selectvisitTypeIdx;
        _menuView.titleArray = self.visitType;
        _menuView.tag = 101;
        _menuView.title = @"线索跟进";
    }
    [_menuView show:self.view];
    
}

- (IBAction) addFollowDate:(id) sender
{
    [self resignFirstResponder];
    
    if(!_datePicker){
        _datePicker = [[ZHPickView alloc] initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:YES];
        _datePicker.lbTitle.text = @"选择日期";
        [_datePicker show];
        _datePicker.delegate = self;
    }else{
        [_datePicker show];
    }
}

-(void)menuViewController:(MenuViewController *)menu AtIndex:(NSUInteger)index
{
    [menu hide];
    if(menu.tag == 100){
        _selectVisitProgressIdx = index;
        DictModel *model = [_visitProgress objectAtIndex:index];
        self.tfStatus.text = model.dictName;
    }
    else{
        _selectvisitTypeIdx = index;
        DictModel *model = [_visitType objectAtIndex:index];
        self.tfWay.text = model.dictName;
    }
    [self isHasModify];
}
-(void)menuViewControllerDidCancel:(MenuViewController *)menu
{
    [menu hide];
}

- (void) loadVisitDictionary
{
    [ProgressHUD show:nil];
    NSArray *array = @[@"visitType", @"visitProgress"];
    NSString *method = @"/web/common/getDictCustom.xhtml?dictType=['visitType','visitProgress']";
    method = [NSString stringWithFormat:method, [NetWorkHandler objectToJson:array]];
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    __weak AddFollowUpVC *weakself = self;
    [handle getWithMethod:method BaseUrl:Base_Uri Params:nil Completion:^(int code, id content) {
        [ProgressHUD dismiss];
        [weakself handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            NSArray *array = [DictModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]];
            weakself.visitProgress = [weakself buildVisitProgress:array];
            weakself.visitType = [weakself buildVisitType:array];
        }
    }];
}

- (NSArray *) buildVisitProgress:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i ++) {
        DictModel *model = [array objectAtIndex:i];
        if([model.dictType isEqualToString:@"visitProgress"])
            [result addObject:model];
    }
    
    return result;
}

- (NSArray *) buildVisitType:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i ++) {
        DictModel *model = [array objectAtIndex:i];
        if([model.dictType isEqualToString:@"visitType"])
            [result addObject:model];
    }
    
    return result;
}

#pragma ZHPickViewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultDate:(NSDate *)resultDate
{
    _visitDate = resultDate;
    NSString *dateStr = [Util getTimeString:resultDate];
    self.tfTIme.text = dateStr;
    [self isHasModify];
}

- (void) setVisitModel:(VisitInfoModel *)model
{
    _visitModel = model;
//    self.view.userInteractionEnabled = NO;
    self.tfview.editable = NO;
    self.btnStatus.userInteractionEnabled = NO;
    self.btnTime.userInteractionEnabled = NO;
    self.btnWay.userInteractionEnabled = NO;
    self.tfAdd.userInteractionEnabled = NO;
    self.tfStatus.userInteractionEnabled = NO;
    self.tfTIme.userInteractionEnabled = NO;
    self.tfWay.userInteractionEnabled = NO;
    
    self.tfview.text = model.visitMemo;
    self.tfAdd.text = model.visitAddr;
    self.tfStatus.text = model.visitProgress;
    self.tfTIme.text = [Util getTimeString:model.visitTime];
    self.tfWay.text = model.visitType;
    [self SetRightBarButtonWithTitle:@"保存" color:_COLORa(0xff, 0x66, 0x19, 0.5) action:NO];
    self.title = @"查看记录";
    [self textViewDidChange:self.tfAdd];
}

- (BOOL) isHasModify
{
    BOOL result = NO;
    
    if(_selectvisitTypeIdx != -1 || _selectVisitProgressIdx != -1)
    {
        result = YES;
    }
    
    NSString *visitMemo = self.tfview.text;
    if([visitMemo length] > 0 && ![visitMemo isEqualToString:self.visitModel.visitMemo])
        result = YES;
    
//    if(_visitDate != nil)
//        result = YES;
//    NSString *address = self.tfAdd.text;
//    if([address length] > 0 && ![address isEqualToString:self.visitModel.visitAddr])
//        result = YES;
    
    if(result){
        [self SetRightBarButtonWithTitle:@"保存" color:_COLORa(0xff, 0x66, 0x19, 1) action:YES];
    }else{
        [self SetRightBarButtonWithTitle:@"保存" color:_COLORa(0xff, 0x66, 0x19, 0.5) action:NO];
    }
    
    return result;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView == self.tfview){
        NSInteger TEXT_LEN = 200;
        NSInteger number = [textView.text length];
        if (number > TEXT_LEN && textView.markedTextRange == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字符个数不能大于200" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.tfview.text = [textView.text substringToIndex:TEXT_LEN];
        }
    }
    
    if(self.tfAdd == textView){
        NSInteger TEXT_LEN = 100;
        NSInteger number = [textView.text length];
        if (number > TEXT_LEN && textView.markedTextRange == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字符个数不能大于100" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.tfAdd.text = [textView.text substringToIndex:TEXT_LEN];
        }
        
        UIFont *font = _FONT(15);
        CGSize size = [textView.text boundingRectWithSize:CGSizeMake(ScreenWidth - 158, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;//[textView.text sizeWithFont:textView.font constrainedToSize:CGSizeMake(ScreenWidth - 158, INT_MAX)];
        if(size.height > 36)
            size.height = 36;
        if(size.height < 10)
            size.height = 18;
        self.addVConstraint.constant = size.height + 16;
    }
    [self isHasModify];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView == self.tfview){
        if (textView.text.length >= 200  && [text length] > range.length) {
            return NO;
        }
        
        return YES;
    }
    else{
        if (textView.text.length >= 100 ) {
            return NO;
        }
        
        return YES;
    }
}


@end
