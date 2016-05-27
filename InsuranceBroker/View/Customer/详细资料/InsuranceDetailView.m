//
//  InsuranceDetailView.m
//  
//
//  Created by LiuZach on 15/12/25.
//
//

#import "InsuranceDetailView.h"
#import "InsuranceTableViewCell.h"
#import "define.h"
#import "UIButton+WebCache.h"
#import "NetWorkHandler+saveOrUpdateCustomerCar.h"
#import "NetWorkHandler+saveOrUpdateCustomer.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SepLineLabel.h"
#import "InsuredUserInfoModel.h"


#define CELL_HEIGHT  56

@implementation InsuranceDetailView
@synthesize tableviewNoCar;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        _selectIdx = 0;
        //非车险部分
        
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectZero];
        sepView.translatesAutoresizingMaskIntoConstraints = NO;
        sepView.backgroundColor = SepLine_color;
        [self addSubview:sepView];
        
        UILabel *lbTitleNoCar = [ViewFactory CreateLabelViewWithFont:_FONT_B(15) TextColor:_COLOR(0x21, 0x21, 0x21)];
        [self addSubview:lbTitleNoCar];
        lbTitleNoCar.text = @"个险资料";
        
        LeftImgButton *btnEditNoCar = [[LeftImgButton alloc] initWithFrame:CGRectZero];
        [self addSubview:btnEditNoCar];
        btnEditNoCar.translatesAutoresizingMaskIntoConstraints = NO;
        [btnEditNoCar addTarget:self action:@selector(doEditButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnEditNoCar.titleLabel.font = _FONT(15);
        [btnEditNoCar setTitle:@"添加被保人" forState:UIControlStateNormal];
        [btnEditNoCar setTitleColor:_COLOR(0x75, 0x75, 0x75) forState:UIControlStateNormal];
        [btnEditNoCar setImage:ThemeImage(@"add_icon") forState:UIControlStateNormal];
        
        UIButton *btnClickedNoCar = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:btnClickedNoCar];
        btnClickedNoCar.translatesAutoresizingMaskIntoConstraints = NO;
        [btnClickedNoCar addTarget:self action:@selector(doBtnAddInsurInfo:) forControlEvents:UIControlEventTouchUpInside];
        btnClickedNoCar.backgroundColor = [UIColor clearColor];
        
        SepLineLabel *lbSepLineNoCar = [[SepLineLabel alloc] initWithFrame:CGRectZero];//[ViewFactory CreateLabelViewWithFont:_FONT(15) TextColor:_COLOR(0x21, 0x21, 0x21)];
        lbSepLineNoCar.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:lbSepLineNoCar];
        lbSepLineNoCar.backgroundColor = [UIColor clearColor];
        
        tableviewNoCar = [[UITableView alloc] initWithFrame:CGRectZero];
        [self addSubview:tableviewNoCar];
        tableviewNoCar.delegate = self;
        tableviewNoCar.dataSource = self;
        self.tableviewNoCar.scrollEnabled = NO;
        tableviewNoCar.translatesAutoresizingMaskIntoConstraints = NO;
        [tableviewNoCar registerNib:[UINib nibWithNibName:@"InsureInfoListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
        tableviewNoCar.backgroundColor = [UIColor clearColor];
        
        UIButton *btnApplicant = [[UIButton alloc] init];
        [self addSubview:btnApplicant];
        [btnApplicant setTitle:@"立即\n投保" forState:UIControlStateNormal];
        btnApplicant.translatesAutoresizingMaskIntoConstraints = NO;
        btnApplicant.layer.cornerRadius = 27;
        btnApplicant.backgroundColor = _COLOR(0xff, 0x66, 0x19);
        btnApplicant.titleLabel.font = _FONT_B(15);
        btnApplicant.titleLabel.numberOfLines = 2;
        btnApplicant.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnApplicant.layer.shadowColor = _COLOR(0xff, 0x66, 0x19).CGColor;
        btnApplicant.layer.shadowOffset = CGSizeMake(0, 0);
        btnApplicant.layer.shadowOpacity = 0.5;
        btnApplicant.layer.shadowRadius = 1;
        [btnApplicant addTarget:self action:@selector(doBtnInsurPlan:) forControlEvents:UIControlEventTouchUpInside];
        
        UITableView *tableview = self.tableview;
        UILabel *lbTitleCar = self.lbTitle;
        UILabel *lbSepLine = self.lbSepLine;
        NSDictionary *views1 = NSDictionaryOfVariableBindings(sepView, lbTitleNoCar, btnClickedNoCar, lbSepLineNoCar, tableviewNoCar, tableview, lbTitleCar, lbSepLine, btnEditNoCar, btnApplicant);
        [self removeConstraints:self.contentVConstraint];
        self.contentVConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[lbTitleCar(15)]-10-[lbSepLine(1)]-0-[tableview]-0-[sepView(15)]-30-[lbTitleNoCar(15)]-10-[lbSepLineNoCar(1)]-0-[tableviewNoCar]-10-[btnApplicant(54)]-20-|" options:0 metrics:nil views:views1];
        [self addConstraints:self.contentVConstraint];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btnApplicant(54)]->=0-|" options:0 metrics:nil views:views1]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sepView]-0-|" options:0 metrics:nil views:views1]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbTitleNoCar]->=10-[btnEditNoCar]-20-|" options:0 metrics:nil views:views1]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lbSepLineNoCar]-20-|" options:0 metrics:nil views:views1]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableviewNoCar]-0-|" options:0 metrics:nil views:views1]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnEditNoCar(30)]->=0-|" options:0 metrics:nil views:views1]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnClickedNoCar(40)]->=0-|" options:0 metrics:nil views:views1]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btnClickedNoCar]-20-|" options:0 metrics:nil views:views1]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:btnEditNoCar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbTitleNoCar attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:btnClickedNoCar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbTitleNoCar attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        self.editHConstraint = [NSLayoutConstraint constraintWithItem:btnEditNoCar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
        [self addConstraint:self.editHConstraint];
        
        self.tableVConstraint = [NSLayoutConstraint constraintWithItem:tableviewNoCar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        [self addConstraint:self.tableVConstraint];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);
        self.tableviewNoCar.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableviewNoCar.separatorColor = SepLineColor;
        if ([self.tableviewNoCar respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableviewNoCar setSeparatorInset:insets];
        }
        if ([self.tableviewNoCar respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableviewNoCar setLayoutMargins:insets];
        }

        
        [self.tableview registerNib:[UINib nibWithNibName:@"InsuranceTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.lbTitle.text = @"车险资料";
        self.lbTitle.font = _FONT_B(15);
        [self.btnEdit setImage:ThemeImage(@"edit_profile") forState:UIControlStateNormal];
        [self.btnEdit setTitle:@"详情" forState:UIControlStateNormal];
        [self.btnEdit setTitleColor:_COLOR(0x75, 0x75, 0x75) forState:UIControlStateNormal];
        self.btnHConstraint.constant = 60;
        
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, INTMAX_MAX)];
        _footView.backgroundColor = [UIColor clearColor];
        
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectZero];
        [_footView addSubview:bgview];
        bgview.translatesAutoresizingMaskIntoConstraints = NO;
        
        UILabel *lbTitle = [ViewFactory CreateLabelViewWithFont:_FONT_B(15) TextColor:_COLOR(0x66, 0x90, 0xab)];
        [bgview addSubview:lbTitle];
        lbTitle.text = @"如何进行车险报价？";
        
        _btnShut = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnShut.translatesAutoresizingMaskIntoConstraints = NO;
        [bgview addSubview:_btnShut];
        [_btnShut setImage:ThemeImage(@"info_zhankai") forState:UIControlStateSelected];
        [_btnShut setImage:ThemeImage(@"info_guanbi") forState:UIControlStateNormal];
        
        UIButton *btnClicked = [[UIButton alloc] initWithFrame:CGRectZero];
        btnClicked.translatesAutoresizingMaskIntoConstraints = NO;
        [bgview addSubview:btnClicked];
        [btnClicked addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        SepLineLabel *sepline = [[SepLineLabel alloc] initWithFrame:CGRectZero];
        [bgview addSubview:sepline];
        sepline.translatesAutoresizingMaskIntoConstraints = NO;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_footView addSubview:_contentView];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.clipsToBounds = YES;
        
        
        UIButton *btnQuote = [[UIButton alloc] init];
        [_footView addSubview:btnQuote];
        [btnQuote setTitle:@"车险\n报价" forState:UIControlStateNormal];
        btnQuote.translatesAutoresizingMaskIntoConstraints = NO;
        btnQuote.layer.cornerRadius = 27;
        btnQuote.backgroundColor = _COLOR(0xff, 0x66, 0x19);
        btnQuote.titleLabel.font = _FONT_B(15);
        btnQuote.titleLabel.numberOfLines = 2;
        btnQuote.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnQuote.layer.shadowColor = _COLOR(0xff, 0x66, 0x19).CGColor;
        btnQuote.layer.shadowOffset = CGSizeMake(0, 0);
        btnQuote.layer.shadowOpacity = 0.5;
        btnQuote.layer.shadowRadius = 1;
        [btnQuote addTarget:self action:@selector(doBtnCarInsurPlan:) forControlEvents:UIControlEventTouchUpInside];
        
        lb1 = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0x75, 0x75, 0x75)];
        [_contentView addSubview:lb1];
        lb1.attributedText = [self getInsuranceRules:@"＊优快保经纪人提供以下三种报价方式\n \n  1 上传车主［行驶证正本］清晰照片 或者 进入（详情）填写行驶证信息可快速报价，此报价可能与真实价格存在一点偏差，成交最终以真实价格为准。\n\n  2 上传车主［行驶证正本］和［身份证正面］清晰照片 进行精准报价。\n\n  3 续保车辆 只需进入（详情）填写［车牌号］(或传行驶证照片) 并选择［上年度保险］，就可精准报价。"];

        lb1.preferredMaxLayoutWidth = ScreenWidth - 40;
        lb1.numberOfLines = 0;
        lb2 = [ViewFactory CreateLabelViewWithFont:_FONT(12) TextColor:_COLOR(0x75, 0x75, 0x75)];
        [_contentView addSubview:lb2];
        lb2.preferredMaxLayoutWidth = ScreenWidth - 40;
        lb2.attributedText = [Util getWarningString:@"＊注：客户确认投保后，应保监会规定需要补齐以上所有证件照片方可出单。优快保经纪人将保证所有证件资料仅用于车辆报价或投保，绝不用作其它用途，请放心上传。"];
        lb2.numberOfLines = 0;

        NSDictionary *views = NSDictionaryOfVariableBindings(lbTitle, _btnShut, _contentView, lb1, lb2, btnClicked, bgview, sepline, btnQuote);
        [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=24-[lbTitle]-10-[_btnShut]-24-|" options:0 metrics:nil views:views]];
        [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-90-[btnClicked]-20-|" options:0 metrics:nil views:views]];
        [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[sepline]-24-|" options:0 metrics:nil views:views]];
        [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[lbTitle]-10-|" options:0 metrics:nil views:views]];
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentView]-0-|" options:0 metrics:nil views:views]];
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bgview]-0-|" options:0 metrics:nil views:views]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lb1]-20-|" options:0 metrics:nil views:views]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lb2]-20-|" options:0 metrics:nil views:views]];
        
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[bgview(54)]-0-[_contentView]-0-|" options:0 metrics:nil views:views]];
        [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[btnClicked(54)]-0-|" options:0 metrics:nil views:views]];
        [bgview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[sepline(1)]-0-|" options:0 metrics:nil views:views]];
        
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btnQuote(54)]->=0-|" options:0 metrics:nil views:views]];
        [_footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[btnQuote(54)]->=0-|" options:0 metrics:nil views:views]];
        [_footView addConstraint:[NSLayoutConstraint constraintWithItem:btnQuote attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sepline attribute:NSLayoutAttributeBottom multiplier:1 constant:-1]];
        
        vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[lb1]-20-[lb2]-20-|" options:0 metrics:nil views:views];
        [_contentView addConstraints:vConstraint];
        [bgview addConstraint:[NSLayoutConstraint constraintWithItem:_btnShut attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self doBtnClicked:_btnShut];
        
        [_footView setNeedsLayout];
        [_footView layoutIfNeeded];
        CGSize size = [_footView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        _footView.frame = CGRectMake(0, 0, ScreenWidth, size.height);
        
        self.tableview.tableFooterView = _footView;
        
    }
    
    return self;
}

//添加非车险被保人资料
- (void) doBtnAddInsurInfo:(id) sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToAddInsuranceInfo:)]){
        [self.delegate NotifyToAddInsuranceInfo:self];
    }
}

