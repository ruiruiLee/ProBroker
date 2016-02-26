//
//  SetTeamLeaderPhoneView.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/2/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "SetTeamLeaderPhoneView.h"
#import "define.h"

@implementation SetTeamLeaderPhoneView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
        bg.backgroundColor = [UIColor blackColor];
        [self addSubview:bg];
        bg.alpha = 0.4;
        
        UIView *view = [self loadFromNib];
        [self addSubview:view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
//        view.center = self.center;
        self.bgview = [view viewWithTag:103];
        self.bgview.layer.cornerRadius  = 3;
        self.tfPhone = [view viewWithTag:100];
        self.tfPhone.delegate = self;
        self.lbShow = [view viewWithTag:101];
        self.lbShow.hidden = YES;
        self.btnSubmit = [view viewWithTag:102];
        self.btnSubmit.layer.cornerRadius = 3;
        self.btnSubmit.backgroundColor = _COLOR(0xcc, 0xcc, 0xcc);
        self.btnSubmit.enabled =  NO;
        [self.btnSubmit addTarget:self action:@selector(doBtnSubmit:) forControlEvents:UIControlEventTouchUpInside];
        self.rootview = view;
        self.btnCancel = [view viewWithTag:106];
        [self.btnCancel addTarget:self action:@selector(doBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:views]];
    }
    return self;
}


- (id) loadFromNib
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SetTeamLeaderPhoneView" owner:self options:nil];
    
    UIView *tmpView = [nib objectAtIndex:0];
    
    return tmpView;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{

    if (self.bgview.center.y > self.bounds.size.height - 286) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bgview.center = CGPointMake(self.bgview.center.x, self.bounds.size.height - 286);
        }];
    }
}


- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgview.center = self.rootview.center;
    }];
    
    if (![Util isMobilePhoeNumber:textField.text]) {
        self.lbShow.hidden = NO;
        self.btnSubmit.enabled =  NO;
        self.btnSubmit.backgroundColor = _COLOR(0xcc, 0xcc, 0xcc);
    }else{
        self.lbShow.hidden = YES;
        self.btnSubmit.enabled =  YES;
        self.btnSubmit.backgroundColor = _COLOR(0xff, 0x66, 0x19);
    }
}

- (void) doBtnSubmit:(id) sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(NotifyToSetTeamLeaderPhone:)]) {
        [self.delegate NotifyToSetTeamLeaderPhone:self.tfPhone.text];
    }
    
    [self removeFromSuperview];
}

- (IBAction)doBtnCancel:(id)sender
{
    [self removeFromSuperview];
}

@end
