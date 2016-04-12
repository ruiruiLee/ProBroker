//
//  TranslucentToolbar.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/12.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "TranslucentToolbar.h"
#import "define.h"

@implementation TranslucentToolbar

- (void)drawRect:(CGRect)rect {
    // do nothing
}

- (id)initWithFrame:(CGRect)aRect {
    if ((self = [super initWithFrame:aRect])) {
        self.opaque = NO;
        self.backgroundColor = _COLORa(50, 50, 50, 0.8);
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

@end
