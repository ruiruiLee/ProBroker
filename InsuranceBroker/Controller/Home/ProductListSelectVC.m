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
#import "SBJson.h"

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
    if(![m.uniqueFlag isEqualToString:@"100"])
    {//自有产品
        OurProductDetailVC *web = [IBUIFactory CreateOurProductDetailVC];
        
        web.title = m.productName;
        //    web.type = enumShareTypeShare;
        if(m.productLogo != nil)
            web.shareImgArray = [NSArray arrayWithObject:m.productLogo];
        
        self.infoModel.productId = m.productId;//添加产品id
        web.infoModel = self.infoModel;//选中的被保人信息
        web.customerDetail = self.customerdetail;
        
        web.shareContent = m.productIntro;
        web.shareTitle = m.productName;
        [self.navigationController pushViewController:web animated:YES];
        [web loadHtmlFromUrlWithUserId:m.clickAddr productId:m.productId];
    }
    else{//众安产品
        ProductDetailWebVC *web = [IBUIFactory CreateProductDetailWebVC];
        web.title = m.productName;
        if(m.productLogo != nil)
            web.shareImgArray = [NSArray arrayWithObject:m.productLogo];
        
        web.shareContent = m.productIntro;
        web.shareTitle = m.productName;
        web.selectProModel = m;
        
        NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
        [mdic setObject:@{@"userId": [UserInfoModel shareUserInfoModel].userId} forKey:@"extraInfo"];
        
        
        if(self.infoModel){
            if(self.infoModel.insuredName){
                [mdic setObject:self.infoModel.insuredName forKey:@"policyHolderUserName"];//投保人姓名
            }
            if(self.infoModel.insuredPhone)
                [mdic setObject:self.infoModel.insuredPhone forKey:@"policyHolderPhone"];//投保人手机号
            if(self.infoModel.cardNumber){
                [mdic setObject:@"I" forKey:@"policyHolderCertiType"];//投保人证件类型
                [mdic setObject:self.infoModel.cardNumber forKey:@"policyHolderCertiNo"];//投保人证件号码
            }
        }
        SBJsonWriter *_writer = [[SBJsonWriter alloc] init];
        NSString *dataString = [_writer stringWithObject:mdic];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.view.userInteractionEnabled = NO;
        
        NSString *url = [NSString stringWithFormat:@"http://118.123.249.87:8783/UKB.AgentNew/web/security/encryRC4.xhtml?"];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
        [pramas setObject:dataString forKey:@"dataString"];
        
        [[NetWorkHandler shareNetWorkHandler] getWithUrl:url Params:pramas Completion:^(int code, id content) {
            self.view.userInteractionEnabled = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(code == 1){
                NSString *bizContent =  (NSString *) content;
                
                NSString *url = [NSString stringWithFormat:@"%@&bizContent=%@", m.clickAddr, bizContent];
                
                [self.navigationController pushViewController:web animated:YES];
                [web loadHtmlFromUrl:url];
            }
        }];
    }
    
}

@end
