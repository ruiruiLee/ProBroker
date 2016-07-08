//
//  OrderDetailWebVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/22.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "WebViewController.h"
#import "InsurInfoModel.h"
#import "HighNightBgButton.h"

@interface OrderDetailWebVC : WebViewController
{
    NSString *_urlPath;
    NSString *_orderId;
    NSString *_insuranceType;
    NSString *_planOfferId;
    NSString *selectImgName;
}

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) InsurInfoModel *insModel;
@property (nonatomic, strong) HighNightBgButton *btnChat;

- (void) initShareUrl:(NSString *) orderId insuranceType:(NSString *) insuranceType planOfferId:(NSString *) planOfferId;

@end
