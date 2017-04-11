//
//  ProductListVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/4/19.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "ProductListVC.h"
#import "NetWorkHandler+queryForProductAttrPageList.h"
#import "define.h"
#import "DictModel.h"
#import "productAttrModel.h"
#import "SBJson.h"

@interface ProductListVC ()<BaseStrategyViewDelegate>


@property (nonatomic, strong) LightMenuBar *menuBar;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) NSMutableArray *productList;

@end

@implementation ProductListVC
@synthesize menuBar;
@synthesize headerView;
@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车险产品目录";
    [self initSubviews];
}

- (void) initSubviews
{
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    headerView.backgroundColor = _COLOR(0xf5, 0xf5, 0xf5);
    [self.view addSubview:headerView];
    
    contentView = [[BaseStrategyView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:contentView];
    contentView.delegate = self;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.parentvc = self;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(headerView, contentView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerView]-0-|" options:0 metrics:nil views:views]];
    
    self.array = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerView(50)]-0-[contentView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.array];
    
}

- (void) loadData
{
    for (int i = 0; i < 1; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self.productList addObject:array];
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(headerView, contentView);
    [self.view removeConstraints:self.array];
    self.array = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerView(0)]-0-[contentView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:self.array];
    
    [contentView refreshAndReloadData:@"1" list:[self.productList objectAtIndex:0]];
}

- (void) initMenus
{
    if(!menuBar){
        menuBar = [[LightMenuBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) andStyle:LightMenuBarStyleItem];
        menuBar.delegate = self;
        menuBar.bounces = YES;
        menuBar.selectedItemIndex = 0;
        menuBar.backgroundColor = _COLOR(0xf5, 0xf5, 0xf5);
        [self.headerView addSubview:menuBar];
    }else{
        [menuBar.menuBarView fillParams];
        menuBar.selectedItemIndex = 0;
    }
    
    self.productList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.dataList count]; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self.productList addObject:array];
    }
    
//    DictModel *model = [self.dataList objectAtIndex:menuBar.selectedItemIndex];
//    [contentView refreshAndReloadData:model.dictValue list:[self.productList objectAtIndex:menuBar.selectedItemIndex]];
    
}

#pragma mark LightMenuBarDelegate
- (NSUInteger)itemCountInMenuBar:(LightMenuBar *)bar {
    return [self.dataList count];
}

- (NSString *)itemTitleAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)bar {
    return ((DictModel*)[self.dataList objectAtIndex:index]).dictName;
}

- (void)itemSelectedAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)bar {
    //    dispLabel.text = [NSString stringWithFormat:@"%d Selected", index];
    DictModel *model = [self.dataList objectAtIndex:index];
    [contentView refreshAndReloadData:model.dictValue list:[self.productList objectAtIndex:index]];
}

//< Optional
- (CGFloat)itemWidthAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)bar {
    NSString *title = ((DictModel*)[self.dataList objectAtIndex:index]).dictName;
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:bar.menuBarView.titleFont}];
    return size.width + 20;
}

#if USE_CUSTOM_DISPLAY

/****************************************************************************/
//< For Background Area
/****************************************************************************/

/**< Top and Bottom Padding, by Default 5.0f */
- (CGFloat)verticalPaddingInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

/**< Left and Right Padding, by Default 5.0f */
- (CGFloat)horizontalPaddingInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

/**< Corner Radius of the background Area, by Default 5.0f */
- (CGFloat)cornerRadiusOfBackgroundInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

- (UIColor *)colorOfBackgroundInMenuBar:(LightMenuBar *)menuBar {
    return [UIColor blackColor];
}

/****************************************************************************/
//< For Button
/****************************************************************************/

/**< Corner Radius of the Button highlight Area, by Default 5.0f */
- (CGFloat)cornerRadiusOfButtonInMenuBar:(LightMenuBar *)menuBar {
    return 1.0f;
}

- (UIColor *)colorOfButtonHighlightInMenuBar:(LightMenuBar *)menuBar {
    return [UIColor whiteColor];
    
}

- (UIColor *)colorOfTitleNormalInMenuBar:(LightMenuBar *)menuBar {
    return [UIColor whiteColor];
}

