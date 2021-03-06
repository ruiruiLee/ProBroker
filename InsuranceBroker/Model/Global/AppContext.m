//
//  AppContext.m
//  Zwjxt
//
//  Created by Liang on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppContext.h"
#import <UIKit/UIKit.h>
static AppContext *context = nil;

@implementation AppContext

@synthesize docDir;
@synthesize userInfoDic;

+ (AppContext *) sharedAppContext
{
    if(context == nil)
    {
        context = [[AppContext alloc] init];
    }
    
    return context;
}

- (id)init
{
    if ((self = [super init])) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.docDir = [paths objectAtIndex:0];
        NSString *file = [docDir stringByAppendingPathComponent:@"data.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:file];
            if (dic != nil) {
                self.userInfoDic = [[NSMutableDictionary alloc] initWithDictionary:[dic objectForKey:@"userInfoDic"]];
                userId = [[self.userInfoDic objectForKey:@"userId"]integerValue];
                self.firstLaunch = [[dic objectForKey:@"firstLaunch"] boolValue];
                self.pushCustomerNum = [[dic objectForKey:@"pushCustomerNum"] integerValue];
                self.isNewMessage = [[dic objectForKey:@"isNewMessage"] boolValue];
                self.isZSKFHasMsg = [[dic objectForKey:@"isZSKFHasMsg"] boolValue];
                self.isBDKFHasMsg = [[dic objectForKey:@"isBDKFHasMsg"] boolValue];
                self.arrayNewsTip =[dic objectForKey:@"arrayNewsTip"];
                if(self.arrayNewsTip == nil)
                    self.arrayNewsTip = [[NSMutableArray alloc] init];
            }
            else{
                self.userInfoDic = [[NSMutableDictionary alloc] init];
                self.firstLaunch = NO;
                self.pushCustomerNum = 0;
                self.isNewMessage = NO;
                self.isZSKFHasMsg = NO;
                self.isBDKFHasMsg = NO;
                self.arrayNewsTip= [NSMutableArray new];
            }
        }else{
            self.userInfoDic = [[NSMutableDictionary alloc] init];
            self.firstLaunch = NO;
            self.pushCustomerNum = 0;
            self.isNewMessage = NO;
            self.isZSKFHasMsg = NO;
            self.isBDKFHasMsg = NO;
            self.arrayNewsTip= [NSMutableArray new];
        }
    }
    
    return self;
}

// 判断该类别是否显示红点
- (BOOL)judgeDisplay:(NSInteger)category{
    for (NSDictionary *dic in self.arrayNewsTip) {
      if ([[dic objectForKey:@"category"] integerValue]==category&&
                [[dic objectForKey:@"userId"] integerValue]== userId)
        {
             return [[dic objectForKey:@"isNew"] boolValue];
        }
     }
    return false;
}


- (void)changeNewsTip:(NSInteger)category display:(BOOL)display{
    int i=0;
    for (NSMutableDictionary *dicOld in _arrayNewsTip){
        
      if ([[dicOld objectForKey:@"category"] integerValue]==category&&
                [[dicOld objectForKey:@"userId"] integerValue]== userId)
         {
            NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary:dicOld];
            [dic setValue:[NSNumber numberWithBool:display] forKey:@"isNew"];
            [_arrayNewsTip replaceObjectAtIndex: i withObject:dic];
            break;
         }
     i++;
    }
   
     BOOL displayMsg =NO;
    for (NSDictionary *dic in _arrayNewsTip) {
       if ([[dic objectForKey:@"isNew"] boolValue]) {
            displayMsg = YES;
           break;
       }
   }
    self.isNewMessage = displayMsg;
    [UIApplication sharedApplication].applicationIconBadgeNumber=self.isNewMessage?1:0;
    [self saveData];
}

- (void)UpdateNewsTipTime:(long long )datenew category:(NSInteger)category {
    int i=0;
    for (NSDictionary *dic in _arrayNewsTip) {
        
        if ([[dic objectForKey:@"category"] integerValue]==category&&
            [[dic objectForKey:@"userId"] integerValue]== userId)
            // 有消息更新
             {
                [dic setValue: [NSNumber numberWithBool:false] forKey:@"isNew"];
                [dic setValue:[NSNumber numberWithLongLong:datenew] forKey:@"lastNewsDt"];
                  [_arrayNewsTip replaceObjectAtIndex: i withObject:dic];
                 // 判断外面是否显示红点
                 BOOL displayMsg =NO;
                 for (NSDictionary *dic in _arrayNewsTip) {
                     if ([[dic objectForKey:@"isNew"] boolValue]) {
                         displayMsg = YES;
                         break;
                     }
                 }
                 self.isNewMessage = displayMsg;
                 [UIApplication sharedApplication].applicationIconBadgeNumber=self.isNewMessage?1:0;
                  [self saveData];
                 break;
            }
        i++;
    }
}