//车险报价
- (void) doBtnCarInsurPlan:(id) sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToPlanCarInsurance)]){
        [self.delegate NotifyToPlanCarInsurance];
    }
}

//非车险报价
- (void) doBtnInsurPlan:(id) sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToPlanInsurance:)]){
        if(_selectIdx >=0 && _selectIdx < [self.data count]){
            InsuredUserInfoModel *model = [self.data objectAtIndex:_selectIdx];
            [self.delegate NotifyToPlanInsurance:model];
        }
    }
}

- (NSMutableAttributedString *) getInsuranceRules:(NSString *) str{
    NSString *UnitPrice = str;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = [UnitPrice rangeOfString:@"＊"];
    [attString addAttribute:NSForegroundColorAttributeName value:_COLOR(0xf4, 0x43, 0x36) range:range];
    [self setAttributes:attString attribute:NSFontAttributeName value:_FONT_B(13) substr:UnitPrice rootstr:@"1"];
    [self setAttributes:attString attribute:NSFontAttributeName value:_FONT_B(13) substr:UnitPrice rootstr:@"2"];
    [self setAttributes:attString attribute:NSFontAttributeName value:_FONT_B(13) substr:UnitPrice rootstr:@"3"];
    
    [self setAttributes:attString attribute:NSForegroundColorAttributeName value:[UIColor blackColor] substr:UnitPrice rootstr:@"1"];
    [self setAttributes:attString attribute:NSForegroundColorAttributeName value:[UIColor blackColor] substr:UnitPrice rootstr:@"2"];
    [self setAttributes:attString attribute:NSForegroundColorAttributeName value:[UIColor blackColor] substr:UnitPrice rootstr:@"3"];
    
    [self addAttributes:attString substr:UnitPrice rootstr:@"［行驶证正本］"];
    [self addAttributes:attString substr:UnitPrice rootstr:@"［车牌号］"];
    [self addAttributes:attString substr:UnitPrice rootstr:@"［身份证正面］"];
    [self addAttributesBack:attString substr:UnitPrice rootstr:@"［行驶证正本］"];
    [self addAttributes:attString substr:UnitPrice rootstr:@"［上年度保险］"];
    
    return attString;
}

