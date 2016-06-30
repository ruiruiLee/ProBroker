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
#import <AVOSCloud/AVOSCloud.h>
#import "AppDelegate.h"
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
        
        self.isLogin = NO;
        
        self.isRegister = NO;
        self.mobileFlag = YES;
        self.webFlag = NO;
        self.sex = 1;
        self.leader = 0;
        self.cardVerifiy = 1;
        self.userType = 4;
        self.possessTeamStatus = NO;
    }
    
    return self;
}

- (id) init
{
    self = [super init];
    if(self){
        
        [self addObserver:self forKeyPath:@"userId" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
        self.isLogin = NO;
        
        self.isRegister = NO;
        self.mobileFlag = YES;
        self.webFlag = NO;
        self.sex = 1;
        self.leader = 0;
        self.cardVerifiy = 1;
        self.userType = 4;
        self.possessTeamStatus = NO;
    }
    
    return self;
}
- (void) loadUserinfoFromStore
{
    AppContext *context = [AppContext sharedAppContext];
    [context loadData];
    self.isLogin = context.isLogin;
    [self setContentWithDictionary:context.userInfoDic];
}

- (void) setContentWithDictionary:(NSDictionary *) dic
{
    self.isRegister = [[dic objectForKey:@"isRegister"] integerValue];
    self.realName = [dic objectForKey:@"realName"];
    self.headerImg = [dic objectForKey:@"headerImg"];
    self.clientKey = [dic objectForKey:@"clientKey"];
    self.mobileFlag = [[dic objectForKey:@"mobileFlag"]boolValue];
    self.webFlag = [[dic objectForKey:@"webFlag"] boolValue];
    self.phone = [dic objectForKey:@"phone"];
    self.nickname = [dic objectForKey:@"userName"];
    self.sex = [[dic objectForKey:@"sex"] integerValue];
    self.liveProvinceId = [dic objectForKey:@"liveProvinceId"];
    self.liveCityId = [dic objectForKey:@"liveCityId"];
    self.liveProvince = [dic objectForKey:@"liveProvince"];
    self.liveCity = [dic objectForKey:@"liveCity"];
    self.leader = [[dic objectForKey:@"leader"] integerValue];
    self.cardVerifiy = [[dic objectForKey:@"cardVerifiy"] integerValue];
    self.userType = [[dic objectForKey:@"userType"] integerValue];
    self.userId = [dic objectForKey:@"userId"];
    self.possessTeamStatus = [[dic objectForKey:@"possessTeamStatus"] boolValue];
    self.uuid = [dic objectForKey:@"uuid"];
    
//    self.cardNumber = [dic objectForKey:@"cardNumber"];
//    self.cardNumberImg1 = [dic objectForKey:@"cardNumberImg1"];
//    self.cardNumberImg2 = [dic objectForKey:@"cardNumberImg2"];
//    self.verifiyTime = [UserInfoModel dateFromString:[dic objectForKey:@"verifiyTime"]];
//    self.status = [[dic objectForKey:@"status"] integerValue];
//    self.cardProvinceId = [dic objectForKey:@"cardProvinceId"];
//    self.cardCityId = [dic objectForKey:@"cardCityId"];
//    self.cardAreaId = [dic objectForKey:@"cardAreaId"];
//    self.isSupport = [[dic objectForKey:@"isSupport"] integerValue];
//    self.maxCustomer = [[dic objectForKey:@"maxCustomer"] integerValue];
//    self.layerNum = [[dic objectForKey:@"layerNum"] integerValue];
//    self.lowerNum = [[dic objectForKey:@"lowerNum"] integerValue];
//    self.brokerEarnings = [[dic objectForKey:@"brokerEarnings"] integerValue];
//    self.redbagEarnings = [[dic objectForKey:@"redbagEarnings"] integerValue];
//    self.orderNums = [[dic objectForKey:@"orderNums"] integerValue];
//    self.liveAreaId = [dic objectForKey:@"liveAreaId"];
//    self.liveAddr = [dic objectForKey:@"liveAddr"];
//    self.createdAt = [UserInfoModel dateFromString:[dic objectForKey:@"createdAt"]];
    
    NSMutableDictionary *dictionary = [self dictionaryWithObject:self];
    AppContext *context = [AppContext sharedAppContext];
    context.userInfoDic = dictionary;
    context.isLogin = self.isLogin;
    [context saveData];
}

//存到本地的东西
- (NSMutableDictionary *) dictionaryWithObject:(UserInfoModel *)model
{
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    [Util setValueForKeyWithDic:mDic value:self.userId key:@"userId"];
    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithInt:self.isRegister] key:@"isRegister"];
    [Util setValueForKeyWithDic:mDic value:self.realName key:@"realName"];
    [Util setValueForKeyWithDic:mDic value:self.headerImg key:@"headerImg"];
    [Util setValueForKeyWithDic:mDic value:self.clientKey key:@"clientKey"];
    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithBool:self.mobileFlag] key:@"mobileFlag"];
    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithBool:self.webFlag] key:@"webFlag"];
    [Util setValueForKeyWithDic:mDic value:self.phone key:@"phone"];
    [Util setValueForKeyWithDic:mDic value:self.nickname key:@"userName"];
    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithInteger:self.sex] key:@"sex"];
    [Util setValueForKeyWithDic:mDic value:self.liveProvinceId key:@"liveProvinceId"];
    [Util setValueForKeyWithDic:mDic value:self.liveCityId key:@"liveCityId"];
    [Util setValueForKeyWithDic:mDic value:self.liveProvince key:@"liveProvince"];
    [Util setValueForKeyWithDic:mDic value:self.liveCity key:@"liveCity"];
    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithInt:self.leader] key:@"leader"];
    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithInteger:self.cardVerifiy] key:@"cardVerifiy"];
    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithInteger:self.userType] key:@"userType"];
    [Util setValueForKeyWithDic:mDic value:[NSNumber numberWithBool:self.possessTeamStatus] key:@"possessTeamStatus"];
    [Util setValueForKeyWithDic:mDic value:self.uuid key:@"uuid"];
    
    return mDic;
}

