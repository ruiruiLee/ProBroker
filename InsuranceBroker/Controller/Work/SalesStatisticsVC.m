//
//  SalesStatisticsVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/17.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "SalesStatisticsVC.h"
#import "NetWorkHandler+queryStatistics.h"
#import "define.h"
#import "SalesStatisticsModel.h"
#import "SalesModel.h"
#import "CurveSellModel.h"

@interface SalesStatisticsVC ()

@property (nonatomic, strong) NSArray *curveArray;
@property (nonatomic, strong) NSArray *curveSell6Month;
@property (nonatomic, strong) SalesStatisticsModel *statmodel;

@end

@implementation SalesStatisticsVC
@synthesize imgWithNoData;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.title = @"销售统计";
        
        self.saleType = EnumSalesTypeCar;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewHConstraint.constant = ScreenWidth;
    
    self.chatview.yMin = 0;
    self.chatview.yMax = 5;
//    self.chatview.ySteps = @[@"0",@"1", @"2", @"3", @"4", @"5"];
    self.chatview.backgroundColor = [UIColor clearColor];
    self.chatview.drawsDataPoints = NO;
    
    self.chatview1.yMin = 0;
    self.chatview1.yMax = 5;
//    self.chatview1.ySteps = @[@"0",@"1", @"2", @"3", @"4", @"5"];
    self.chatview1.backgroundColor = [UIColor clearColor];
    
    [self loadData];
}

- (void) loadData
{
    [NetWorkHandler requestToQueryStatistics:self.userId monthPieChart:nil curveEarn6Month:nil curveSell30Day:@"1" curveSell6Month:@"1" Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        [self initData];
        if(code == 200){
            self.statmodel = (SalesStatisticsModel*)[SalesStatisticsModel modelFromDictionary:[[content objectForKey:@"data"] objectForKey:@"statistics"]];
            self.curveSell6Month = [CurveSellModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"curveData6Month"]];
            self.curveArray = [SalesModel modelArrayFromArray:[[content objectForKey:@"data"] objectForKey:@"curveSell30Day"]];
            [self initData];
        }

    }];
}

- (void) initData
{
    if(self.saleType == EnumSalesTypeCar)
        [self initDataCar];
    else
        [self initDataNoCar];
}

- (void) initDataCar
{
    self.lbEarningsCount.text = [NSString stringWithFormat:@"累计销售额：%@元", [Util getDecimalStyle:self.statmodel.car_zcgddxse]];
    self.lbIncome.text = [NSString stringWithFormat:@"%@", [Util getDecimalStyle:self.statmodel.car_now_zcgddbf]];
    if([[UserInfoModel shareUserInfoModel].userId isEqualToString:self.userId])
        self.lbEarnings.attributedText = [self getAttbuteString:[NSString stringWithFormat:@"你的销售额已打败了 %.1f%@ 的经纪人", self.statmodel.car_now_zcgddbf_jbl, @"%"] sub:[NSString stringWithFormat:@"%.1f%@", self.statmodel.car_now_zcgddbf_jbl, @"%"]];
    else
        self.lbEarnings.attributedText = [self getAttbuteString:[NSString stringWithFormat:@"他的销售额已打败了 %.1f%@ 的经纪人", self.statmodel.car_now_zcgddbf_jbl, @"%"] sub:[NSString stringWithFormat:@"%.1f%@", self.statmodel.car_now_zcgddbf_jbl, @"%"]];
    
    [self initDataWithArray:self.curveArray];
    [self initStatisticsDataWithArray:self.curveSell6Month];
}