// 存储类别显示红点信息
- (void)SaveNewsTip:(NSArray*) arrayNew{
    if (_arrayNewsTip.count==0) {
        _arrayNewsTip= [NSMutableArray arrayWithArray: arrayNew];
        BOOL displayMsg =NO;
        for (NSDictionary *dic in _arrayNewsTip) {
            if ([[dic objectForKey:@"isNew"] boolValue]) {
                displayMsg = YES;
                break;
            }
        }
        self.isNewMessage = displayMsg;
          [UIApplication sharedApplication].applicationIconBadgeNumber=self.isNewMessage?1:0;
        [self saveData];
        return;
    }
    BOOL displayMsg = self.isNewMessage;
    int i=0;
    NSMutableArray * changArray = [NSMutableArray arrayWithArray:arrayNew];
    for (NSDictionary *dicNew in arrayNew) {
        NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary:dicNew];
        for (NSDictionary *dicOld in _arrayNewsTip) {

            if ([[dicNew objectForKey:@"category"] integerValue]==
                 [[dicOld objectForKey:@"category"] integerValue]&&
                [[dicNew objectForKey:@"userId"] integerValue]==
                 [[dicOld objectForKey:@"userId"] integerValue]
                )
             
                // 有消息更新
            {
               long long datenew = [[dicNew objectForKey:@"lastNewsDt"] longLongValue];
               long long dateold = [[dicOld objectForKey:@"lastNewsDt"] longLongValue];
               if (datenew>dateold) {
                
                   [dic setValue: [NSNumber numberWithBool:true]   forKey:@"isNew"];
                   [dic setValue:[NSNumber numberWithLongLong:datenew] forKey:@"lastNewsDt"];
                   displayMsg = YES;
                }
               else{ //没有消息更新
                   [dic setValue: [dicOld objectForKey:@"isNew"]  forKey:@"isNew"];
  
               }
                [changArray replaceObjectAtIndex: i withObject:dic];
                
                
            }
        }
        i++;
    }
    self.isNewMessage = displayMsg;
      [UIApplication sharedApplication].applicationIconBadgeNumber=self.isNewMessage?1:0;
    [_arrayNewsTip removeAllObjects];
    self.arrayNewsTip =  [NSMutableArray arrayWithArray: changArray];
    [self saveData];
}

- (void)saveData
{
    NSString *file = [docDir stringByAppendingPathComponent:@"data.plist"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(userInfoDic)
        [dic setObject:userInfoDic forKey:@"userInfoDic"];
    else
        [dic setObject:@{} forKey:@"userInfoDic"];
    
    [dic setObject:[NSNumber numberWithBool:self.firstLaunch] forKey:@"firstLaunch"];
    [dic setObject:[NSNumber numberWithInteger:self.pushCustomerNum] forKey:@"pushCustomerNum"];
    // 用于判断是否有新消息所用
    [dic setObject:[NSNumber numberWithBool:self.isNewMessage ] forKey:@"isNewMessage"];
    [dic setObject:[NSNumber numberWithBool:self.isZSKFHasMsg ] forKey:@"isZSKFHasMsg"];
    [dic setObject:[NSNumber numberWithBool:self.isBDKFHasMsg ] forKey:@"isBDKFHasMsg"];
    [dic setObject:self.arrayNewsTip forKey:@"arrayNewsTip"];


    [dic writeToFile:file atomically:YES];
    
    [self loadData];
}

- (void)removeData
{
    NSString *file = [docDir stringByAppendingPathComponent:@"data.plist"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@{} forKey:@"userInfoDic"];
    [dic setObject:[NSNumber numberWithBool:self.firstLaunch] forKey:@"firstLaunch"];
 
//    [self.arrayNewsTip removeAllObjects];
//    [dic setObject:self.arrayNewsTip forKey:@"arrayNewsTip"];
    [dic setObject:[NSNumber numberWithInteger:0] forKey:@"pushCustomerNum"];
    [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isZSKFHasMsg"];
    [dic setObject:[NSNumber numberWithBool:NO] forKey:@"isBDKFHasMsg"];
    [dic writeToFile:file atomically:YES];
    
    self.userInfoDic = [[NSMutableDictionary alloc] init];
    self.pushCustomerNum = 0;
    self.isNewMessage = NO;
    self.isZSKFHasMsg = NO;
    self.isBDKFHasMsg = NO;
    self.arrayNewsTip= [NSMutableArray new];
}


- (void) loadData
{
    NSString *file = [docDir stringByAppendingPathComponent:@"data.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:file];
        if (dic != nil) {
            self.userInfoDic = [[NSMutableDictionary alloc] initWithDictionary:[dic objectForKey:@"userInfoDic"]];
            userId = [[self.userInfoDic objectForKey:@"userId"]integerValue];
            self.firstLaunch = [[dic objectForKey:@"firstLaunch"] boolValue];
            self.isNewMessage = [[dic objectForKey:@"isNewMessage"] boolValue];
            self.isZSKFHasMsg = [[dic objectForKey:@"isZSKFHasMsg"] boolValue];
            self.isBDKFHasMsg = [[dic objectForKey:@"isBDKFHasMsg"] boolValue];
            self.arrayNewsTip =[dic objectForKey:@"arrayNewsTip"];
            if(self.arrayNewsTip == nil)
                self.arrayNewsTip = [[NSMutableArray alloc] init];
            self.pushCustomerNum = [[dic objectForKey:@"pushCustomerNum"] integerValue];
          }
      }
}

- (void)resetData
{
    [self saveData];
}

- (void)dealloc
{
    self.docDir = nil;
}

@end
