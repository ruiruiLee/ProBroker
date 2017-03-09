//
//  CustomerMainVC.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/18.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "BasePullTableVC.h"
#import "CustomerPageNoLoginView.h"

@interface CustomerMainVC : BasePullTableVC<UISearchBarDelegate>
{
    CustomerPageNoLoginView *_noLoginView;
}

//@property (nonatomic, strong) IBOutlet UITableView *tableview;

@end
