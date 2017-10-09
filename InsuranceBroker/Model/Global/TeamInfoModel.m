//
//  TeamInfoModel.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/9/28.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "TeamInfoModel.h"

@implementation TeamInfoModel

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dictionary
{
    TeamInfoModel *model = [[TeamInfoModel alloc] init];
    
    model.teamGradeId = [dictionary objectForKey:@"teamGradeId"];
    model.teamGradeName = [dictionary objectForKey:@"teamGradeName"];
    model.teamId = [dictionary objectForKey:@"teamId"];
    model.teamLeaderId = [dictionary objectForKey:@"teamLeaderId"];
    model.teamLeaderName = [dictionary objectForKey:@"teamLeaderName"];
    model.teamLeaderPhone = [dictionary objectForKey:@"teamLeaderPhone"];
    model.teamName = [dictionary objectForKey:@"teamName"];
    model.subTeamCount = [[dictionary objectForKey:@"subTeamCount"] integerValue];
    model.memberCount = [[dictionary objectForKey:@"memberCount"] integerValue];
    
    return model;
}

@end
