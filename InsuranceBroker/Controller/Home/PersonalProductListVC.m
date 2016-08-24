//
//  PersonalProductListVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/15.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "PersonalProductListVC.h"
#import "define.h"
#import "DictModel.h"

@interface PersonalProductListVC ()

@end

@implementation PersonalProductListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个险产品目录";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadData
{
    [ProgressHUD show:nil];
    NSString *method = @"/web/common/getDicts.xhtml?dictType=insuranceType&limitVal=1";
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    __weak ProductListVC *weakself = self;
    [handle getWithMethod:method BaseUrl:Base_Uri Params:nil Completion:^(int code, id content) {
        [ProgressHUD dismiss];
        [weakself handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            self.dataList = [DictModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]];
            if([self.dataList count] > 0)
                [self initMenus];
        }
    }];
}

@end
