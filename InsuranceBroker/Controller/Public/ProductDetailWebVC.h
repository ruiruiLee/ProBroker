//
//  ProductDetailWebVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

//众安的产品

#import "WebViewController.h"
#import "InsuredInfoModel.h"
#import "CustomerDetailModel.h"
#import "productAttrModel.h"

@interface ProductDetailWebVC : WebViewController


@property (nonatomic, strong) productAttrModel *selectProModel;//选中的产品

@end
