//
//  ProductDetailWebVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "WebViewController.h"
#import "InsuredInfoModel.h"
#import "CustomerDetailModel.h"

@interface ProductDetailWebVC : WebViewController

@property (nonatomic, strong) InsuredInfoModel *infoModel;//被保人信息
@property (nonatomic, strong) CustomerDetailModel *customerDetail;

- (void) loadHtmlFromUrlWithUserId:(NSString *) url productId:(NSString *)productId;

@end
