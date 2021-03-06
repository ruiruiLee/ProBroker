//
//  UserPolicyListView.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/24.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "InsuranceInfoView.h"
#import "LeftImgButton.h"
#import "SepLineLabel.h"

@class BaseInsuranceInfo;
@class InsuredUserInfoModel;

@protocol BaseInsuranceInfoDelegate <NSObject>

- (void) NotifyAddFollowUpInfo:(BaseInsuranceInfo *) sender;//添加客户跟进信息
- (void) NotifyHandleFollowUpClicked:(BaseInsuranceInfo *)sender idx:(NSInteger) idx;
- (void) NotifyToLoadMoreFollowUp:(BaseInsuranceInfo *)sender;
- (void) NotifyModifyInsuranceInfo:(BaseInsuranceInfo *) sender;//编辑投保资料
- (void) NotifyToAddInsuranceInfo:(BaseInsuranceInfo *) sender;//添加非车险被保人资料
- (void) NotifyHandleInsuranceInfoClicked:(BaseInsuranceInfo *)sender idx:(NSInteger) idx;//处理非车险资料列表点击
- (void) NotifyHandlePolicyClicked:(BaseInsuranceInfo *)sender idx:(NSInteger) idx;//处理保单列表点击
- (void) NotifyToLoadMorePloicy:(BaseInsuranceInfo *)sender;

- (void) NotifyHandleItemDelegateClicked:(BaseInsuranceInfo *)sender model:(id) model;//处理保单列表点击
- (void) NotifyToRefresh:(BaseInsuranceInfo *)sender;//刷新保单列表

- (void) NotifyToRefreshSubviewFrames;
- (void) NotifyToSubmitImage:(UIImage *) travelCard1 travelCard2:(UIImage *)travelCard2 image1:(UIImage *) image1 cert2:(UIImage *)image2;

- (void) NotifyToPlanCarInsurance;//车险报价
- (void) NotifyToPlanInsurance:(InsuredUserInfoModel *) model;//非车险报价

@end

@interface BaseInsuranceInfo : UIView <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong)  UITableView *tableview;
@property (nonatomic, strong)  UILabel *lbTitle;
@property (nonatomic, strong)  SepLineLabel *lbSepLine;
@property (nonatomic, strong)  LeftImgButton *btnEdit;
@property (nonatomic, strong)  UIButton *btnClicked;
@property (nonatomic, weak) id<BaseInsuranceInfoDelegate> delegate;
@property (nonatomic, strong) NSLayoutConstraint *btnHConstraint;
@property (nonatomic, strong) NSArray *contentVConstraint;

@property (nonatomic, strong) NSArray *data;

- (CGFloat) resetSubviewsFrame;

- (void) doEditButtonClicked:(UIButton *)sender;

- (void) startAnimation;

- (void) endAnimation;

@end
