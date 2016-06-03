//
//  ServiceSelectView.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/9.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ServiceSelectView.h"
#import "define.h"
#import "SepLineLabel.h"
#import "AppInfoView.h"

@implementation ServiceSelectView
@synthesize lbServiceTime;

- (void) dealloc
{
    AppContext *context = [AppContext sharedAppContext];
    [context removeObserver:self forKeyPath:@"isZSKFHasMsg"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AppContext *con= [AppContext sharedAppContext];
    
    if(con.isZSKFHasMsg){
        [self showServiceBadge:YES];
    }
    else{
        [self showServiceBadge:NO];
    }
}

- (void) showServiceBadge:(BOOL) flag
{
    AppInfoView *info = [self.bgView viewWithTag:1001];
    if(flag){
        info.logo.badgeView.badgeValue = 1;
        [self performSelector:@selector(initBadge) withObject:nil afterDelay:0.1];
    }
    else
        info.logo.badgeView.badgeValue = 0;
}

- (void) initBadge
{
    AppInfoView *info = [self.bgView viewWithTag:1001];
    info.logo.badgeView.frame = CGRectMake(47.5, -2.5, 15, 15);
}

- (id) initWithImageArray:(NSArray *)images nameArray:(NSArray *)names
{
    self = [super initWithImageArray:images nameArray:names];
    if(self){
        
        AppContext *context = [AppContext sharedAppContext];
        [context addObserver:self forKeyPath:@"isZSKFHasMsg" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [self observeValueForKeyPath:@"isZSKFHasMsg" ofObject:nil change:nil context:nil];
        
        lbServiceTime = [ViewFactory CreateLabelViewWithFont:_FONT(13) TextColor:_COLOR(0x75, 0x75, 0x75)];
        [self.bgView addSubview:lbServiceTime];
        lbServiceTime.text = @"客服在线时间：工作日9:30-18:00";
        lbServiceTime.textAlignment = NSTextAlignmentCenter;
        
        SepLineLabel *line = [[SepLineLabel alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:line];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIButton *btn = self.btnCancel;
        NSDictionary *views = NSDictionaryOfVariableBindings(btn, lbServiceTime, line);
        [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[line(1)]-6-[lbServiceTime(14)]-10-[btn]->=0-|" options:0 metrics:nil views:views]];
        [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbServiceTime]-20-|" options:0 metrics:nil views:views]];
        [self.bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[line]-0-|" options:0 metrics:nil views:views]];
    }
    
    return self;
}

@end
