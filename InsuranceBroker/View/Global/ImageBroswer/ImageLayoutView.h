//
//  ImageLayoutView.h
//  Demo
//
//  Created by LiuZach on 15/3/31.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBImageViewList;

@interface ImageLayoutView : UIView
{
    NSMutableArray * _imageSmallViews;
     NSMutableArray * _imageSmall;
    NSMutableArray * _bigUrls;
    
    NSArray * _files;
    NSArray * _hBImageArrays;
    
    HBImageViewList *_imageList;
}



- (void) AddImages:(NSArray*) images;

+(float)heightForFiles:(NSArray*)files1;

@end
