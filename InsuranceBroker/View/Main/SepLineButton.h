//
//  SepLineButton.h
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/22.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "HighNightBgButton.h"


@interface SepLineButton : HighNightBgButton
{
    BOOL _left;
    BOOL _right;
    BOOL _top;
    BOOL _bottom;
}

- (void) setSepLineType:(BOOL) left right:(BOOL) right top:(BOOL) top bottom:(BOOL) bottom;

@end
