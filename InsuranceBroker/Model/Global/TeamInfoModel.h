//
//  TeamInfoModel.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/9/28.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "BaseModel.h"

@interface TeamInfoModel : BaseModel

@property (nonatomic, strong) NSString *teamGradeId;
@property (nonatomic, strong) NSString *teamGradeName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *teamLeaderId;
@property (nonatomic, strong) NSString *teamLeaderName;
@property (nonatomic, strong) NSString *teamLeaderPhone;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, assign) NSInteger subTeamCount;
@property (nonatomic, assign) NSInteger memberCount;

@end
