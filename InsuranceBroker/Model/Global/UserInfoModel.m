//
//  UserInfoModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/28.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "UserInfoModel.h"
#import "define.h"
#import "NetWorkHandler+queryUserInfo.h"
#import "NetWorkHandler+announcement.h"
#import "AVOSCloud/AVOSCloud.h"
#import "RootViewController.h"


@interface UserInfoModel ()

@property (nonatomic, strong) Completion storeCompletion;

@end

@implementation UserInfoModel

+ (UserInfoModel *) shareUserInfoModel
{
    static UserInfoModel *userModel = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        userModel = [[UserInfoModel alloc] init];
        [userModel loadUserinfoFromStore];
        
        if(userModel.userId == nil){
            userModel.userId = youKeUserId;
            userModel.uuid = youKeUUId;
        }
    });

    return userModel;
}

- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"userId"];
}

- (UserInfoModel *) initWithUserId:(NSString *) userId
{
    self = [super init];
    if(self){
        self.userId = userId;
        [self addObserver:self forKeyPath:@"userId" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
        self.mobileFlag = YES;
        self.webFlag = NO;
        self.sex = 1;
        self.isWxTeamLeader = 0;
        self.cardVerifiy = 1;
    }
    
    return self;
}

- (id) init
{
    self = [super init];
    if(self){
        [self addObserver:self forKeyPath:@"userId" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

        self.mobileFlag = YES;
        self.webFlag = NO;
        self.sex = 1;
        self.isWxTeamLeader = 0;
        self.cardVerifiy = 1;
    }
    
    return self;
}
- (void) loadUserinfoFromStore
{
    AppContext *context = [AppContext sharedAppContext];
    [context loadData];
    [self setContentWithDictionary:context.userInfoDic];
}

- (void) setContentWithDictionary:(NSDictionary *) dic
{
//    self.realName = [dic objectForKey:@"realName"];
//    self.clientKey = [dic objectForKey:@"clientKey"];
//    self.isTeamLeader = [[dic objectForKey:@"isTeamLeader"] integerValue];
    self.userId = [dic objectForKey:@"userId"];
    self.uuid = [dic objectForKey:@"uuid"];
    
//    self.mobileFlag = [[dic objectForKey:@"mobileFlag"]boolValue];
//    self.webFlag = [[dic objectForKey:@"webFlag"] boolValue];
//    self.phone = [dic objectForKey:@"phone"];
//    self.nickname = [dic objectForKey:@"userName"];
//    self.sex = [[dic objectForKey:@"sex"] integerValue];
//    self.liveProvinceId = [dic objectForKey:@"liveProvinceId"];
//    self.liveCityId = [dic objectForKey:@"liveCityId"];
//    self.liveProvince = [dic objectForKey:@"liveProvince"];
//    self.liveCity = [dic objectForKey:@"liveCity"];
//    self.cardVerifiy = [[dic objectForKey:@"cardVerifiy"] integerValue];
//    self.headerImg = [dic objectForKey:@"headerImg"];

    
    NSMutableDictionary *dictionary = [self dictionaryWithObject:self];
    AppContext *context = [AppContext sharedAppContext];
    context.userInfoDic = dictionary;
    [context saveData];
}

//存到本地的东西
- (NSMutableDictionary *) dictionaryWithObject:(UserInfoModel *)model
{
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    [Util setValueForKeyWithDic:mDic value:self.userId key:@"userId"];
//    [Util setValueForKeyWithDic:mDic value:self.realName key:@"realName"];
//    [Util setValueForKeyWithDic:mDic value:self.clientKey key:@"clientKey"];
//    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithInt:self.isTeamLeader] key:@"isTeamLeader"];
    [Util setValueForKeyWithDic:mDic value:self.uuid key:@"uuid"];
    
//    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithBool:self.mobileFlag] key:@"mobileFlag"];
//    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithBool:self.webFlag] key:@"webFlag"];
//    [Util setValueForKeyWithDic:mDic value:self.phone key:@"phone"];
//    [Util setValueForKeyWithDic:mDic value:self.nickname key:@"userName"];
//    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithInteger:self.sex] key:@"sex"];
//    [Util setValueForKeyWithDic:mDic value:self.liveProvinceId key:@"liveProvinceId"];
//    [Util setValueForKeyWithDic:mDic value:self.liveCityId key:@"liveCityId"];
//    [Util setValueForKeyWithDic:mDic value:self.liveProvince key:@"liveProvince"];
//    [Util setValueForKeyWithDic:mDic value:self.liveCity key:@"liveCity"];
//    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithInteger:self.cardVerifiy] key:@"cardVerifiy"];
//    [Util setValueForKeyWithDic:mDic value:self.headerImg key:@"headerImg"];
    
    return mDic;
}

- (void) setDetailContentWithDictionary:(NSDictionary *) dic
{
    [self setDetailContentWithDictionary1:dic];
    
    NSMutableDictionary *dictionary = [self dictionaryWithObject:self];
    AppContext *context = [AppContext sharedAppContext];
    context.userInfoDic = dictionary;
    [context saveData];
}

- (void) setDetailContentWithDictionary1:(NSDictionary *) dic
{
    self.uuid = [dic objectForKey:@"uuid"];
    self.realName = [dic objectForKey:@"realName"];
    self.headerImg = [dic objectForKey:@"headerImg"];
    self.phone = [dic objectForKey:@"phone"];
    self.nickname = [dic objectForKey:@"userName"];
    self.liveProvinceId = [dic objectForKey:@"liveProvinceId"];
    self.liveProvince = [dic objectForKey:@"liveProvince"];
    self.liveCity = [dic objectForKey:@"liveCity"];
    self.liveCityId = [dic objectForKey:@"liveCityId"];
    self.isWxTeamLeader = [[dic objectForKey:@"isWxTeamLeader"] integerValue];
    self.cardVerifiy = [[dic objectForKey:@"cardVerifiy"] integerValue];
    self.sex = [[dic objectForKey:@"userSex"] integerValue];
    
    self.cardNumber = [dic objectForKey:@"cardNumber"];
    self.cardNumberImg1 = [dic objectForKey:@"cardNumberImg1"];
    self.cardNumberImg2 = [dic objectForKey:@"cardNumberImg2"];
    self.verifiyTime = [UserInfoModel dateFromString:[dic objectForKey:@"verifiyTime"]];
    self.status = [[dic objectForKey:@"status"] integerValue];
    self.cardProvinceId = [dic objectForKey:@"cardProvinceId"];
    self.cardCityId = [dic objectForKey:@"cardCityId"];
    self.cardAreaId = [dic objectForKey:@"cardAreaId"];
    self.isSupport = [[dic objectForKey:@"isSupport"] integerValue];
    self.maxCustomer = [[dic objectForKey:@"maxCustomer"] integerValue];
    self.brokerEarnings = [[dic objectForKey:@"brokerEarnings"] floatValue];
    self.redbagEarnings = [[dic objectForKey:@"redbagEarnings"] floatValue];
    self.orderNums = [[dic objectForKey:@"orderNums"] integerValue];
    self.liveAreaId = [dic objectForKey:@"liveAreaId"];
    self.liveAddr = [dic objectForKey:@"liveAddr"];
    self.createdAt = [UserInfoModel dateFromString:[dic objectForKey:@"createdAt"]];
    
    self.qrcodeAddr = [dic objectForKey:@"qrcodeAddr"];
    
    self.cardVerifiyMsg = [dic objectForKey:@"cardVerifiyMsg"];
    
    self.sellInfo = (SellInfoModel*)[SellInfoModel modelFromDictionary:[dic objectForKey:@"sellInfo"]];
    self.teamInfo = (TeamInfoModel*)[TeamInfoModel modelFromDictionary:[dic objectForKey:@"teamInfo"]];
//    self.car_now_zcgddbf = [[dic objectForKey:@"car_now_zcgddbf"] doubleValue];
//    self.car_now_zcgdds = [[dic objectForKey:@"car_now_zcgdds"] integerValue];
//    self.car_now_zcgddsy = [[dic objectForKey:@"car_now_zcgddsy"] doubleValue];
//    self.car_now_zcgddxse = [[dic objectForKey:@"car_now_zcgddxse"] doubleValue];
//    self.nocar_now_zcgddbf = [[dic objectForKey:@"nocar_now_zcgddbf"] doubleValue];
//    self.nocar_now_zcgdds = [[dic objectForKey:@"nocar_now_zcgdds"] integerValue];
//    self.nocar_now_zcgddsy = [[dic objectForKey:@"nocar_now_zcgddsy"] doubleValue];
//    self.nocar_now_zcgddxse = [[dic objectForKey:@"nocar_now_zcgddxse"] doubleValue];
//    self.now_zcgddbf = [[dic objectForKey:@"now_zcgddbf"] doubleValue];
//    self.now_zcgdds = [[dic objectForKey:@"now_zcgdds"] longLongValue];
//    self.now_zcgddsy = [[dic objectForKey:@"now_zcgddsy"] doubleValue];
//    self.now_zcgddxse = [[dic objectForKey:@"now_zcgddxse"] doubleValue];
//    self.now_zsy = [[dic objectForKey:@"now_zsy"] doubleValue];
//    self.now_ztdrs = [[dic objectForKey:@"now_ztdrs"] longLongValue];
//    self.zcgddbf = [[dic objectForKey:@"zcgddbf"] doubleValue];
//    self.zcgdds = [[dic objectForKey:@"zcgdds"] longLongValue];
//    self.zcgddsy = [[dic objectForKey:@"zcgddsy"] doubleValue];
//    self.zcgddxse = [[dic objectForKey:@"zcgddxse"] doubleValue];
//    self.zsy = [[dic objectForKey:@"zsy"] doubleValue];
//    self.ztdrs = [[dic objectForKey:@"ztdrs"] longLongValue];
//    
//    self.car_zcgdds = [[dic objectForKey:@"car_zcgdds"] longLongValue];
//    self.nocar_zcgdds = [[dic objectForKey:@"nocar_zcgdds"] longLongValue];
//    self.nocar_zcgddbf = [[dic objectForKey:@"nocar_zcgddbf"] doubleValue];
//    self.car_zcgddbf = [[dic objectForKey:@"car_zcgddbf"] doubleValue];
    
    self.redMoney = [dic objectForKey:@"redMoney"];
}

- (void) removeAllContent
{
    [self setDetailContentWithDictionary1:nil];
    [self setContentWithDictionary:nil];
}

- (void) queryUserInfo
{
    if(self.userId == nil || [self.userId length] == 0)
        return;
    [NetWorkHandler requestToQueryUserInfo:self.userId Completion:^(int code, id content) {
        if(code == 200){
            [self setDetailContentWithDictionary:[content objectForKey:@"data"]];
            self.productRadios = [ProductRadioModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"ratios"]];
        }else if (code == 504){
            [self logout];
        }
        
        if(self.storeCompletion){
            self.storeCompletion(code, content);
            self.storeCompletion = nil;
        }
    }];
}

-(void)queryLastNewsTip:(Completion) completion
{
    if(self.userId == nil || [self.userId length] == 0){
        if(completion){
            completion(-1, nil);
        }
        return;
    }

    [NetWorkHandler requestToAnnouncementNum:self.userId completion:^(int code, id content) {
         completion(code, content);
    }];
}

- (void) loadLastNewsTip
{
    [self queryLastNewsTip:^(int code, id content) {
        if(code == 200){
            AppContext *context = [AppContext sharedAppContext];
            [context SaveNewsTip:[NSArray arrayWithArray:[[content objectForKey:@"data"] objectForKey:@"rows"]]];
        }else if (code == 504){
            
            [Util showAlertMessage:[content objectForKey:@"msg"]];
            [self logout];
        }
    }];

}

- (void) queryCustomerCount:(Completion) completion
{
    if(self.userId == nil || [self.userId length] == 0){
        if(completion){
            completion(-1, nil);
        }
        return;
    }
    
    [NetWorkHandler requestToPushCustomerCount:self.userId completion:^(int code, id content) {
        completion(code, content);
    }];
}

- (void) loadCustomerCount
{
    [self queryCustomerCount:^(int code, id content) {
        if(code == 200){
            AppContext *context = [AppContext sharedAppContext];
            context.pushCustomerNum = [[content objectForKey:@"data"] integerValue];
            [context saveData];
        }else if (code == 504){
            [self logout];
        }
    }];
}

- (void) logout
{
    [Util logout];
    [self login];
}

#pragma 登录
- (BOOL) login
{
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    if(!user.uuid){
        loginViewController *vc = [IBUIFactory CreateLoginViewController];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [[App_Delegate root].navigationController presentViewController:naVC animated:NO completion:nil];
        return NO;
    }else{
        return YES;
    }
}

- (void) loadDetail:(Completion) completion
{
    if(self.userId == nil || [self.userId length] == 0){
        if(completion){
            completion(-1, nil);
        }
        return;
    }
    
    self.storeCompletion = completion;
    
    [NetWorkHandler requestToQueryUserInfo:self.userId Completion:^(int code, id content) {
        if(code == 200){
            [self setDetailContentWithDictionary:[content objectForKey:@"data"]];
            self.productRadios = [ProductRadioModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"ratios"]];
        }
        if(self.storeCompletion)
            self.storeCompletion(code, content);
        
        self.storeCompletion = nil;
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"userId"]){
        [self performSelector:@selector(queryUserInfo) withObject:nil afterDelay:0.1];
//        [self performSelector:@selector(loadLastNewsTip) withObject:nil afterDelay:0.1];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [[UserInfoModel shareUserInfoModel] loadLastNewsTip];
            [[UserInfoModel shareUserInfoModel] loadCustomerCount];
        });
    }
}


@end
