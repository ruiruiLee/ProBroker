//
//  MyOrderVC.m
//  InsuranceBroker
//
//  Created by LiuZach on 16/9/7.
//  Copyright © 2016年 LiuZach. All rights reserved.
//

#import "MyOrderVC.h"
#import "OrderManagerVC.h"
#import "define.h"

#import "LMDefaultMenuItemCell.h"

@implementation MyOrderVC
@synthesize pageControl;
@synthesize contentContainer;

- (NSMutableArray *)pages
{
    if (!_pages)_pages = [NSMutableArray new];
    return _pages;
}

- (void)addSubControllers{
    NSMutableArray *pages = [NSMutableArray new];
    
    _firstVC = [[OrderManagerVC alloc] initWithNibName:nil bundle:nil];
    _firstVC.insuranceType = @"1";
    [_firstVC setViewTitle:@"车险"];
    [_firstVC initMapTypesForCar];
    [pages addObject:_firstVC];
    [self addChildViewController:_firstVC];
    
    _secondVC = [[OrderManagerVC alloc] initWithNibName:nil bundle:nil];
    _secondVC.insuranceType = @"2";
    [_secondVC setViewTitle:@"非车险"];
    [_secondVC initMapTypesForNoCar];
    [pages addObject:_secondVC];
    [self addChildViewController:_secondVC];
    
    [self setPages:pages];
    
    //调整子视图控制器的Frame已适应容器View
    [self fitFrameForChildViewController:_firstVC];
    //设置默认显示在容器View的内容
    [self.contentContainer addSubview:_firstVC.view];
    
    _currentVC = _firstVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageControl = [[HMSegmentedControl alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pageControl];
    pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    contentContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:contentContainer];
    contentContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(pageControl, contentContainer);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pageControl]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentContainer]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pageControl(48)]-0-[contentContainer]-0-|" options:0 metrics:nil views:views]];

    
    [self.pageControl addTarget:self
                         action:@selector(pageControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    self.pageControl.backgroundColor = _COLOR(0xf5, 0xf5, 0xf5);
    self.pageControl.textColor = _COLOR(0x21, 0x21, 0x21);
    self.pageControl.selectionIndicatorColor = _COLOR(0xff, 0x66, 0x19);
    self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.pageControl.selectedTextColor = _COLOR(0xff, 0x66, 0x19);
    self.pageControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.pageControl.showVerticalDivider = YES;
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    self.navigationItem.titleView = titleView;
    
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 160, 22)];
    lb.text = @"我的保单";
    lb.font = _FONT_B(18);
    lb.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:lb];
    UIImageView *image = [[UIImageView alloc] initWithImage:ThemeImage(@"xialaliebiao")];
    image.frame = CGRectMake(70, 24, 19, 16);
    [titleView addSubview:image];
    
    HighNightBgButton *btn = [[HighNightBgButton alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    [titleView addSubview:btn];
    [btn addTarget:self action:@selector(doBtnSelectOrderStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    [self  initSubViews];
    [self addSubControllers];
//

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateTitleLabels];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void) initSubViews
{
    //menu;
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.tag = 100002;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.menuTableView.separatorColor = SepLineColor;
    if ([self.menuTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.menuTableView setSeparatorInset:insets];
    }
}

- (void) doBtnSelectOrderStatus:(id) sender
{
    OrderManagerVC *vc = (OrderManagerVC *) [self selectedController];
    CGFloat tHeight = vc.mapTypes.count * 50;

    if(tHeight > 0.5 * SCREEN_HEIGHT)
        tHeight = 0.5 * SCREEN_HEIGHT;
    [self.menuTableView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, tHeight)];
    [self.menuTableView reloadData];
    
    // Init dropdown view
    if (!self.dropdownView)
    {
        self.dropdownView = [[LMDropdownView alloc] init];
        self.dropdownView.menuContentView = self.menuTableView;
        self.dropdownView.menuBackgroundColor = _COLORa(0xff, 0xff, 0xff, 0.6);
    }
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen])
    {
        [self.dropdownView hide];
    }
    else
    {
        [self.dropdownView showInView:self.view withFrame:self.view.bounds];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)updateTitleLabels
{
    [self.pageControl setSectionTitles:[self titleLabels]];
}

- (NSArray *)titleLabels
{
    NSMutableArray *titles = [NSMutableArray new];
    for (UIViewController *vc in self.pages) {
        if ([vc conformsToProtocol:@protocol(THSegmentedPageViewControllerDelegate)] && [vc respondsToSelector:@selector(viewControllerTitle)] && [((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]) {
            [titles addObject:[((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]];
        } else {
            [titles addObject:vc.title ? vc.title : NSLocalizedString(@"NoTitle",@"")];
        }
    }
    return [titles copy];
}

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.25f : 0.f animations:^{
        if (hidden) {
            self.pageControl.alpha = 0.0f;
        } else {
            self.pageControl.alpha = 1.0f;
        }
    }];
    [self.pageControl setHidden:hidden];
    [self.view setNeedsLayout];
}

- (UIViewController *)selectedController
{
    return self.pages[[self.pageControl selectedSegmentIndex]];
}

#pragma mark - Callback

- (void)pageControlValueChanged:(id)sender
{
    NSInteger idx = [self.pageControl selectedSegmentIndex];
    
    switch (idx) {
        case 0:{
            [self fitFrameForChildViewController:(UIViewController *)[self.pages objectAtIndex:0]];
            [self transitionFromOldViewController:_currentVC toNewViewController:(UIViewController *)[self.pages objectAtIndex:0]];
        }
            break;
        case 1:{
            [self fitFrameForChildViewController:(UIViewController *)[self.pages objectAtIndex:1]];
            [self transitionFromOldViewController:_currentVC toNewViewController:(UIViewController *)[self.pages objectAtIndex:1]];
        }
            break;
    }
}


#pragma UITableViewDataSource UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderManagerVC *vc = (OrderManagerVC *) [self selectedController];
    return vc.mapTypes.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    return 50.f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"LMDefaultMenuItemCell" owner:self options:nil];
    LMDefaultMenuItemCell *cell = [xibs firstObject];
    
    // Set data for cell
    OrderManagerVC *vc = (OrderManagerVC *) [self selectedController];
    NSString *mapType = [[vc.mapTypes objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.menuItemLabel.text = mapType;
    cell.selectedMarkView.hidden = (indexPath.row != vc.currentMapTypeIndex);
    
    return cell;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.menuTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.dropdownView hide];
    
    __weak MyOrderVC *weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.dropdownView.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        OrderManagerVC *vc = (OrderManagerVC *) [weakself selectedController];
        vc.currentMapTypeIndex = indexPath.row;
    });
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:insets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
}

- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    CGRect frame = self.contentContainer.frame;
    frame.origin.y = 0;
    chileViewController.view.frame = frame;
}

//转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
//        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVC = newViewController;
//        }else{
//            _currentVC = oldViewController;
//        }
    }];
}

//移除所有子视图控制器
- (void)removeAllChildViewControllers{
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}

@end