- (void) setDetailContentWithDictionary:(NSDictionary *) dic
{
//    self.userId = [dic objectForKey:@"userId"];
    [self setDetailContentWithDictionary1:dic];
    
    NSMutableDictionary *dictionary = [self dictionaryWithObject:self];
    AppContext *context = [AppContext sharedAppContext];
    context.userInfoDic = dictionary;
    context.isLogin = self.isLogin;
//    if([context.redBagId longLongValue] < [self.redBagId longLongValue])
//        context.isRedPack = YES;
//    context.redBagId = self.redBagId;
    [context saveData];
}

- (void) setDetailContentWithDictionary1:(NSDictionary *) dic
{
    //    self.userId = [dic objectForKey:@"userId"];
    self.uuid = [dic objectForKey:@"uuid"];
    self.realName = [dic objectForKey:@"realName"];
    self.headerImg = [dic objectForKey:@"headerImg"];
    self.phone = [dic objectForKey:@"phone"];
    self.nickname = [dic objectForKey:@"userName"];
    self.liveProvinceId = [dic objectForKey:@"liveProvinceId"];
    self.liveProvince = [dic objectForKey:@"liveProvince"];
    self.liveCity = [dic objectForKey:@"liveCity"];
    self.liveCityId = [dic objectForKey:@"liveCityId"];
    self.leader = [[dic objectForKey:@"leader"] integerValue];
    self.cardVerifiy = [[dic objectForKey:@"cardVerifiy"] integerValue];
    self.userType = [[dic objectForKey:@"userType"] integerValue];
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
    self.layerNum = [[dic objectForKey:@"layerNum"] integerValue];
    self.lowerNum = [[dic objectForKey:@"lowerNum"] integerValue];
    self.brokerEarnings = [[dic objectForKey:@"brokerEarnings"] floatValue];
    self.redbagEarnings = [[dic objectForKey:@"redbagEarnings"] floatValue];
    self.orderNums = [[dic objectForKey:@"orderNums"] integerValue];
    self.liveAreaId = [dic objectForKey:@"liveAreaId"];
    self.liveAddr = [dic objectForKey:@"liveAddr"];
    self.createdAt = [UserInfoModel dateFromString:[dic objectForKey:@"createdAt"]];
    
    self.qrcodeAddr = [dic objectForKey:@"qrcodeAddr"];
    self.monthOrderSuccessNums = [[dic objectForKey:@"monthOrderSuccessNums"] integerValue];
    
    self.cardVerifiyMsg = [dic objectForKey:@"cardVerifiyMsg"];
    self.nowMonthOrderSuccessNums = [[dic objectForKey:@"nowMonthOrderSuccessNums"] integerValue];
    self.nowMonthOrderSuccessEarn = [[dic objectForKey:@"nowMonthOrderSuccessEarn"] floatValue];
    self.orderTotalSuccessNums = [[dic objectForKey:@"orderTotalSuccessNums"] integerValue];
    self.orderTotalSuccessEarn = [[dic objectForKey:@"orderTotalSuccessEarn"] floatValue];
    self.orderTotalSellEarn = [[dic objectForKey:@"orderTotalSellEarn"] floatValue];
    self.nowMonthOrderSellEarn = [[dic objectForKey:@"nowMonthOrderSellEarn"] floatValue];
    self.teamInviteNums = [[dic objectForKey:@"teamInviteNums"] integerValue];
    self.teamTotalNums = [[dic objectForKey:@"teamTotalNums"] integerValue];
    self.nowUserTotalMoney = [[dic objectForKey:@"nowUserTotalMoney"] floatValue];
    self.userTotalMoney = [[dic objectForKey:@"userTotalMoney"] floatValue];
    self.possessTeamStatus = [[dic objectForKey:@"possessTeamStatus"] boolValue];
}

