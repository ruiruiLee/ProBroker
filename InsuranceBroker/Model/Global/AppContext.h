//
//  AppContext.h
//  Zwjxt
//
//  Created by Liang on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppContext : NSObject
{
    NSString *docDir;

    NSMutableDictionary *userInfoDic;
}

@property(nonatomic, strong)NSString *docDir;

@property(nonatomic, copy) NSMutableDictionary *userInfoDic;
@property (nonatomic, assign) BOOL firstLaunch;

@property (nonatomic, assign) BOOL isNewMessage;
@property (nonatomic, retain) NSMutableArray* arrayNewsTip;

//推送客户
@property (nonatomic, assign) NSInteger pushCustomerNum;//推送客户

//专属客服
@property (nonatomic, assign) BOOL isZSKFHasMsg;
//保单客服
@property (nonatomic, assign) BOOL isBDKFHasMsg;

+ (AppContext *)sharedAppContext;
- (void)saveData;
- (void)resetData;
- (void)loadData;
- (void)removeData;
- (void)UpdateNewsTipTime:(long long )datenew category:(NSInteger)category;//更新某个类别的本地时间戳，防止比对出现红点显示
- (BOOL)judgeDisplay:(NSInteger)category;  // 判断是否有新的消息 好显示红点
- (void)SaveNewsTip:(NSArray*) arrayNew; // 存储类别显示红点信息
- (void)changeNewsTip:(NSInteger)category display:(BOOL)display; // 点击后显示或者取消红点

@end
