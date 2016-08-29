//
//  THSegmentedPager.m
//  THSegmentedPagerExample
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "THSegmentedPager.h"
#import "THSegmentedPageViewControllerDelegate.h"
#import "NetWorkHandler+queryForProductAttrPageList.h"
#import "define.h"
#import "DictModel.h"
#import "productAttrModel.h"
#import "ProductListViewController.h"

@interface THSegmentedPager ()
@property (strong, nonatomic)UIPageViewController *pageViewController;
@end

#define _COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@implementation THSegmentedPager

@synthesize pageViewController = _pageViewController;
@synthesize pages = _pages;
@synthesize pageControl;
@synthesize contentContainer;

- (NSMutableArray *)pages
{
    if (!_pages)_pages = [NSMutableArray new];
    return _pages;
}

- (void) loadData
{
    [ProgressHUD show:nil];
    NSString *method = @"/web/common/getDicts.xhtml?dictType=insuranceType&limitVal=1";
    NetWorkHandler *handle = [NetWorkHandler shareNetWorkHandler];
    __weak THSegmentedPager *weakself = self;
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
    NSMutableArray *pages = [NSMutableArray new];
    for (int i = 0; i < [self.dataList count]; i++) {
        // Create a new view controller and pass suitable data.
        
        DictModel *model = [self.dataList objectAtIndex:i];
        
        ProductListViewController *pagedViewController = [[ProductListViewController alloc] initWithNibName:nil bundle:nil];
        [pagedViewController setViewTitle:model.dictName];
        pagedViewController.category = model.dictValue;
        [pages addObject:pagedViewController];
    }
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.pages count]>0) {
        [self.pageViewController setViewControllers:@[self.pages[0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:NULL];
    }
    [self updateTitleLabels];
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
