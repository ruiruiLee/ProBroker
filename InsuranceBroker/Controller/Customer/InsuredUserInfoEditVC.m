//
//  InsuredUserInfoEditVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/17.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "InsuredUserInfoEditVC.h"
#import "define.h"
#import "NetWorkHandler+saveOrUpdateCustomerVisits.h"
#import "DictModel.h"

@implementation InsuredUserInfoEditVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.viewHConstraint.constant = ScreenWidth;
    
    _selectRelationTypeIdx = -1;
    
    [self loadVisitDictionary];
}

- (void) loadVisitDictionary
{
    [ProgressHUD show:nil];
    NSArray *array = @[@"customerRelationType"];
    NSString *method = @"/web/common/getDictCustom.xhtml?dictType=['customerRelationType']";
    method = [NSString stringWithFormat:method, [NetWorkHandler objectToJson:array]];
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    __weak InsuredUserInfoEditVC *weakself = self;
    [handle getWithMethod:method BaseUrl:Base_Uri Params:nil Completion:^(int code, id content) {
        [ProgressHUD dismiss];
        [weakself handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            NSArray *array = [DictModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]];
            self.relatrionArray = array;
        }
    }];
}

- (IBAction)doBtnSelectSex:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
    [action showInView:self.view];
    action.tag = 1000;
}

- (IBAction)doBtnSelectRelation:(UIButton *)sender
{
    [self resignFirstResponder];
    
    if (!_menuView) {
        NSArray *titles = @[];
        _menuView = [[MenuViewController alloc]initWithTitles:titles];
        _menuView.menuDelegate = self;
        
    }

    _menuView.selectIdx = _selectRelationTypeIdx;
    _menuView.titleArray = self.relatrionArray;
    _menuView.tag = 101;
    _menuView.title = @"与投保人关系";

    [_menuView show:self.view];

}

-(void)menuViewController:(MenuViewController *)menu AtIndex:(NSUInteger)index
{
    [menu hide];
    _selectRelationTypeIdx = index;
    DictModel *model = [self.relatrionArray objectAtIndex:index];
    self.tfRelation.text = model.dictName;
//
//    [self isHasModify];
}

-(void)menuViewControllerDidCancel:(MenuViewController *)menu
{
    [menu hide];
}

#pragma mark- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet.tag == 1000){
        if(buttonIndex == 0){
            self.tfSex.text = @"男";
            _sex = @"1";
        }
        else if (buttonIndex == 1){
            self.tfSex.text = @"女";
            _sex = @"2";
        }else
            _sex = nil;
    }
}

@end
