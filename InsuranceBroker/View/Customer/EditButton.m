//
//  EditButton.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/8.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "EditButton.h"
#import "define.h"

@implementation EditButton
@synthesize delFlag;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        delFlag = [[UIImageView alloc] initWithImage:ThemeImage(@"del_red")];
        [self addSubview:delFlag];
        delFlag.backgroundColor = [UIColor clearColor];
        
        self.editType = enumEditTypeNormal;
        
        self.clipsToBounds = NO;
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    UIImageView *imgv = self.imageView;
    CGRect imgvframe = imgv.frame;
    imgvframe.size.width = 55;
    imgvframe.size.height = 55;
    
    CGRect delFrame = delFlag.frame;
    delFlag.frame = CGRectMake( -delFrame.size.width / 2, -delFrame.size.height / 2, delFrame.size.width, delFrame.size.height);
    
    CGRect frame = self.frame;
    
    UILabel *titlelabel = self.titleLabel;
    CGRect titleframe = titlelabel.frame;
    titleframe.size.height = 18;
    
    CGFloat h = (frame.size.height - imgvframe.size.height - 2 - titleframe.size.height)/2;
    if(titleframe.size.height == 0){
        NSString *string = @"阿迪风格";
        CGSize size = [string sizeWithFont:self.titleLabel.font];
        h = (frame.size.height - imgvframe.size.height - 2 - size.height)/2;
    }
    
    imgv.frame = CGRectMake((frame.size.width - imgvframe.size.width)/2, h, imgvframe.size.width, imgvframe.size.height);
    titlelabel.frame = CGRectMake(0, h + imgvframe.size.height + 2, frame.size.width, titleframe.size.height);
}

- (void) setEditType:(enumEditType)type
{
    _editType = type;
    if(_editType == enumEditTypeDel){
        self.delFlag.hidden = NO;
    }
    else{
        self.delFlag.hidden = YES;
    }
}

@end
