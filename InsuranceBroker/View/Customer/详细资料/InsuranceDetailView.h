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
    
    
    NSInteger _selectIdx;
}

@property (nonatomic, strong) CarInfoModel *carInfo;
@property (nonatomic, weak) UIViewController *pVc;
@property (nonatomic, strong) CustomerInfoModel *customerInfo;

@property (nonatomic, strong)  UITableView *tableviewNoCar;

@property (nonatomic, strong) NSArray *data;
//@property (nonatomic, strong)  UILabel *lbTitleNoCar;
//@property (nonatomic, strong)  SepLineLabel *lbSepLineNoCar;
//@property (nonatomic, strong)  LeftImgButton *btnEditNoCar;
//@property (nonatomic, strong)  UIButton *btnClickedNoCar;

@property (nonatomic, strong) NSLayoutConstraint *editHConstraint;
@property (nonatomic, strong) NSLayoutConstraint *tableVConstraint;

@end
