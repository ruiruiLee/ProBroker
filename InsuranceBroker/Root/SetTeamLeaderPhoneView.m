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
@synthesize tfNickname;

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
        self.bgview = [view viewWithTag:103];
        self.bgview.layer.cornerRadius  = 3;
        self.tfPhone = [view viewWithTag:100];
        self.tfPhone.delegate = self;
        
        self.tfNickname = [view viewWithTag:107];
        tfNickname.delegate = self;
        
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
        
        self.tfPhone.leftView = [self getLeftViewWithTitle:@"手机号"];
        self.tfPhone.leftViewMode = UITextFieldViewModeAlways;
        
        tfNickname.leftView = [self getLeftViewWithTitle:@"昵称"];
        tfNickname.leftViewMode = UITextFieldViewModeAlways;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (UIView *) getLeftViewWithTitle:(NSString *) title
{
    UIView *phone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 36)];
    
    UILabel *lbPhone = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, 50, 36)];
    lbPhone.textColor = _COLOR(0x21, 0x21, 0x21);
    lbPhone.font = _FONT(15);
    lbPhone.text = title;
    [phone addSubview:lbPhone];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(59, 0, 0.5, 36)];
    line1.backgroundColor = _COLOR(0xe6, 0xe6, 0xe6);
    [phone addSubview:line1];
    
    return phone;
}

- (id) loadFromNib
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SetTeamLeaderPhoneView" owner:self options:nil];
    
    UIView *tmpView = [nib objectAtIndex:0];
    
    return tmpView;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.bgview.center.y + 40 > self.bounds.size.height - 296) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bgview.center = CGPointMake(self.bgview.center.x, self.bounds.size.height - 296 - 40);
        }];
    }
}


- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if([Util isMobilePhoeNumber:self.tfPhone.text] && [self.tfNickname.text length] > 0)
    {
        self.btnSubmit.enabled =  YES;
        self.btnSubmit.backgroundColor = _COLOR(0xff, 0x66, 0x19);
        self.lbShow.hidden = YES;
    }else{
        self.btnSubmit.enabled =  NO;
        self.btnSubmit.backgroundColor = _COLOR(0xcc, 0xcc, 0xcc);
        if (![Util isMobilePhoeNumber:self.tfPhone.text]){
            self.lbShow.hidden = NO;
        }else{
            self.lbShow.hidden = YES;
        }

    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bgview.center = self.rootview.center;
    }];
}

- (void) doBtnSubmit:(id) sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(NotifyToSetTeamLeaderPhone:remarkName:)]) {
        [self.delegate NotifyToSetTeamLeaderPhone:self.tfPhone.text remarkName:self.tfNickname.text];
    }
    
    [self removeFromSuperview];
}

- (IBAction)doBtnCancel:(id)sender
{
    [self removeFromSuperview];
}

@end
