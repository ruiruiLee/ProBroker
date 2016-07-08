//
//  OfferDetailWebVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/6.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "WebViewController.h"
#import "OffersModel.h"
#import "HighNightBgButton.h"

@interface OfferDetailWebVC : WebViewController
{
    NSString *_urlPath;
    NSString *_insuranceType;
    NSString *_planOfferId;
    NSString *selectImgName;
}

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) OffersModel *insModel;
@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, strong) NSString *carNo;

@property (nonatomic, strong) HighNightBgButton *btnChat;

- (void) initShareUrl:(NSString *) orderId insuranceType:(NSString *) insuranceType planOfferId:(NSString *) planOfferId;

@end