- (void) setAttributes:(NSMutableAttributedString *) str attribute:(NSString *)attribute value:(id)value substr:(NSString *)substr rootstr:(NSString *) rootstr
{
    NSRange range = [substr rangeOfString:rootstr];
    [str addAttribute:attribute value:value range:range];
}

- (void) addAttributesBack:(NSMutableAttributedString *) str substr:(NSString *)substr rootstr:(NSString *) rootstr
{
    NSRange range = [substr rangeOfString:rootstr options:NSBackwardsSearch];
    [str addAttribute:NSFontAttributeName value:_FONT_B(12) range:range];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
}

- (void) addAttributes:(NSMutableAttributedString *) str substr:(NSString *)substr rootstr:(NSString *) rootstr
{
    NSRange range = [substr rangeOfString:rootstr];
    [str addAttribute:NSFontAttributeName value:_FONT_B(12) range:range];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
}

- (void) doBtnClicked:(UIButton *)sender
{
    BOOL selected = _btnShut.selected;
    [_contentView removeConstraints:vConstraint];
    NSDictionary *views = NSDictionaryOfVariableBindings( lb1, lb2);
    if(!selected){
        vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lb1(0)]-0-[lb2(0)]-0-|" options:0 metrics:nil views:views];
    }
    else{
        vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[lb1]-20-[lb2]-20-|" options:0 metrics:nil views:views];
    }
    [_contentView addConstraints:vConstraint];
    [_footView setNeedsLayout];
    [_footView layoutIfNeeded];
    CGSize size = [_footView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    _footView.frame = CGRectMake(0, 0, ScreenWidth, size.height);
    _btnShut.selected = !selected;
    self.tableview.tableFooterView = _footView;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToRefreshSubviewFrames)]){
        [self.delegate NotifyToRefreshSubviewFrames];
    }
}