- (void) initDataNoCar
{
    self.lbEarningsCount.text = [NSString stringWithFormat:@"累计销售额：%@元", [Util getDecimalStyle:self.statmodel.nocar_zcgddxse]];
    self.lbIncome.text = [NSString stringWithFormat:@"%@", [Util getDecimalStyle:self.statmodel.nocar_now_zcgddbf]];
    if([[UserInfoModel shareUserInfoModel].userId isEqualToString:self.userId])
        self.lbEarnings.attributedText = [self getAttbuteString:[NSString stringWithFormat:@"你的销售额已打败了 %.1f%@ 的经纪人", self.statmodel.nocar_now_zcgddbf_jbl, @"%"] sub:[NSString stringWithFormat:@"%.1f%@", self.statmodel.nocar_now_zcgddbf_jbl, @"%"]];
    else
        self.lbEarnings.attributedText = [self getAttbuteString:[NSString stringWithFormat:@"他的销售额已打败了 %.1f%@ 的经纪人", self.statmodel.nocar_now_zcgddbf_jbl, @"%"] sub:[NSString stringWithFormat:@"%.1f%@", self.statmodel.nocar_now_zcgddbf_jbl, @"%"]];
    
    [self initDataWithArray:self.curveArray];
    [self initStatisticsDataWithArray:self.curveSell6Month];
}

