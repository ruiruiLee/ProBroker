//
//  CustomerPageNoLoginView.h
//  InsuranceBroker
//
//  Created by LiuZach on 2017/3/8.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loginClicked)();

@interface CustomerPageNoLoginView : UIView
{
    UIImageView *_titleView;
    UIImageView *_contentImgView;
    UIButton *_btnLogin;
}

@property (nonatomic, strong) loginClicked login;

- (id) initWithFrame:(CGRect)frame block:(loginClicked) block;

@end
