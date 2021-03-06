//
//  CustomerInfoModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/5.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"
#import "CustomerDetailModel.h"

@interface CustomerInfoModel : BaseModel

@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, strong) NSString *visitType;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) NSInteger isAgentCreate;
//@property (nonatomic, strong) NSArray *customerLabel;
//@property (nonatomic, strong) NSArray *customerLabelId;
@property (nonatomic, assign) NSInteger bindType;
@property (nonatomic, assign) BOOL bindStatus;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) NSString *customerPhone;

@property (nonatomic, assign) BOOL isLoadDetail;
@property (nonatomic, strong) CustomerDetailModel *detailModel;

@end