- (CGFloat) resetSubviewsFrame
{
    NSInteger num = [self tableView:self.tableview numberOfRowsInSection:0];
    CGFloat tableheight = 0;
    for (int i = 0; i < num; i++) {
        tableheight += [self tableView:self.tableview heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    tableheight += [self tableView:self.tableviewNoCar numberOfRowsInSection:0] * CELL_HEIGHT;
    self.tableVConstraint.constant = [self tableView:self.tableviewNoCar numberOfRowsInSection:0] * CELL_HEIGHT;

    
    return tableheight + 147 + 68 + _footView.frame.size.height;
}

- (void) doEditButtonClicked:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyModifyInsuranceInfo:)]){
        [self.delegate NotifyModifyInsuranceInfo:self];
    }
}

#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView != tableviewNoCar)
        return 2;
    else
        return [self.data count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView != tableviewNoCar){
        CGFloat height = 70;
        CGSize size = self.frame.size;
        
        if(size.width == 375)
            height = 70 + 17;
        else if (size.width == 414)
            height = 70 + 29;
        
        NSInteger row = indexPath.row;
        NSString *content ;
        if(row == 0){
            content = _carInfo.carNo;
        }
        else if(row == 1){
            content = _carInfo.carOwnerCard;
        }
        if(content == nil || [content length] == 0)
        {
            return height;
        }
        return height + 32;
    }else
        return CELL_HEIGHT;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView != tableviewNoCar)
    {
        NSString *deq = @"cell";
        InsuranceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
        if(!cell){
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"InsuranceTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSInteger row = indexPath.row;
        
        cell.imgV1.tag = 100 + row * 2;
        cell.imgV2.tag = 100 + row * 2 + 1;
        [cell.imgV1 addTarget:self action:@selector(doBtnAddImage:) forControlEvents:UIControlEventTouchUpInside];
        [cell.imgV2 addTarget:self action:@selector(doBtnAddImage:) forControlEvents:UIControlEventTouchUpInside];
        
        if(row == 0){
            [self setCellData:cell title:@"行驶证" value:@"(正本／副本)" content:_carInfo.carNo img1:self.carInfo.travelCard1 placeholderImage1:@"driveLisence1" img2:self.carInfo.travelCard2 placeholderImage2:@"driveLisence2"];
            if(driveLisence1 != nil){
                [cell.imgV1 setImage:driveLisence1 forState:UIControlStateNormal];
            }
            if(driveLisence2 != nil){
                [cell.imgV2 setImage:driveLisence2 forState:UIControlStateNormal];
            }
        }
        else if (row == 1){
            [self setCellData:cell title:@"车主身份证" value:@"(正面／反面)" content:_carInfo.carOwnerCard img1:self.carInfo.carOwnerCard1 placeholderImage1:@"cert1" img2:self.carInfo.carOwnerCard2 placeholderImage2:@"cert2"];
            if(cert1 != nil){
                [cell.imgV1 setImage:cert1 forState:UIControlStateNormal];
            }
            if(cert2 != nil){
                [cell.imgV2 setImage:cert2 forState:UIControlStateNormal];
            }
        } ;
        
        return cell;
    }else
    {
        NSString *deq = @"cell1";
        InsureInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
        if(!cell){
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"InsureInfoListTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        cell.delegate = self;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSInteger row = indexPath.row;
        if(_selectIdx == row){
            cell.btnSelected.selected = YES;
        }else{
            cell.btnSelected.selected = NO;
        }
        cell.btnSelected.tag = 100 + row;
        
        InsuredUserInfoModel *model = [self.data objectAtIndex:row];
        cell.lbName.text = model.insuredName;
        cell.lbRelation.text = model.relationTypeName;
        
        return cell;
    }
}

- (void) setCellData:(InsuranceTableViewCell *) cell title:(NSString *)title value:(NSString *) value content:(NSString *) content img1:(NSString *) img1 placeholderImage1:(NSString *)placeholderImage1 img2:(NSString *)img2 placeholderImage2:(NSString *)placeholderImage2
{
    cell.lbTitle.text = title;
    cell.lbDetail.text = value;
    cell.lbContent.text = content;
    if(content == nil || [content length] == 0){
        cell.contentVConstraint.constant = 0;
        cell.spaceVConstraint.constant = 0;
    }else{
        cell.contentVConstraint.constant = 22;
        cell.spaceVConstraint.constant = 10;
    }
    CGSize size1 = cell.imgV1.frame.size;
    NSString *url1 = FormatImage(img1, (int)size1.width, (int)size1.height);
    [cell.imgV1 sd_setBackgroundImageWithURL:[NSURL URLWithString:url1] forState:UIControlStateNormal placeholderImage:ThemeImage(placeholderImage1)];
    
    CGSize size2 = cell.imgV2.frame.size;
    NSString *url2 = FormatImage(img2, (int)size2.width, (int)size2.height);
    [cell.imgV2 sd_setBackgroundImageWithURL:[NSURL URLWithString:url2] forState:UIControlStateNormal placeholderImage:ThemeImage(placeholderImage2)];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(tableView == tableviewNoCar){
        if(self .delegate && [self.delegate respondsToSelector:@selector(NotifyHandleInsuranceInfoClicked:idx:)]){
            [self.delegate NotifyHandleInsuranceInfoClicked:self idx:indexPath.row];
        }
    }
}

- (void) setCarInfo:(CarInfoModel *)model
{
    _carInfo = model;
    [self.tableview reloadData];
}

- (void) doBtnAddImage:(UIButton *) sender
{
    int tag = sender.tag - 100;
    BOOL flag = YES;
    if(tag == 0){
        if(self.carInfo.travelCard1 == nil)
            flag = NO;
    }
    else if (tag == 1){
        if(self.carInfo.travelCard2 == nil)
            flag = NO;
    }
    else if (tag ==2 ){
        if(self.carInfo.carOwnerCard1 == nil)
            flag = NO;
    }
    else{
        if(self.carInfo.carOwnerCard2 == nil)
            flag = NO;
    }
    [self addImage:flag];
    addImgButton = sender;
}

/*
 flag : YES，显示查看原图
 flag : NO, 不显示查看原图
 */
- (void) addImage:(BOOL) flag
{
    if(flag){
        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@""
                                                        delegate:(id)self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"查看原图", @"从相册选取", @"拍照",nil];
        ac.actionSheetStyle = UIBarStyleBlackTranslucent;
        [ac showInView:self];
        ac.tag = 1001;
    }else{
        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@""
                                                        delegate:(id)self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"从相册选取", @"拍照",nil];
        ac.actionSheetStyle = UIBarStyleBlackTranslucent;
        [ac showInView:self];
        ac.tag = 1002;
    }
}

