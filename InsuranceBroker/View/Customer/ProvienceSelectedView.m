//
//  ProvienceSelectedView.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/26.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ProvienceSelectedView.h"
#import "define.h"
#import "AppInfoView.h"

#define ViewHeight 210

@implementation ProvienceSelectedView
@synthesize bgView;
@synthesize view;
@synthesize delegate;
@synthesize btnCancel;

- (id) init
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT)];
    
    if(self){
        
        //        self.backgroundColor = [UIColor blackColor];
        titleArray = @[@"沪", @"京", @"苏", @"浙", @"粤", @"津", @"渝", @"川", @"鲁", @"冀", @"豫", @"晋", @"鄂", @"湘", @"皖", @"赣", @"闽", @"桂", @"辽", @"吉", @"黑", @"贵", @"陕", @"云", @"蒙", @"甘", @"青", @"宁", @"新", @"琼", @"藏"];
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT)];
        [self addSubview:view];
        view.backgroundColor = [UIColor clearColor];
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, ScreenWidth, ViewHeight)];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor whiteColor];
        
        CGFloat step = (ScreenWidth - 6) / 8 - 6;
        
        CGFloat sep = 6;
        CGFloat ox = sep;
        CGFloat oy = sep;
        
        for (int i = 0; i < 4; i++) {
            oy = sep + (sep + 32) * i + 8;
            for (int j = 0; j < 8; j++) {
                if(i == 3 && j == 7)
                    break;
                ox = sep + (step + sep) * j;
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ox, oy, step, 32)];
                btn.layer.cornerRadius = 2;
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = _COLOR(0x75, 0x75, 0x75).CGColor;
                [bgView addSubview:btn];
                btn.titleLabel.font = _FONT(14);
                [btn setTitleColor:_COLOR(0x21, 0x21, 0x21) forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(handleControlClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = i * 8 + j + 100;
                [btn setTitle:[titleArray objectAtIndex:i * 8 + j] forState:UIControlStateNormal];
            }
        }
        
        btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 170, ScreenWidth, 42)];
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel setTitleColor:_COLOR(0x75, 0x75, 0x75) forState:UIControlStateNormal];
        btnCancel.titleLabel.font = _FONT(16);
        btnCancel.backgroundColor = _COLOR(0xf5, 0xf5, 0xf5);
        [bgView addSubview:btnCancel];
        [btnCancel addTarget:self action:@selector(handleCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (void) handleControlClickedEvent:(UIButton *) control
{
    NSInteger tag = control.tag;
    
    NSString *provience = [titleArray objectAtIndex:tag - 100];
    
    if(delegate && [delegate respondsToSelector:@selector(NotifySelectedProvienceName:view:)]){
        [delegate NotifySelectedProvienceName:provience view:self];
    }
    [self hidden];
}

- (void) show
{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        bgView.frame = CGRectMake(0, SCREEN_HEIGHT - ViewHeight, ScreenWidth, ViewHeight);
    }];
}

- (void) hidden
{
    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 1;
        view.backgroundColor = [UIColor clearColor];
        bgView.frame = CGRectMake(0, SCREEN_HEIGHT, ScreenWidth, ViewHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void) handleCancelClicked:(UIButton *)sender
{
    [self hidden];
}



@end
