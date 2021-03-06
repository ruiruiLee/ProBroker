//
//  HeadlineView.h
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/15.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadlineView;

@interface HeadlineCell : UIView

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) IBOutlet UILabel *lbDetail;
@property (nonatomic, assign) HeadlineView *pView;

+ (id)loadFromNib;

@end



@protocol HeadlineViewDelegate <NSObject>

- (void) headline:(HeadlineCell *)headline cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger) numberOfRows:(HeadlineView *)headline;
- (void) headline:(HeadlineView *)headline SelectAtIndexPath:(NSIndexPath *)indexpath;

@end

@interface HeadlineView : UIControl
{
//    UIView *view;
    
    NSInteger _selectIdx;
}

@property (nonatomic, weak) id<HeadlineViewDelegate> delegate;

- (void) reloadData;
- (NSInteger) getCurrentSelectIdx;

@end