#pragma mark- UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.pVc dismissViewControllerAnimated:YES completion:^{
        NSData * imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1);
        
        UIImage *image= [UIImage imageWithData:imageData];
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp)
        {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
        
        UIImage *new = [Util scaleToSize:image scaledToSize:CGSizeMake(1500, 1500)];
        
        [addImgButton setImage:new forState:UIControlStateNormal];
         NSInteger tag = addImgButton.tag - 100;
        if(tag == 0){
            driveLisence1 = new;
            [self saveOrUpdateCustomerCar:new travelCard2:nil];
        }
        else if (tag == 1){
            driveLisence2 = new;
            [self saveOrUpdateCustomerCar:nil travelCard2:new];
        }
        else if (tag ==2 ){
            cert1 = new;
            [self saveOrUpdateCustomer:new cert2:nil];
        }
        else{
            cert2 = new;
            [self saveOrUpdateCustomer:nil cert2:new];
        }
    }];
}

#pragma mark- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if(actionSheet.tag == 1002){
            [Util openPhotoLibrary:self.pVc delegate:self allowEdit:NO completion:nil];
            return;
        }else{
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            [self addObject:self.carInfo.travelCard1 array:array];
            [self addObject:self.carInfo.travelCard2 array:array];
            [self addObject:self.carInfo.carOwnerCard1 array:array];
            [self addObject:self.carInfo.carOwnerCard2 array:array];
            
            _imageList = [[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
            [_imageList addImagesURL:array withSmallImage:nil];
            [self.window addSubview:_imageList];
            if(addImgButton.tag == 100){}
            else if (addImgButton.tag == 101){
                if(self.carInfo.travelCard1 == nil)
                    [_imageList setIndex:0];
                else
                    [_imageList setIndex: 1];
            }
            else if (addImgButton.tag == 102){
                if(self.carInfo.carOwnerCard2 == nil)
                    [_imageList setIndex:[array count] - 1];
                else
                    [_imageList setIndex: [array count] - 2];
            }
            else{
                [_imageList setIndex:[array count] - 1];
            }
            addImgButton = nil;
        }
        
    }else if (buttonIndex == 1)
    {
        if(actionSheet.tag == 1002){
            [Util openCamera:self.pVc delegate:self allowEdit:NO completion:nil];
        }else{
           [Util openPhotoLibrary:self.pVc delegate:self allowEdit:NO completion:nil];
        }
    }
    else if (buttonIndex == 2){
        if(actionSheet.tag == 1002){
            addImgButton = nil;
            return;
        }
        else{
            [Util openCamera:self.pVc delegate:self allowEdit:NO completion:nil];
        }
    }
    else{
        addImgButton = nil;
    }
}

