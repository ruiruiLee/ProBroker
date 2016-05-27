//
//  ProvienceSelectVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/16.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ProvienceSelectVC.h"
#import "BaseTableViewCell.h"
#import "UserEditTableViewCell.h"
#import "define.h"
#import "ProviendeModel.h"
#import "CustomerCitySelectVC.h"

@interface ProvienceSelectVC ()

@end

@implementation ProvienceSelectVC

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
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"UserEditTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        UserInfoModel *model  = [UserInfoModel shareUserInfoModel];
        cell.lbTitle.text = self.selectArea.liveProvince;
        cell.imgv.image = nil;
        if(self.selectArea.liveProvinceId == nil)
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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        ProviendeModel *model = [self.data objectAtIndex:indexPath.row];
        cell.textLabel.text = model.provinceName;
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 1){
        ProviendeModel *model = [self.data objectAtIndex:indexPath.row];
        CustomerCitySelectVC *vc = [[CustomerCitySelectVC alloc] initWithNibName:nil bundle:nil];
        vc.selectArea = self.selectArea;
        vc._edit = self._edit;
        [self.navigationController pushViewController:vc animated:YES];
        vc.selectIdx = indexPath.row;
        vc.proviendemodel = model;
    }else{
        if(self.selectArea.liveProvinceId != nil)
        {
            CustomerCitySelectVC *vc = [[CustomerCitySelectVC alloc] initWithNibName:nil bundle:nil];
            vc.selectArea = self.selectArea;
            vc._edit = self._edit;
            [self.navigationController pushViewController:vc animated:YES];
            vc.selectIdx = indexPath.row;
            ProviendeModel *model = [[ProviendeModel alloc] init];
            model.provinceId = self.selectArea.liveProvinceId;
            model.provinceName = self.selectArea.liveProvince;
            vc.proviendemodel = model;
        }
    }
}

@end
