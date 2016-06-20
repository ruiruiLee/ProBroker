//
//  EditAbleTextVire.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/6/20.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "EditAbleTextView.h"

@implementation EditAbleTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)) {
        return YES;
    }else{
        return [super canPerformAction:action withSender:sender];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    if ([super becomeFirstResponder]) {
        return YES;
    }
    return NO;
}

- (void)paste:(id)sender
{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    self.text = board.string;
    [self resignFirstResponder];
}

@end
