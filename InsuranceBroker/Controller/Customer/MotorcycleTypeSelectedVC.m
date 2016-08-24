//
//  MotorcycleTypeSelectedVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/8/18.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "MotorcycleTypeSelectedVC.h"
#import "define.h"

@interface MotorcycleTypeSelectedVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableType;
@property (nonatomic, strong) UITableView *tableDetail;

@end

@implementation MotorcycleTypeSelectedVC
@synthesize tableDetail;
@synthesize tableType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"选择车型";
    
    tableType = [[UITableView alloc] initWithFrame:CGRectZero];
    tableType.delegate = self;
    tableType.dataSource = self;
    tableType.tag = 1001;
    [self.view addSubview:tableType];
    tableType.translatesAutoresizingMaskIntoConstraints = NO;
    
    tableDetail = [[UITableView alloc] initWithFrame:CGRectZero];
    tableDetail.delegate = self;
    tableDetail.dataSource = self;
    tableDetail.tag = 1002;
    [self.view addSubview:tableDetail];
    tableDetail.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(tableDetail, tableType);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableDetail]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableType]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableType(100)]-0-[tableDetail]-0-|" options:0 metrics:nil views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:<#(nonnull NSString *)#> options:0 metrics:nil views:views]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource
#pragma UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int tag = tableView.tag;
    if(tag == 1001)
        return 50.f;
    else
        return 42.f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int tag = tableView.tag;
    if( tag == 1001){
        NSString *deq = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
            cell.textLabel.font = _FONT(15);
            cell.textLabel.textColor = _COLOR(0x21, 0x21, 0x21);
        }
        
        cell.textLabel.text = @"gtwetr";
        
        return cell;
    }else{
        
        NSString *deq = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
            cell.textLabel.font = _FONT(12);
            cell.textLabel.textColor = _COLOR(0x75, 0x75, 0x75);
            cell.textLabel.numberOfLines = 0;
        }
        
        cell.textLabel.text = @"gtwetrewtqerwtwetrertwertwertwert";
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int tag = tableView.tag;
    if(tag == 1001){
        
    }
    else{
        if(self.delegate && [self.delegate respondsToSelector:@selector(NotifySelected:result:)]){
            [self.delegate NotifySelected:self result:@""];
        }
    }
}


@end
