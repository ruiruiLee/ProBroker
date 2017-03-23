//
//  OfferDetailsVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/1/2.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "OfferDetailsVC.h"
#import "define.h"
#import "OfferDetailTableViewCell.h"
#import "NetWorkHandler+queryForInsuranceOffersList.h"
#import "NetWorkHandler+saveOrUpdateInsuranceRatio.h"
#import "InsurOffersInfoModel.h"
#import "UIImageView+WebCache.h"
#import "LCPickView.h"
#import "OnlineCustomer.h"
#import "BaseNavigationController.h"
#import "OfferDetailWebVC.h"

@interface OfferDetailsVC ()<LCPickViewDelegate>
{
    LCPickView *_datePicker;
    
    UIButton * leftBarButtonItemButton;
    UIButton * rightBarButtonItemButton;
}

@property (nonatomic, strong) InsurOffersInfoModel *data;

@end

@implementation OfferDetailsVC

- (void) dealloc
{
    [_datePicker remove];
    AppContext *context = [AppContext sharedAppContext];
    [context removeObserver:self forKeyPath:@"isBDKFHasMsg"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"报价详情";
    
    AppContext *context = [AppContext sharedAppContext];
    [context addObserver:self forKeyPath:@"isBDKFHasMsg" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    self.btnChat = [[HighNightBgButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.btnChat setImage:ThemeImage(@"chat") forState:UIControlStateNormal];
    [self.btnChat addTarget:self action:@selector(handleRightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightBarButtonWithButton:self.btnChat];
    self.btnChat.clipsToBounds = NO;
    self.btnChat.imageView.clipsToBounds = NO;
//    [self setRightBarButtonWithImage:ThemeImage(@"chat")];
    [self observeValueForKeyPath:@"isBDKFHasMsg" ofObject:nil change:nil context:nil];
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.scrollEnabled = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"OfferDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self resetBtnNameWidth:[self.btnName titleForState:UIControlStateNormal]];
    [self resetBtnNoWidth:[self.btnNo titleForState:UIControlStateNormal]];
    
    self.viewHConstraint.constant = ScreenWidth;
    [self loadData];
    
    self.lbWarning.attributedText = [self getAttbuteString:[Util getWarningString:@"＊客户优惠 为您实际优惠客户的商业险点数。对于只购买强制交强险的客户不能享有优惠。特别提醒：该优惠费率只针对9座以下的非营运私家车，对于营运车辆或者货车等其他车型 ，请先咨询客服。"] sub:@"特别提醒：该优惠费率只针对9座以下的非营运私家车，对于营运车辆或者货车等其他车型 ，请先咨询客服。"];
}

- (NSMutableAttributedString *)getAttbuteString:(NSMutableAttributedString *)string sub:(NSString *) sub
{
    NSRange range = [string.string rangeOfString:sub];
    
    [string addAttribute:NSFontAttributeName value:_FONT_B(14) range:range];
    [string addAttribute:NSForegroundColorAttributeName value:_COLOR(0x21, 0x21, 0x21) range:range];
    
    return string;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AppContext *con= [AppContext sharedAppContext];
    
    if(con.isBDKFHasMsg){
        [self showBadgeWithFlag:YES];
    }
    else{
        [self showBadgeWithFlag:NO];
    }
}

- (void) showBadgeWithFlag:(BOOL) flag
{
    if(flag)
        self.btnChat.imageView.badgeView.badgeValue = 1;
    else
        self.btnChat.imageView.badgeView.badgeValue = 0;
}

- (void) handleRightBarButtonClicked:(id)sender
{
    self.btnChat.imageView.badgeView.badgeValue = 0;
    NSString * msex =@"男";
    UIImage *placeholderImage = ThemeImage(@"head_male");
    if([UserInfoModel shareUserInfoModel].sex==2){
        msex =@"女";
        placeholderImage = ThemeImage(@"head_famale");
    }
    if([UserInfoModel shareUserInfoModel].headerImg!=nil){
        placeholderImage =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[UserInfoModel shareUserInfoModel].headerImg]]];
    }
    
    [self kefuNavigationBar];
    [OnlineCustomer sharedInstance].navTitle=bjTitle;
    [OnlineCustomer sharedInstance].groupName=bjkf;
    [ProgressHUD show:@"连接客服..."];
    [[OnlineCustomer sharedInstance] userInfoInit:[UserInfoModel shareUserInfoModel].realName sex:msex Province:[UserInfoModel shareUserInfoModel].liveProvince City:[UserInfoModel shareUserInfoModel].liveCity phone:[UserInfoModel shareUserInfoModel].phone headImage:placeholderImage nav:self.navigationController leftBtn:leftBarButtonItemButton rightBtn:rightBarButtonItemButton];
}

-(void) kefuNavigationBar{
    // 左边按钮
    leftBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftBarButtonItemButton setImage:[UIImage imageNamed:@"arrow_left"]
                             forState:UIControlStateNormal];
    [leftBarButtonItemButton addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 右边按钮
    rightBarButtonItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];

    [rightBarButtonItemButton setImage:[UIImage imageNamed:@"garbage"] forState:UIControlStateNormal];
}

