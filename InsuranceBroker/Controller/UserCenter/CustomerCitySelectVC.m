//
//  CustomerCitySelectVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "CustomerCitySelectVC.h"
#import "BaseTableViewCell.h"
#import "UserEditTableViewCell.h"
#import "define.h"
#import "ProviendeModel.h"
#import "CustomerCitySelectVC.h"

@interface CustomerCitySelectVC ()

@end

@implementation CustomerCitySelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        NSString *deq = @"cell";
        UserEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
        if(!cell){
            //            cell = [[UserEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"UserEditTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
//        UserInfoModel *model  = [UserInfoModel shareUserInfoModel];
        cell.lbTitle.text = self.selectArea.liveCity;
        cell.imgv.image = nil;
        if(self.selectArea.liveCityId == nil)
            cell.lbDetail.text = @"请选择地区";
        else
            cell.lbDetail.text = @"已选择地区";
        
        return cell;
    }
    else{
        NSString *deq = @"cell1";
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
        if(!cell){
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
            cell.textLabel.font = _FONT(15);
            cell.textLabel.textColor = _COLOR(0x21, 0x21, 0x21);
            //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        CityModel *model = [self.data objectAtIndex:indexPath.row];
        cell.textLabel.text = model.cityShortName;
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == 1){
        CityModel *citymodel = [self.data objectAtIndex:indexPath.row];
        [self modifyAddress:citymodel];
    }else{
        if(self.selectArea.liveCityId != nil){
            NSArray *vcarray = self.navigationController.viewControllers;
            UIViewController *vc = nil;
            for (int i = 0; i < [vcarray count]; i++) {
                UIViewController *temp = [vcarray objectAtIndex:i];
                if([temp isKindOfClass:[CustomerInfoEditVC class]]){
                    vc = temp;
                    break;
                }
            }
            
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void) modifyAddress:(CityModel *)citymodel
{

    SelectAreaModel *model = [[SelectAreaModel alloc] init];
    model.liveProvinceId = self.proviendemodel.provinceId;
    model.liveProvince = self.proviendemodel.provinceName;
    model.liveCityId = citymodel.cityId;
    model.liveCity = citymodel.cityShortName;
    
    if(self._edit){
        self._edit.selectArea = model;
        self._edit.tfAddr.text = [Util getAddrWithProvience:model.liveProvince city:model.liveCity];
    }
    
    [self._edit isHasModify];
    
    NSArray *vcarray = self.navigationController.viewControllers;
    UIViewController *vc = nil;
    for (int i = 0; i < [vcarray count]; i++) {
        UIViewController *temp = [vcarray objectAtIndex:i];
        if([temp isKindOfClass:[CustomerInfoEditVC class]] || [temp isKindOfClass:[NewCustomerVC class]]){
            vc = temp;
            break;
        }
    }
    
    [self.navigationController popToViewController:vc animated:YES];

}

@end
