//
//  ReactiveButton.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/27.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ReactiveButton.h"
#import "define.h"

@implementation ReactiveButton


- (void) setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    //YES 颜色变为正常，能接受点击事件； NO 颜色变灰，不能接收点击事件
    if(enabled){
        self.alpha = 1;
    }
    else{
        self.alpha = 0.5;
    }
}

@end
