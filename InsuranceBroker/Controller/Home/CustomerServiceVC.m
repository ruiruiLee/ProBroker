//
//  CustomerServiceVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/5/6.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "CustomerServiceVC.h"
#import "define.h"

@interface CustomerServiceVC ()

@property (nonatomic, strong) UIScrollView *scrollview;

@end

@implementation CustomerServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的客服";
    
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_scrollview];
    _scrollview.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_scrollview addSubview:headerView];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:header];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    header.layer.cornerRadius = 35;
    header.clipsToBounds = YES;
    
    UILabel *lbName = [ViewFactory CreateLabelViewWithFont:_FONT(18) TextColor:_COLOR(0x21, 0x21, 0x21)];
    [headerView addSubview:lbName];
    lbName.text = @"客服小文";
    
    UILabel *lbPhone = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0x75, 0x75, 0x75)];
    [headerView addSubview:lbPhone];
    lbPhone.text = @"400-080-3939";
    
    UILabel *lbTime = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0x75, 0x75, 0x75)];
    [headerView addSubview:lbTime];
    lbTime.text = @"在线时间：9:00-22:00";
    
    UIButton *btn = [ViewFactory CreateButtonWithzFont:_FONT(14) TextColor:[UIColor whiteColor] image:ThemeImage(@"")];
    [headerView addSubview:btn];
    [btn addTarget:self action:@selector(doBtnPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_scrollview, headerView, header, btn, lbName, lbPhone, lbTime);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollview]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_scrollview]-0-|" options:0 metrics:nil views:views]];
    
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerView]-0-|" options:0 metrics:nil views:views]];
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerView(100)]->=0-|" options:0 metrics:nil views:views]];
    [_scrollview addConstraint:[NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:ScreenWidth]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[header(70)]->=0-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[header(70)]-15-|" options:0 metrics:nil views:views]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-110-[lbName]->=90-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-110-[lbPhone]->=90-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-110-[lbTime]->=10-|" options:0 metrics:nil views:views]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[lbName(30)]-0-[lbPhone(20)]-0-[lbTime(20)]-15-|" options:0 metrics:nil views:views]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=20-[btn(70)]-10-|" options:0 metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-34-[btn(32)]-34-|" options:0 metrics:nil views:views]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doBtnPhone:(id) sender
{
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",ServicePhone]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}

@end