- (void)initDataWithArray:(NSArray*)array
{
    double max = 0;
    for (int i = 0; i < [array count]; i++) {
        SalesModel *model = [array objectAtIndex:i];
        double o = 0;//(int)model.dayOrderTotalSellEarn;
        if(self.saleType == EnumSalesTypeCar)
        {
            o = model.car_day_zcgddbf;
        }
        else{
            o = model.nocar_day_zcgddbf;
        }
        if(o > max)
            max = o;
    }
    
    NSInteger ystep = 0;
    if( ((int)max % 5) == 0 )
        ystep = max / 5;
    else
        ystep = max / 5 + 1;
    if(ystep == 0)
        ystep = 1;
    

        NSMutableArray *sarray = [[NSMutableArray alloc] init];
        int i = 0;
        while ([sarray count] < 6) {
            [sarray addObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", i]]];
            i += ystep;
        }
        
        self.chatview.ySteps = sarray;
    
    LineChartData *d1x = [LineChartData new];
    {
        LineChartData *d1 = d1x;
        d1.title = @"34423";
        d1.color = _COLOR(0xff, 0x66, 0x19);
        d1.itemCount = [array count];
        d1.xMax = d1.itemCount + 1;//[Util convertDateFromDateString:model1.dateString].timeIntervalSince1970/1000;
        d1.xMin = 0;//[Util convertDateFromDateString:model2.dateString].timeIntervalSince1970/1000;
        NSMutableArray *arr = [NSMutableArray array];//x
        NSMutableArray *arr2 = [NSMutableArray array];//y
        NSMutableArray *arr3 = [NSMutableArray array];//y
        
        NSMutableArray *arr4 = [NSMutableArray array];//y
        NSMutableArray *arr5 = [NSMutableArray array];//y
        
        int j = 1;
        for(int i = 0; i < [array count]; i++){
            SalesModel *model = [array objectAtIndex:i];
            [arr addObject:@(j)];
            NSString *lp = @"";//[NSString stringWithFormat:@"%d", (int)model.dayOrderTotalSellEarn];
            if(self.saleType == EnumSalesTypeCar)
            {
                lp = [[NSNumber numberWithDouble:model.car_day_zcgddbf] stringValue];
            }
            else{
                lp = [[NSNumber numberWithDouble:model.nocar_day_zcgddbf] stringValue];
            }
            [arr2 addObject:lp];
            if((i+1)%5 == 0)
                [arr3 addObject:[NSString stringWithFormat:@"%@日", model.dayStr]];
            else
                [arr3 addObject:@""];
            
            NSAttributedString *attstring = [[NSAttributedString alloc] initWithString:@""];
            [arr4 addObject:attstring];
            
            [arr5 addObject:[NSString stringWithFormat:@""]];
            
            j ++;
        }
        
        d1.getData = ^(NSUInteger item) {
            float x = [arr[item] floatValue];
            double y = [arr2[item] doubleValue];
            y = y / ystep ;
            NSString *label1 = arr3[item];
            NSString *label2 = arr4[item];
            NSString *label3 = arr5[item];
            return [LineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2 detail:label3];
        };
        
    }
    
    self.chatview.data = @[d1x];
}

- (void)initStatisticsDataWithArray:(NSArray*)array
{
    double max = 0;
    long long max1 = 0;
    for (int i = 0; i < [array count]; i++) {
        CurveSellModel *model = [array objectAtIndex:i];
        double o = 0;//(int)model.monthOrderTotalSellEarn;
        long long o1 = 0;//model.monthOrderTotalSuccessNums;
        if(self.saleType == EnumSalesTypeCar){
            o = model.car_month_zcgddbf;
            o1 = model.car_month_zcgdds;
        }
        else
        {
            o = model.nocar_month_zcgddbf;
            o1 = model.nocar_month_zcgdds;
        }
        if(o > max)
            max = o;
        if(o1 > max1)
            max1 = o1;
    }
    
    NSInteger ystep = 0;
    long long ystep1 = 0;
    if( ((int)max % 5) == 0 )
        ystep = max / 5;
    else
        ystep = max / 5 + 1;
    if(ystep == 0)
        ystep = 1;
    
    if( ((int)max1 % 5) == 0 )
        ystep1 = max1 / 5;
    else
        ystep1 = max1 / 5 + 1;
    if(ystep1 == 0)
        ystep1 = 1;
    
    
    NSMutableArray *sarray = [[NSMutableArray alloc] init];
    int i = 0;
    int j = 0;
    while ([sarray count] < 6) {
//        [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", i]]
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] init];
        NSString *string = [NSString stringWithFormat:@"%d/", i];
        [attstr appendAttributedString:[[NSAttributedString alloc] initWithString:string]];
        [attstr addAttribute:NSForegroundColorAttributeName value:_COLOR(0xff, 0x66, 0x19) range:NSMakeRange(0, [string length] - 1)];
        
        NSString *str = [NSString stringWithFormat:@"%d", j];
        NSMutableAttributedString *attstr1 = [[NSMutableAttributedString alloc] initWithString:str];
        [attstr1 addAttribute:NSForegroundColorAttributeName value:_COLOR(0x68, 0xb3, 0x17) range:NSMakeRange(0, [str length])];
        [attstr appendAttributedString:attstr1];
        [sarray addObject:attstr];
        i += ystep;
        j += ystep1;
    }
    
    self.chatview1.ySteps = sarray;
    
    LineChartData *d1x = [LineChartData new];
    {
        LineChartData *d1 = d1x;
        d1.title = @"34423";
        d1.color = _COLOR(0xff, 0x66, 0x19);
        d1.itemCount = [array count];
        d1.xMax = d1.itemCount + 1;//[Util convertDateFromDateString:model1.dateString].timeIntervalSince1970/1000;
        d1.xMin = 0;//[Util convertDateFromDateString:model2.dateString].timeIntervalSince1970/1000;
        NSMutableArray *arr = [NSMutableArray array];//x
        NSMutableArray *arr2 = [NSMutableArray array];//y
        NSMutableArray *arr3 = [NSMutableArray array];//y
        
        NSMutableArray *arr4 = [NSMutableArray array];//y
        NSMutableArray *arr5 = [NSMutableArray array];//y
        
        int j = 1;
        for(int i = 0; i < [array count]; i++){
            CurveSellModel *model = [array objectAtIndex:i];
            [arr addObject:@(j)];
            NSString *lp = @"";//[NSString stringWithFormat:@"%d", (int)model.monthOrderTotalSellEarn];
            if(self.saleType == EnumSalesTypeCar)
            {
                lp = [[NSNumber numberWithDouble:model.car_month_zcgddbf] stringValue];
            }
            else{
                lp = [[NSNumber numberWithDouble:model.nocar_month_zcgddbf] stringValue];
            }
            [arr2 addObject:lp];
            [arr3 addObject:[NSString stringWithFormat:@"%@月", model.monthStr]];

            
            NSAttributedString *attstring = [[NSAttributedString alloc] initWithString:@""];
            [arr4 addObject:attstring];
            
            [arr5 addObject:[NSString stringWithFormat:@""]];
            
            j ++;
        }
        
        d1.getData = ^(NSUInteger item) {
            float x = [arr[item] floatValue];
            double y = [arr2[item] doubleValue];
            y = y / ystep ;
            NSString *label1 = arr3[item];
            NSString *label2 = arr4[item];
            NSString *label3 = arr5[item];
            return [LineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2 detail:label3];
        };
        
    }
    
    LineChartData *d2x = [LineChartData new];
    {
        LineChartData *d1 = d2x;
        d1.title = @"34423";//68B317
        d1.color = _COLOR(0x68, 0xb3, 0x17);
        d1.itemCount = [array count];
        d1.xMax = d1.itemCount + 1;//[Util convertDateFromDateString:model1.dateString].timeIntervalSince1970/1000;
        d1.xMin = 0;//[Util convertDateFromDateString:model2.dateString].timeIntervalSince1970/1000;
        NSMutableArray *arr = [NSMutableArray array];//x
        NSMutableArray *arr2 = [NSMutableArray array];//y
        NSMutableArray *arr3 = [NSMutableArray array];//y
        
        NSMutableArray *arr4 = [NSMutableArray array];//y
        NSMutableArray *arr5 = [NSMutableArray array];//y
        
        int j = 1;
        for(int i = 0; i < [array count]; i++){
            CurveSellModel *model = [array objectAtIndex:i];
            [arr addObject:@(j)];
            NSString *lp = @"";//[NSString stringWithFormat:@"%d", (int)model.monthOrderTotalSuccessNums];
            if(self.saleType == EnumSalesTypeCar)
            {
                lp = [[NSNumber numberWithLongLong:model.car_month_zcgdds] stringValue];
            }
            else{
                lp = [[NSNumber numberWithLongLong:model.nocar_month_zcgdds] stringValue];
            }
            [arr2 addObject:lp];
            [arr3 addObject:[NSString stringWithFormat:@"%@月", model.monthStr]];
            
            
            NSAttributedString *attstring = [[NSAttributedString alloc] initWithString:@""];
            [arr4 addObject:attstring];
            
            [arr5 addObject:[NSString stringWithFormat:@""]];
            
            j ++;
        }
        
        d1.getData = ^(NSUInteger item) {
            float x = [arr[item] floatValue];
            float y = [arr2[item] floatValue];
            y = y / ystep1 ;
            NSString *label1 = arr3[item];
            NSString *label2 = arr4[item];
            NSString *label3 = arr5[item];
            return [LineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2 detail:label3];
        };
        
    }
    
    self.chatview1.data = @[d1x, d2x];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self showNoDatasImage:ThemeImage(@"no_data")];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.topView setGradientColor:_COLOR(0xff, 0x8c, 0x19) end:_COLOR(0xff, 0x66, 0x19)];
}

- (void) showNoDatasImage:(UIImage *) image
{
    if(!self.explainBgView){
        self.explainBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
        imgWithNoData = [[UIImageView alloc] initWithImage:image];
        [self.explainBgView addSubview:imgWithNoData];
        [self.view addSubview:self.explainBgView];
        self.explainBgView.center = CGPointMake(ScreenWidth/2, self.view.frame.size.height/2);
    }
}

- (NSMutableAttributedString *)getAttbuteString:(NSString *)string sub:(NSString *) sub
{
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:sub];
    
    [attstr addAttribute:NSFontAttributeName value:_FONT(18) range:range];
    [attstr addAttribute:NSForegroundColorAttributeName value:_COLOR(0xff, 0xee, 0x00) range:range];
    //    [attstr addAttribute:NSFontAttributeName value:_FONT(13) range:NSMakeRange([string length] - 3, 3)];
    
    return attstr;
}

@end