- (BOOL) addObject:(NSString *) path array:(NSMutableArray *) array;
{
    if(path != nil){
        [array addObject:path];
        return YES;
    }else
        return NO;
}

-(void)dismissImageAction:(UIImageView*)sender
{
    NSLog(@"dismissImageAction");
    [_imageList removeFromSuperview];
    _imageList = nil;
}

- (void) saveOrUpdateCustomerCar:(UIImage *) travelCard1 travelCard2:(UIImage *)travelCard2
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToSubmitImage:travelCard2:image1:cert2:)]){
        [self.delegate NotifyToSubmitImage:travelCard1 travelCard2:travelCard2 image1:nil cert2:nil];
    }
}

- (void) saveOrUpdateCustomer:(UIImage *) image1 cert2:(UIImage *)image2
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(NotifyToSubmitImage:travelCard2:image1:cert2:)]){
        [self.delegate NotifyToSubmitImage:nil travelCard2:nil image1:image1 cert2:image2];
    }
}


- (void) NotifySelectedAtIndex:(NSInteger) idx cell:(InsureInfoListTableViewCell *) cell
{
    _selectIdx = idx;
    [self.tableviewNoCar reloadData];
}

- (void) setData:(NSArray *)data
{
    _data = data;
    [self.tableviewNoCar reloadData];
}

@end