- (void) doBtnClicked:(id) sender
{
    AppContext *con= [AppContext sharedAppContext];
    con.isBDKFHasMsg = NO;
    [con saveData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleLeftBarButtonClicked:(id)sender
{
    [super handleLeftBarButtonClicked:sender];
    if(_datePicker){
        [_datePicker remove];
    }
}

- (void) loadData
{
    [NetWorkHandler requestToQueryForInsuranceOffersList:self.orderId insuranceType:@"1" Completion:^(int code, id content) {
        [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
        if(code == 200){
            self.data = (InsurOffersInfoModel*)[InsurOffersInfoModel modelFromDictionary:[content objectForKey:@"data"]];
            [self initSubViews];
        }
    }];
}

//
- (void) initSubViews
{
    self.lbIdenCode.text = self.data.insuranceOrderNo;
    self.lbPlan.text = [NSString stringWithFormat:@"车险方案：%@", self.data.planTypeName];
    self.lbTime.text = [NSString stringWithFormat:@"创建时间：%@", [Util getTimeString:self.data.createdAt]];
    self.lbName.text = self.data.customerName;
    if(self.data.customerName == nil || [self.data.customerName isKindOfClass:[NSNull class]] || [self.data.customerName length] == 0){
        self.lbName.text = Default_Customer_Name;
    }
    self.lbNo.text = self.data.carNo;
    
    [self.tableview reloadData];
}

- (void) resetBtnNameWidth:(NSString *) string
{
    UIImage *image = ThemeImage(@"car_owner");
    CGRect rect = [string boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.btnName.titleLabel.font} context:nil];
    self.btnNameHConstraint.constant = 6 + image.size.width + rect.size.width;
}

- (void) resetBtnNoWidth:(NSString *) string
{
    UIImage *image = ThemeImage(@"car_id");
    CGRect rect = [string boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.btnNo.titleLabel.font} context:nil];
    self.btnNoHConstraint.constant = 6 + image.size.width + rect.size.width;
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = [self.data.offersVoList count];
    self.tableVConstraint.constant = num * 130;
    return num;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    OfferDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"OfferDetailTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    [cell.btnAdd addTarget:self action:@selector(doBtnAddPlanUBKRatio:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnAdd.tag = indexPath.row;
    cell.btnReduce.tag = indexPath.row;
    
    OffersModel *model = [self.data.offersVoList objectAtIndex:indexPath.row];
    
    model.isRatioSubmit = NO;
    CGFloat planUkbRatio = model.planUkbRatio;
    CGFloat max = model.productMaxRatio;
    if(planUkbRatio > max){
        planUkbRatio = max;
    }
    CGFloat min = model.productMinRatio;
    if(planUkbRatio < min)
        planUkbRatio = min;
    
    CGFloat planUkbPrice = model.businessPrice * (100 - planUkbRatio) / 100.0 + model.jqxCcsPrice;
    CGFloat planAbonusPrice = model.businessPrice * (model.productMaxRatio - planUkbRatio) / 100.0 + model.businessPrice * model.allotBonusRatio * model.levelRatio/10000;
    
    model.planUkbPrice = ceil(planUkbPrice); //(int)planUkbPrice;//客户价
    CGFloat last = planUkbPrice - model.planUkbPrice;
    model.planUserAllot = planAbonusPrice - last;//经纪人收益
    if(model.planUserAllot < 0)
        model.planUserAllot = 0;
    model.planUkbRatio = planUkbRatio;
    
    cell.lbGain.attributedText = [self getPlanUkbSavePriceAttbuteString:[NSString stringWithFormat:@"赚：%.2f", model.planUserAllot] sub:[NSString stringWithFormat:@"%.2f", model.planUserAllot]];
    cell.lbName.text = model.productName;
    cell.lbPrice.attributedText = [self getPlanInsuranceCompanyPriceAttbuteString:[NSString stringWithFormat:@"保单价：%.2f", model.planInsuranceCompanyPrice] sub:[NSString stringWithFormat:@"%.2f", model.planInsuranceCompanyPrice]];
    cell.lbRebate.text = [NSString stringWithFormat:@"%d%@", (int)model.planUkbRatio, @"%"];
    cell.lbtruePrice.attributedText = [self getPlanUkbPriceAttbuteString:[NSString stringWithFormat:@"支付价：%.2f", model.planUkbPrice] sub:[NSString stringWithFormat:@"%.2f", model.planUkbPrice]];
    [cell.photo sd_setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:Normal_Image];
    
    if(model.planTypeName_ && [model.planTypeName_ length] > 0){
        cell.lbIsReNew.text = [NSString stringWithFormat:@"(%@)", model.planTypeName_];
    }else{
        cell.lbIsReNew.text = @"";
    }
    
    if(model.businessPrice == 0){
        cell.btnAdd.hidden = YES;
        cell.btnReduce.hidden = YES;
        cell.lbRebate.hidden = YES;
        cell.lbNoRebate.hidden = NO;
        cell.lbRebateTitle.hidden = YES;
    }else{
        cell.btnAdd.hidden = NO;
        cell.btnReduce.hidden = NO;
        cell.lbRebate.hidden = NO;
        cell.lbNoRebate.hidden = YES;
        cell.lbRebateTitle.hidden = NO;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    OffersModel *model = [self.data.offersVoList objectAtIndex:indexPath.row];
    [self updateInsuranceRatio:self.data.insuranceOrderUuid planOfferId:model.planOfferId model:model];
    [_datePicker remove];
}

- (void) doBtnAddPlanUBKRatio:(UIButton *)sender
{
    OffersModel *model = [self.data.offersVoList objectAtIndex:sender.tag];
//    if (!_datePicker) {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = (int)model.productMinRatio; i <= (int)model.productMaxRatio; i++) {
        [array addObject:[NSString stringWithFormat:@"%d%@", i, @"%"]];
    }
    
    _datePicker = [[LCPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
    _datePicker.delegate = self;
    _datePicker.lbTitle.text = [NSString stringWithFormat:@"%@,优惠范围(%d%@－%d%@)", model.productName, (int)model.productMinRatio, @"%", (int)model.productMaxRatio, @"%"];
//    }
    [_datePicker show];
    _datePicker.tag = sender.tag;
    NSInteger idx = model.planUkbRatio - model.productMinRatio;
    if(idx < 0)
        idx = 0;
    [_datePicker setCurrentSelectIdx:idx];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat y = self.tableview.frame.origin.y + 50;//包含picker toolbar的50像素
        y += (sender.tag + 1) * 130;
        if(y - _datePicker.frame.origin.y > 0)
            self.scrollview.contentOffset = CGPointMake(0, y - _datePicker.frame.origin.y );
    }];

}

- (void) updateInsuranceRatio:(NSString *) orderId planOfferId:(NSString *)planOfferId model:(OffersModel *) model
{
    [_datePicker remove];
    
    if(model.isRatioSubmit){
        OfferDetailWebVC *web = [[OfferDetailWebVC alloc] initWithNibName:@"OfferDetailWebVC" bundle:nil];
        web.type = enumShareTypeToCustomer;
        web.title = @"保单详情";
        web.insModel = model;
        web.customerName = self.data.customerName;
        web.carNo = self.data.carNo;
        if(model.productLogo)
            web.shareImgArray = [NSArray arrayWithObject:model.productLogo];
        web.shareTitle = [NSString stringWithFormat:@"您好，优快保携手%@为您定制车险",model.productName];
        [self.navigationController pushViewController:web animated:YES];
        NSString *url = [NSString stringWithFormat:@"%@?appId=%@&orderUuId=%@&helpInsure=1", self.insurInfo.clickUrl, [UserInfoModel shareUserInfoModel].uuid, self.insurInfo.insuranceOrderUuid];
        [web initShareUrl:self.data.insuranceOrderUuid insuranceType:@"1" planOfferId:model.planOfferId];
        [web loadHtmlFromUrl:url];
        
    }
    else{
        [NetWorkHandler requestToSaveOrUpdateInsuranceRatio:orderId insuranceType:@"1" planOfferId:planOfferId ratio:[NSString stringWithFormat:@"%d", (int)model.planUkbRatio] userId:[UserInfoModel shareUserInfoModel].userId Completion:^(int code, id content) {
            [self handleResponseWithCode:code msg:[content objectForKey:@"msg"]];
            if(code == 200){
                OfferDetailWebVC *web = [[OfferDetailWebVC alloc] initWithNibName:@"OfferDetailWebVC" bundle:nil];
                web.type = enumShareTypeToCustomer;
                web.insModel = model;
                web.customerName = self.data.customerName;
                web.carNo = self.data.carNo;
                web.title = @"保单详情";
                if(model.productLogo)
                    web.shareImgArray = [NSArray arrayWithObject:model.productLogo];
                UserInfoModel *user = [UserInfoModel shareUserInfoModel];
                web.shareTitle = [NSString stringWithFormat:@"我是%@，我是优快保自由经纪人。这是为您定制的投保方案报价，请查阅。电话%@", user.realName, user.phone];
                [self.navigationController pushViewController:web animated:YES];
                
                NSString *url = [NSString stringWithFormat:@"%@?appId=%@&orderUuId=%@&helpInsure=1", self.insurInfo.clickUrl, [UserInfoModel shareUserInfoModel].uuid, self.insurInfo.insuranceOrderUuid];
                [web initShareUrl:self.data.insuranceOrderUuid insuranceType:@"1" planOfferId:model.planOfferId];
                [web loadHtmlFromUrl:url];
            }
        }];
    }
}

//保单价
- (NSMutableAttributedString *)getPlanInsuranceCompanyPriceAttbuteString:(NSString *)string sub:(NSString *) sub
{
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:sub];
    
    [attstr addAttribute:NSFontAttributeName value:_FONT(13) range:range];
    return attstr;
}

