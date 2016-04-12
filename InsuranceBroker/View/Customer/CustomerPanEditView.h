//
//  CustomerPanEditView.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/23.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditButton.h"
#import "enumFile.h"

@class CustomerInfoModel;

@protocol CustomerPanEditViewDelegate <NSObject>

- (void) NotifyEditFrameChanged:(NSInteger) userCount;

- (void) NotifyEditContact:(BOOL) isAdd; //0: 减， 1: 增加

- (void) NotifyToDelObject:(CustomerInfoModel *) model;

- (void) NotifyToViewDetail:(CustomerInfoModel *) model;

@end

@interface CustomerPanEditView : UIView
{
    EditButton *btnAdd;
    EditButton *btnDel;
    
    NSMutableArray *userArray;
    NSMutableArray *viewArray;
}

@property (nonatomic, weak) id<CustomerPanEditViewDelegate> delegate;
@property (nonatomic, assign) enumEditType editType;

- (id) initWithFrame:(CGRect)frame Array:(NSArray *) array;

- (void) setUserArray:(NSArray *)array;

@end
