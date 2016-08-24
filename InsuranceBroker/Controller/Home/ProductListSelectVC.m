//
//  ProductListSelectVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ProductListSelectVC.h"
#import "NetWorkHandler+queryForProductAttrPageList.h"
#import "DictModel.h"
#import "productAttrModel.h"
#import "define.h"

@interface ProductListSelectVC ()

@property (nonatomic, strong) InsuredInfoModel *infoModel;
@property (nonatomic, strong) CustomerDetailModel *customerdetail;

@end

@implementation ProductListSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个险产品目录";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) loadDataWithLimitVal:(InsuredInfoModel *) model
//{
//    self.infoModel = model;
//    
//    [ProgressHUD show:nil];
//    NSString *method = @"/web/common/getDicts.xhtml?dictType=insuranceType&limitVal=1";
//    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
//    __weak ProductListSelectVC *weakself = self;
//    [handle getWithMethod:method BaseUrl:Base_Uri Params:nil Completion:^(int code, id content) {
//        [ProgressHUD dismiss];
//        [weakself handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
//        if(code == 200){
//            self.dataList = [DictModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]];
//            if([self.dataList count] > 0)
//                [self initMenus];
//        }
//    }];
//}

- (void) loadDataWithLimitVal:(InsuredInfoModel *) model customerDetail:(CustomerDetailModel *) customerDetail
{
    self.infoModel = model;
    self.customerdetail = customerDetail;
    
    [ProgressHUD show:nil];
    NSString *method = @"/web/common/getDicts.xhtml?dictType=insuranceType&limitVal=1";
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    __weak ProductListSelectVC *weakself = self;
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


- (void) NotifyItemSelectIndex:(productAttrModel*) m view:(BaseStrategyView *) view
{
    ProductDetailWebVC *web = [IBUIFactory CreateProductDetailWebVC];
    web.title = m.productTitle;
//    web.type = enumShareTypeShare;
    if(m.productImg != nil)
        web.shareImgArray = [NSArray arrayWithObject:m.productImg];
    
    self.infoModel.productId = m.productAttrId;//添加产品id
    web.infoModel = self.infoModel;//选中的被保人信息
    web.customerDetail = self.customerdetail;
    
    web.shareContent = m.productIntro;
    web.shareTitle = m.productTitle;
    [self.navigationController pushViewController:web animated:YES];
    [web loadHtmlFromUrlWithUserId:m.clickAddr productId:m.productAttrId];
    
}

@end
