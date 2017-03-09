//
//  CustomerPageNoLoginView.m
//  InsuranceBroker
//
//  Created by LiuZach on 2017/3/8.
//  Copyright © 2017年 LiuZach. All rights reserved.
//

#import "CustomerPageNoLoginView.h"
#import "define.h"

@implementation CustomerPageNoLoginView

- (id) initWithFrame:(CGRect)frame block:(loginClicked) block
{
    self = [super initWithFrame:(frame)];
    
    if(self){
        self.login = block;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initSubViews];
    }
    
    return self;
}

- (void) initSubViews
{
    UIImage *content = ThemeImage(@"nologincontent");
    UIImage *title = ThemeImage(@"nologinheader");
    
    CGSize size = content.size;
//    if(size.width >= ScreenWidth - 40){
    CGSize newsize = CGSizeMake(ScreenWidth - 40, size.height * (ScreenWidth - 40) / size. width);
    content = [Util fitSmallImage:content scaledToSize:newsize];
    CGSize titlesize = title.size;
    title = [Util fitSmallImage:title scaledToSize:CGSizeMake(titlesize.width * (ScreenWidth - 40) / size. width, titlesize.height * (ScreenWidth - 40)/ size. width)];
//    }
    
    CGFloat h = self.frame.size.height - title.size.height - content.size.height - 60;
    
    _titleView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - title.size.width)/2, h / 4 + 10, title.size.width, title.size.height)];
    _titleView.image = ThemeImage(@"nologinheader");
    [self addSubview:_titleView];
    
    _contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - content.size.width)/2, h/2 + 20 + title.size.height, content.size.width, content.size.height)];
    _contentImgView.image = ThemeImage(@"nologincontent");
    [self addSubview:_contentImgView];
    
    _btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(20, 3*h/4+title.size.height + content.size.height + 12, ScreenWidth - 40, 40)];
    _btnLogin.backgroundColor = _COLOR(0xff, 0x66, 0x19);
    [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnLogin setTitle:@"立即登陆" forState:UIControlStateNormal];
    _btnLogin.layer.cornerRadius = 3;
    _btnLogin.titleLabel.font = _FONT(15);
    [_btnLogin addTarget:self action:@selector(handleLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnLogin];
}

- (void) handleLoginClicked:(id) sender
{
    if(self.login){
        self.login();
    }
}

@end
