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

@interface ProductListVC ()<BaseStrategyViewDelegate>


@property (nonatomic, strong)  NSArray *dataList;
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
    self.title = @"产品目录";
    [self initSubviews];
    [self loadData];
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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerView(40)]-0-[contentView]-0-|" options:0 metrics:nil views:views]];
    
}

- (void) loadData
{
    [ProgressHUD show:nil];
    NSString *method = @"/web/common/getDicts.xhtml?dictType=insuranceType";
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    __weak ProductListVC *weakself = self;
    [handle getWithMethod:method BaseUrl:Base_Uri Params:nil Completion:^(int code, id content) {
        [ProgressHUD dismiss];
        [weakself handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            self.dataList = [DictModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"rows"]];
            if([self.dataList count] > 0)
                [self initMenus];
        }
    }];
}

- (void) initMenus
{
    if(!menuBar){
        menuBar = [[LightMenuBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40) andStyle:LightMenuBarStyleItem];
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
    WebViewController *web = [IBUIFactory CreateWebViewController];
    web.title = m.productTitle;
    web.type = enumShareTypeShare;
    if(m.productImg != nil)
        web.shareImgArray = [NSArray arrayWithObject:m.productImg];
    [self.navigationController pushViewController:web animated:YES];
    [web loadHtmlFromUrlWithUserId:m.clickAddr];

}

@end
