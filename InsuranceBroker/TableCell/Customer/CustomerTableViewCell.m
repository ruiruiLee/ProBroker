//
//  CustomerTableViewCell.m
//  InsuranceBroker
//
//  Created by LiuZach on 15/12/21.
//  Copyright © 2015年 LiuZach. All rights reserved.
//

#import "CustomerTableViewCell.h"
#import "define.h"

@implementation CustomerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.lbName.textColor = _COLOR(0x21, 0x21, 0x21);
    self.lbStatus.textColor = _COLOR(0x46, 0xa6, 0xeb);
    self.lbTimr.textColor = _COLOR(0xcc, 0xcc, 0xcc);
    self.btnApply.backgroundColor = _COLOR(0x29, 0xcc, 0x5f);
    self.btnApply.layer.cornerRadius = 3;
    self.btnApply.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dismissImageAction:(UIImageView*)sender
{
    NSLog(@"dismissImageAction");
    [_imageList removeFromSuperview];
    _imageList = nil;
}

- (IBAction) doBtnShowLImage:(UIButton *) sender
{
    if(self.headImg){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSMutableArray *small = [[NSMutableArray alloc] init];
        [Util addImagePath:self.headImg pathArray:array smallImage:self.photoImage.image imageArray:small];
        
        _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
        [_imageList addImagesURL:array withSmallImage:small];
        [self.window addSubview:_imageList];
    }

}

@end
