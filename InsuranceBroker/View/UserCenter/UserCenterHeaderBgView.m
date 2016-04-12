//
//  UserCenterHeaderBgView.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/12.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "UserCenterHeaderBgView.h"

@implementation UserCenterHeaderBgView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self awakeFromNib];
    }
    
    return self;
}

- (void) awakeFromNib
{
    imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [self addSubview:imageview];
    [self insertSubview:imageview atIndex:0];
    imageview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) setimage:(UIImage *) image
{
    imageview.image = image;
}

@end
