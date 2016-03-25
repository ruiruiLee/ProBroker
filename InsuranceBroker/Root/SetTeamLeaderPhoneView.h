//
//  SetTeamLeaderPhoneView.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetTeamLeaderPhoneViewDelegate <NSObject>

- (void) NotifyToSetTeamLeaderPhone:(NSString*) phoneNum remarkName:(NSString *) remarkName;

@end

@interface SetTeamLeaderPhoneView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UIView *rootview;
@property (nonatomic, strong) UIView *bgview;
@property (nonatomic, strong) UITextField *tfPhone;
@property (nonatomic, strong) UITextField *tfNickname;
@property (nonatomic, strong) UILabel *lbShow;
@property (nonatomic, strong) UIButton  *btnSubmit;
@property (nonatomic, strong) UIButton *btnCancel;

@property (nonatomic, weak) id<SetTeamLeaderPhoneViewDelegate> delegate;

@end
