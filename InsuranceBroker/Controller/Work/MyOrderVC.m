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

- (void) initMenus
{
    NSMutableArray *pages = [NSMutableArray new];
        
    OrderManagerVC *chexian = [[OrderManagerVC alloc] initWithNibName:nil bundle:nil];
    [chexian setViewTitle:@"车险"];
    chexian.insuranceType = @"1";
    [pages addObject:chexian];
    
    OrderManagerVC *gexian = [[OrderManagerVC alloc] initWithNibName:nil bundle:nil];
    [gexian setViewTitle:@"个险"];
    gexian.insuranceType = @"2";
    [pages addObject:gexian];
    
    [self setPages:pages];
    
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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pageControl(50)]-0-[contentContainer]-0-|" options:0 metrics:nil views:views]];
    
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];
    [self.contentContainer addSubview:self.pageViewController.view];
    
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

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.pages count]>0 && [self.pageViewController.viewControllers count] == 0) {
        [self.pageViewController setViewControllers:@[self.pages[0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:NULL];
    }
    [self updateTitleLabels];
}

- (void) initSubViews
{
    //menu;
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.tag = 100002;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.menuTableView.separatorColor = SepLineColor;
    if ([self.menuTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.menuTableView setSeparatorInset:insets];
    }
    if ([self.menuTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.menuTableView setLayoutMargins:insets];
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
        self.dropdownView.menuBackgroundColor = _COLORa(0xff, 0xff, 0xff, 0.6);//[UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
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

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < [self.pages count]) {
        [self.pageControl setSelectedSegmentIndex:index animated:YES];
        [self.pageViewController setViewControllers:@[self.pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    
    return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){
        return;
    }
    
    [self.pageControl setSelectedSegmentIndex:[self.pages indexOfObject:[viewController.viewControllers lastObject]] animated:YES];
}

#pragma mark - Callback

- (void)pageControlValueChanged:(id)sender
{
    UIPageViewControllerNavigationDirection direction = [self.pageControl selectedSegmentIndex] > [self.pages indexOfObject:[self.pageViewController.viewControllers lastObject]] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[[self selectedController]]
                                      direction:direction
                                       animated:YES
                                     completion:NULL];
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
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 15, 0, 0);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:insets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
}

@end
