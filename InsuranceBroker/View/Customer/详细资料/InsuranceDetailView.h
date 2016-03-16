//
//  InsuranceDetailView.h
//  
//
//  Created by LiuZach on 15/12/25.
//
//

#import "BaseInsuranceInfo.h"
#import "CarInfoModel.h"
#import "CustomerInfoModel.h"
#import "HBImageViewList.h"

@interface InsuranceDetailView : BaseInsuranceInfo
{
    UIButton *addImgButton;
    
    UIImage *driveLisence1;
    UIImage *driveLisence2;
    UIImage *cert1;
    UIImage *cert2;
    
    HBImageViewList *_imageList;
    
    UIView *_footView;
    UIButton *_btnShut;
    UIView *_contentView;
    NSArray *vConstraint;
    UILabel *lb1;
    UILabel *lb2;
}

@property (nonatomic, strong) CarInfoModel *carInfo;
@property (nonatomic, weak) UIViewController *pVc;
@property (nonatomic, strong) CustomerInfoModel *customerInfo;

@end
