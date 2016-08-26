//
//  CustomerCarInfoModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/25.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface CustomerCarInfoModel : BaseModel

@property (nonatomic, assign) NSInteger pageType;//:1;//1车险算加页面；2车辆信息补全页面
@property (nonatomic, strong) NSString *userId;//:116;//
@property (nonatomic, strong) NSString *carNo;//:xxxxx;//
@property (nonatomic, strong) NSString *carOwnerName;//:xxxx;//车主姓名
@property (nonatomic, strong) NSString *carOwnerCard;//:xxxx;//车主身份证号
@property (nonatomic, strong) NSString *carShelfNo;//:xxxx;//车家好
@property (nonatomic, strong) NSString *carBrandName;//:xxxx;//品牌型号
@property (nonatomic, strong) NSString *carTypeNo;//:xxxx;//车型
@property (nonatomic, strong) NSString *carEngineNo;//:xxxx;//发动机号
@property (nonatomic, strong) NSDate *carRegTime;//:xxxx;//注册日期
@property (nonatomic, strong) NSString *customerId;//:1;//客户ID
@property (nonatomic, strong) NSString *customerCarId;//:1;//车辆ID
@property (nonatomic, assign) NSInteger resultStatus;//:0;//处理状态；0需要维护车辆具体信息；1返回以上所有参数字段
@property (nonatomic, strong) NSDate *carTradeTime;//车辆过户日期
@property (nonatomic, assign) NSInteger carTradeStatus;//车辆过户状态；1未过户，2过户
@property (nonatomic, strong) NSString *travelCard1;//行驶证正本

@property (nonatomic, assign) BOOL newCarNoStatus;

@end
