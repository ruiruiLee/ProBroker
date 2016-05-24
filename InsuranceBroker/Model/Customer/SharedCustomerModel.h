//
//  SharedCustomerModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/20.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface SharedCustomerModel : BaseModel

@property (nonatomic, strong) NSString *cooperationSource;//合作来源，对应活动
@property (nonatomic, strong) NSString *phone;//电话
@property (nonatomic, strong) NSString *brokerId;//经纪人ID
@property (nonatomic, strong) NSString *name;//客户昵称
@property (nonatomic, strong) NSString *appType;//
@property (nonatomic, strong) NSString *uuid;//
@property (nonatomic, strong) NSString *headerUrl;//头像
@property (nonatomic, assign) NSInteger shareSource;//分享来源，对应图标;1:微信好友；2，QQ好友 ；3:微信朋友圈； 4：邮件；
@property (nonatomic, strong) NSString *objectId;//item的ID
@property (nonatomic, strong) NSDate *createdAt;//创建时间
@property (nonatomic, strong) NSString *cooperationImg;
@property (nonatomic, strong) NSString *shareImg;
@property (nonatomic, strong) NSString *provence;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, strong) NSString *insuranceType;//保险类别

@end