- (void) queryUserInfo
{
    if(self.userId == nil || [self.userId length] == 0)
        return;
    [NetWorkHandler requestToQueryUserInfo:self.userId Completion:^(int code, id content) {
        if(code == 200){
            [self setDetailContentWithDictionary:[content objectForKey:@"data"]];
        }else if (code == 504){
            UserInfoModel *model = [UserInfoModel shareUserInfoModel];
            model.isLogin = NO;
            [[AppContext sharedAppContext] removeData];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Logout object:nil];
            
            [AVUser logOut];  //清除缓存用户对象
            
            AVInstallation *currentInstallation = [AVInstallation currentInstallation];
            [currentInstallation removeObject:@"ykbbrokerLoginUser4" forKey:@"channels"];
            [currentInstallation removeObject:[UserInfoModel shareUserInfoModel].userId forKey:@"channels"];
            [currentInstallation saveInBackground];
            [self login];
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
            
            UserInfoModel *model = [UserInfoModel shareUserInfoModel];
            model.isLogin = NO;
            [[AppContext sharedAppContext] removeData];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Logout object:nil];
            
            [AVUser logOut];  //清除缓存用户对象
            
            AVInstallation *currentInstallation = [AVInstallation currentInstallation];
            [currentInstallation removeObject:@"ykbbrokerLoginUser" forKey:@"channels"];
            [currentInstallation removeObject:[UserInfoModel shareUserInfoModel].userId forKey:@"channels"];
            [currentInstallation saveInBackground];
            [self login];
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
            UserInfoModel *model = [UserInfoModel shareUserInfoModel];
            model.isLogin = NO;
            [[AppContext sharedAppContext] removeData];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Logout object:nil];
            
            [AVUser logOut];  //清除缓存用户对象
            
            AVInstallation *currentInstallation = [AVInstallation currentInstallation];
            [currentInstallation removeObject:@"ykbbrokerLoginUser" forKey:@"channels"];
            [currentInstallation removeObject:[UserInfoModel shareUserInfoModel].userId forKey:@"channels"];
            [currentInstallation saveInBackground];
            [self login];
        }
    }];
}

#pragma 登录
- (BOOL) login
{
    UserInfoModel *user = [UserInfoModel shareUserInfoModel];
    if(!user.isLogin){
        loginViewController *vc = [IBUIFactory CreateLoginViewController];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate).root.navigationController presentViewController:naVC animated:NO completion:nil];
        //        }
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
