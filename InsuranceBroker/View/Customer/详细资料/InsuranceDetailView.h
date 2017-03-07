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
#import "InsureInfoListTableViewCell.h"

@interface InsuranceDetailView : BaseInsuranceInfo<InsureInfoListTableViewCellDelegate>
{
    UIButton *addImgButton;
    
    HBImageViewList *_imageList;
    
    UIView *_footView;
    UIButton *_btnShut;
    UIView *_contentView;
    NSArray *vConstraint;
    UILabel *lb1;
    
    
    NSInteger _selectIdx;
    
    
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) CarInfoModel *carInfo;
@property (nonatomic, weak) UIViewController *pVc;
@property (nonatomic, strong) CustomerInfoModel *customerInfo;

@property (nonatomic, strong)  UITableView *tableviewNoCar;

@property (nonatomic, strong) NSLayoutConstraint *editHConstraint;
@property (nonatomic, strong) NSLayoutConstraint *tableVConstraint;

@end
