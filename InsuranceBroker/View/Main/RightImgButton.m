//
//  RightImgButton.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/31.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "RightImgButton.h"

@implementation RightImgButton

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    UIImageView *imgv = self.imageView;
    CGRect imgvframe = imgv.frame;
    
    UILabel *titlelabel = self.titleLabel;
    CGRect titleframe = titlelabel.frame;
    
    CGRect frame = self.frame;
    
    CGFloat w = (frame.size.width - 6 - imgvframe.size.width - titleframe.size.width)/2;
    
//    imgv.frame = CGRectMake(w, imgvframe.origin.y, imgvframe.size.width, imgvframe.size.height);
//    titlelabel.frame = CGRectMake(w + 6 + imgvframe.size.width, titleframe.origin.y, titleframe.size.width, titleframe.size.height);
    titlelabel.frame = CGRectMake(w, titleframe.origin.y, titleframe.size.width, titleframe.size.height);
    imgv.frame = CGRectMake(w + 6 + titleframe.size.width, imgvframe.origin.y, imgvframe.size.width, imgvframe.size.height);
}

@end
