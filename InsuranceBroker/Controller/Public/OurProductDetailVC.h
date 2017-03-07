//
//  OurProductDetailVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/1/19.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "WebViewController.h"
#import "InsuredInfoModel.h"
#import "CustomerDetailModel.h"
#import "productAttrModel.h"

@interface OurProductDetailVC : WebViewController

@property (nonatomic, strong) InsuredInfoModel *infoModel;//被保人信息
@property (nonatomic, strong) CustomerDetailModel *customerDetail;

- (void) loadHtmlFromUrlWithUserId:(NSString *) url productId:(NSString *)productId;

@end