//折后价
- (NSMutableAttributedString *)getPlanUkbPriceAttbuteString:(NSString *)string sub:(NSString *) sub
{
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:sub];
    
    [attstr addAttribute:NSFontAttributeName value:_FONT(13) range:range];
    [attstr addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf4, 0x43, 0x36) range:range];
    
    return attstr;
}

//赚
- (NSMutableAttributedString *)getPlanUkbSavePriceAttbuteString:(NSString *)string sub:(NSString *) sub
{
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:sub];
    [attstr addAttribute:NSFontAttributeName value:_FONT(13) range:range];
    
    return attstr;
}

#pragma ZHPickViewDelegate

-(void)toobarDonBtnHaveClick:(LCPickView *)pickView resultString:(NSString *)resultString
{
    OffersModel *model = [self.data.offersVoList objectAtIndex:pickView.tag];
    model.isRatioSubmit = NO;
    CGFloat planUkbRatio = model.planUkbRatio;
    CGFloat max = model.productMaxRatio;
    planUkbRatio = [resultString floatValue];
    if(planUkbRatio > max){
        planUkbRatio = max;
    }
    CGFloat min = model.productMinRatio;
    if(planUkbRatio < min)
        planUkbRatio = min;
    
    CGFloat planUkbPrice = model.businessPrice * (100 - planUkbRatio) / 100.0 + model.jqxCcsPrice;
    CGFloat planAbonusPrice = model.businessPrice * (model.productMaxRatio - planUkbRatio) / 100.0 + model.businessPrice * model.allotBonusRatio * model.levelRatio/10000;
    
    model.planUkbPrice = ceil(planUkbPrice); //(int)planUkbPrice;//客户价
    CGFloat last = planUkbPrice - model.planUkbPrice;
    model.planUserAllot = planAbonusPrice - last;//经纪人收益
    if(model.planUserAllot < 0)
        model.planUserAllot = 0;
    model.planUkbRatio = planUkbRatio;
    
    [self.tableview reloadData];
}

- (void) toobarDonBtnCancel:(LCPickView *)pickView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollview.contentOffset = CGPointMake(0, 0);
    }];
}


@end
