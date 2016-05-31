//
//  ProductListSelectVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ProductListVC.h"
#import "CustomerDetailModel.h"

@interface ProductListSelectVC : ProductListVC

//- (void) loadDataWithLimitVal:(InsuredInfoModel *) model;//获取除车险外的其他产品
- (void) loadDataWithLimitVal:(InsuredInfoModel *) model customerDetail:(CustomerDetailModel *) customerDetail;//获取除车险外的其他产品

@end