- (UIColor *)colorOfTitleHighlightInMenuBar:(LightMenuBar *)menuBar {
    return [UIColor blackColor];
}

- (UIFont *)fontOfTitleInMenuBar:(LightMenuBar *)menuBar {
    return [UIFont systemFontOfSize:15.0f];
}

/****************************************************************************/
//< For Seperator
/****************************************************************************/

///**< Color of Seperator, by Default White */
//- (UIColor *)seperatorColorInMenuBar:(LightMenuBar *)menuBar {
//}

/**< Width of Seperator, by Default 1.0f */
- (CGFloat)seperatorWidthInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

/**< Height Rate of Seperator, by Default 0.7f */
- (CGFloat)seperatorHeightRateInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

#endif

- (void) NotifyItemSelectIndex:(productAttrModel*) m view:(BaseStrategyView *) view
{
    if(![self login]){
        return;
    }
    if(![m.uniqueFlag isEqualToString:@"100"])
    {
        OurProductDetailVC *web = [IBUIFactory CreateOurProductDetailVC];
        
        web.title = m.productName;
        if(m.productLogo != nil)
            web.shareImgArray = [NSArray arrayWithObject:m.productLogo];
        
        web.shareContent = m.productIntro;
        web.shareTitle = m.productName;
//        web.selectProModel = m;
        [self.navigationController pushViewController:web animated:YES];
        [web loadHtmlFromUrlWithUserId:m.clickAddr productId:m.productId];
        
    }
    else{
        ProductDetailWebVC *web = [IBUIFactory CreateProductDetailWebVC];
        web.title = m.productName;
        web.selectProModel = m;
        if(m.productLogo != nil)
            web.shareImgArray = [NSArray arrayWithObject:m.productLogo];
        
//        self.infoModel.productId = m.productAttrId;//添加产品id
//        web.infoModel = self.infoModel;//选中的被保人信息
//        web.customerDetail = self.customerdetail;
        
        web.shareContent = m.productIntro;
        web.shareTitle = m.productName;
        
        NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
        [mdic setObject:@{@"appId": [UserInfoModel shareUserInfoModel].userId, @"productId": m.productId} forKey:@"extraInfo"];
        
        
//        if(self.infoModel){
//            if(self.infoModel.insuredName)
//                [mdic setObject:self.infoModel.insuredName forKey:@"policyHolderUserName"];//投保人姓名
//            if(self.infoModel.insuredPhone)
//                [mdic setObject:self.infoModel.insuredPhone forKey:@"policyHolderPhone"];//投保人手机号
//            if(self.infoModel.cardNumber){
//                [mdic setObject:@"I" forKey:@"policyHolderCertiType"];//投保人证件类型
//                [mdic setObject:self.infoModel.cardNumber forKey:@"policyHolderCertiNo"];//投保人证件号码
//            }
//        }
        SBJsonWriter *_writer = [[SBJsonWriter alloc] init];
        NSString *dataString = [_writer stringWithObject:mdic];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.view.userInteractionEnabled = NO;
        
//        NSString *url = [NSString stringWithFormat:@"http://118.123.249.87:8783/UKB.AgentNew/web/security/encryRC4.xhtml?dataString=%@&rc4key=open20160501", dataString];
//        
//        //    NSString * encodedUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)url, NULL, NULL,  kCFStringEncodingUTF8 ));
//        
//        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *url = [NSString stringWithFormat:@"http://118.123.249.87:8783/UKB.AgentNew/web/security/encryRC4.xhtml?"];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
        [pramas setObject:dataString forKey:@"dataString"];
        
        [[NetWorkHandler shareNetWorkHandler] getWithUrl:url Params:pramas Completion:^(int code, id content) {
            self.view.userInteractionEnabled = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(code == 1){
                NSString *bizContent =  (NSString *) content;
                
                NSString *url = [NSString stringWithFormat:@"%@&bizContent=%@", m.clickAddr, bizContent];
                
                [self.navigationController pushViewController:web animated:YES];
                [web loadHtmlFromUrl:url];
            }
        }];
    }

}

@end
