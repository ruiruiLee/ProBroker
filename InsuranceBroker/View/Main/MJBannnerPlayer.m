//
//  MJBannnerPlayer.m
//  MJBannerPlayer
//
//  Created by WuXushun on 16/1/21.
//  Copyright © 2016年 wuxushun. All rights reserved.
//

#import "MJBannnerPlayer.h"
#import "UIImageView+WebCache.h"
#import "define.h"
#import "PosterModel.h"
@interface MJBannnerPlayer ()<UIScrollViewDelegate>

@property (nonatomic) CGRect currentRect;
@property (nonatomic, strong)  UIScrollView *mainSv;
@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MJBannnerPlayer

//便利构造器
+ (void)initWithSourceArray:(NSArray *)picArray
                  addTarget:(id)controller
                   delegate:(id)delegate
                   withSize:(CGRect)frame
           withTimeInterval:(CGFloat)interval{
    
    MJBannnerPlayer *new = [[MJBannnerPlayer alloc]initWithFrame:frame];
    new.currentRect = frame;
    new.sourceArray = picArray;
    new.timeInterval = interval;
    new.delegate = delegate;
    if ([controller isKindOfClass:[UIView class]]) {
        
        [controller addSubview:new];
        
    }else if ([controller isKindOfClass:[UIViewController class]]){
        
        UIViewController *view = controller;
        
        [view.view addSubview:new];
        
    }
    [new setImage:picArray];
    [new initTimer];
    
}

+ (void)initWithUrlArray:(NSArray *)urlArray
               addTarget:(UIView *)view
                delegate:(id)delegate
                withSize:(CGRect)frame
        withTimeInterval:(CGFloat)interval{

    MJBannnerPlayer *new = [[MJBannnerPlayer alloc]initWithFrame:frame];
    new.currentRect = frame;
    new.sourceArray = urlArray;
    new.timeInterval = interval;
    new.delegate = delegate;
    [view addSubview:new];
     [new setImage:urlArray];
     //[new initMXPageController:urlArray.count];
    [new initTimer];
    

}

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.currentRect = frame;
        [self initScrollView];
        [self initImageView];
        
    }

    return self;
    
}

//初始化主滑动视图
-(void)initScrollView{

    self.mainSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.currentRect.size.width, self.currentRect.size.height)];
    self.mainSv.backgroundColor = [UIColor redColor];
    self.mainSv.bounces = NO;
    self.mainSv.showsHorizontalScrollIndicator = NO;
    self.mainSv.showsVerticalScrollIndicator = NO;
    self.mainSv.pagingEnabled = YES;
    self.mainSv.contentSize = CGSizeMake(self.currentRect.size.width * 3, self.currentRect.size.height);
    self.mainSv.delegate = self;
    [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
    [self addSubview:self.mainSv];

}

//初始化imageview
-(void)initImageView{

    CGFloat width = 0;
    
    for (int a = 0; a < 3; a++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width, 0, self.currentRect.size.width, self.currentRect.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = a + 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgActive:)];
        [imageView addGestureRecognizer:tap];
        [self.mainSv addSubview:imageView];
        width += self.currentRect.size.width;
        
    }
}

//自动布局创建自定义的pageController
-(void)initMXPageController:(NSUInteger)totalPageNumber{

    UIImageView *pageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pageView"]];
    pageView.translatesAutoresizingMaskIntoConstraints = NO;
    pageView.backgroundColor = [UIColor clearColor];
    [self addSubview:pageView];
    
    NSLayoutConstraint *constraintButtom = [NSLayoutConstraint constraintWithItem:pageView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.f
                                                                          constant:-5.f];
    
    NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem:pageView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.f
                                                                        constant:-15.f];
    
    NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:pageView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.f
                                                                        constant:90.f / 375 * [UIScreen mainScreen].bounds.size.width * 0.55];
    
    NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:pageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.f
                                                                         constant:33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.55];
    
    [self addConstraints:@[constraintButtom,constraintRight,constraintWidth,constraintHeight]];
    
    UILabel *pageNumber = [[UILabel alloc]init];
    pageNumber.translatesAutoresizingMaskIntoConstraints = NO;
    pageNumber.layer.backgroundColor = [UIColor whiteColor].CGColor;
    pageNumber.text = @"1";
    pageNumber.textColor = [UIColor colorWithRed:255.f / 255.f green:78.f / 255.f blue:0.f / 255.f alpha:1.f];
    pageNumber.textAlignment = NSTextAlignmentCenter;
    pageNumber.font = [UIFont boldSystemFontOfSize:12.f / 375 * [UIScreen mainScreen].bounds.size.width];
    pageNumber.tag = 99;
    [self addSubview:pageNumber];
    pageNumber.layer.cornerRadius = 33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.5 / 2.f;
    pageNumber.layer.borderWidth = 0.5f;
    pageNumber.layer.borderColor = [UIColor colorWithRed:109.f / 255.f green:109.f / 255.f blue:109.f / 255.f alpha:1.f].CGColor;
    pageNumber.layer.masksToBounds = YES;
    
    NSLayoutConstraint *constraintPageRight = [NSLayoutConstraint constraintWithItem:pageNumber
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:pageView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.f
                                                                         constant:4.f];
    
    NSLayoutConstraint *constraintPageCenter = [NSLayoutConstraint constraintWithItem:pageNumber
                                                                       attribute:NSLayoutAttributeCenterY
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:pageView
                                                                       attribute:NSLayoutAttributeCenterY
                                                                      multiplier:1.f
                                                                        constant:0.f];
    
    NSLayoutConstraint *constraintPageWidth = [NSLayoutConstraint constraintWithItem:pageNumber
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.f
                                                                        constant:33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.55];
    
    NSLayoutConstraint *constraintPageHeight = [NSLayoutConstraint constraintWithItem:pageNumber
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.f
                                                                         constant:33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.55];
    
    [self addConstraints:@[constraintPageCenter,constraintPageRight,constraintPageWidth,constraintPageHeight]];
    
    UILabel *totalPage = [UILabel new];
    totalPage.translatesAutoresizingMaskIntoConstraints = NO;
    totalPage.textAlignment = NSTextAlignmentCenter;
    totalPage.font = [UIFont boldSystemFontOfSize:14.f / 375 * [UIScreen mainScreen].bounds.size.width];
    totalPage.textColor = [UIColor whiteColor];
    totalPage.text = [NSString stringWithFormat:@"／ %ld",(unsigned long)totalPageNumber];
    totalPage.backgroundColor = [UIColor clearColor];
    [self addSubview:totalPage];
    
    NSLayoutConstraint *constrainttotalPageRight = [NSLayoutConstraint constraintWithItem:totalPage
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:pageView
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.f
                                                                            constant:0.f];
    
    NSLayoutConstraint *constrainttotalPageCenter = [NSLayoutConstraint constraintWithItem:totalPage
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:pageView
                                                                            attribute:NSLayoutAttributeCenterY
                                                                           multiplier:1.f
                                                                             constant:0.f];
    
    NSLayoutConstraint *constrainttotalPageWidth = [NSLayoutConstraint constraintWithItem:totalPage
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.f
                                                                            constant:85.f / 375 * [UIScreen mainScreen].bounds.size.width * 0.55];
    
    NSLayoutConstraint *constrainttotalPageHeight = [NSLayoutConstraint constraintWithItem:totalPage
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.f
                                                                             constant:33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.55];
    
    [self addConstraints:@[constrainttotalPageRight,constrainttotalPageCenter,constrainttotalPageWidth,constrainttotalPageHeight]];

}

//初始化一个定时器
-(void)initTimer{

    if (self.timer == nil) {
        
        self.timer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]
                                             interval:self.timeInterval
                                               target:self
                                             selector:@selector(timerActive:)
                                             userInfo:nil
                                              repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    }

}

//点击图片的回调
-(void)imgActive:(id)sender{

    [self.delegate MJBannnerPlayer:self didSelectedIndex:self.index];

}

//定时器事件
-(void)timerActive:(id)sender{
    
    [self.mainSv scrollRectToVisible:CGRectMake(self.currentRect.size.width * 2, 0, self.currentRect.size.width, self.currentRect.size.height) animated:YES];

}

//动画开始时的回调
-(void)animationDidStart:(CAAnimation *)anim{

    UILabel *index = (UILabel *)[self viewWithTag:99];
    index.text = [NSString stringWithFormat:@"%d",self.index + 1];

}

//首次初始化图片
-(void)setImage:(NSArray *)sourceList{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceList];
    
    UIImageView *indexViewOne = (UIImageView *)[self.mainSv viewWithTag:1];
    UIImageView *indexViewTwo = (UIImageView *)[self.mainSv viewWithTag:2];
    UIImageView *indexViewThree = (UIImageView *)[self.mainSv viewWithTag:3];
    
    self.index = 0;

//    for (id obj in tempArray) {
//        
//        if (![obj isKindOfClass:[UIImage class]]) {
//            
//            [tempArray removeObject:obj];
//        }
//        
//    }
    
    if (tempArray.count > 0) {
        
        if (sourceList.count == 1){
             id obj =[tempArray objectAtIndex:0];
            [tempArray addObject:obj];
            [tempArray addObject:obj];
           
             if ([obj isKindOfClass:[UIImage class]]) {
                 indexViewOne.image = obj;
                 indexViewTwo.image = obj;
                 indexViewThree.image = obj;

             }
             else{
                  [indexViewOne sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:Normal_Image];
                  [indexViewTwo sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:Normal_Image];
                  [indexViewThree sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:Normal_Image];
             }
            
        }else if (sourceList.count == 2){
            
            id obj =[tempArray objectAtIndex:0];
            [tempArray addObject:obj];
            
            if ([obj isKindOfClass:[UIImage class]]) {
                indexViewOne.image = [tempArray objectAtIndex:1];
                indexViewTwo.image = obj;
                indexViewThree.image = [tempArray objectAtIndex:1];
                
            }
            else{
                [indexViewOne sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:1]] placeholderImage:Normal_Image];
                [indexViewTwo sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:Normal_Image];
                [indexViewThree sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:1]] placeholderImage:Normal_Image];
            }

            
        }else{
            id obj =[tempArray objectAtIndex:0];
            if ([obj isKindOfClass:[UIImage class]]) {
               indexViewOne.image = [tempArray objectAtIndex:tempArray.count - 1];
                indexViewTwo.image = obj;
                indexViewThree.image = [tempArray objectAtIndex:1];
                
            }
            else{
                [indexViewOne sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:tempArray.count - 1]] placeholderImage:Normal_Image];
                [indexViewTwo sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:Normal_Image];
                [indexViewThree sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:1]] placeholderImage:Normal_Image];
            }

        }
        
        self.sourceArray = tempArray;
        [self initMXPageController:self.sourceArray.count];
        
    }else{
    
        NSLog(@"数据源错误，设置图片失败");
    
    }
    
}

//设置图片
-(void)setPicWithIndex:(NSUInteger)index withImage:(id)img{

    if ([img isKindOfClass:[NSString class]]) {
        UIImageView *indexView = (UIImageView *)[self.mainSv viewWithTag:index];
        [indexView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:Normal_Image];
    }
    else{
    UIImageView *indexView = (UIImageView *)[self.mainSv viewWithTag:index];
    indexView.image = img;
    }
}



//触摸后停止定时器
- (void)scrollViewWillBeginDragging:( UIScrollView *)scrollView{

    if (self.timer != nil) {
        
        [self.timer invalidate];
        self.timer = nil;
        
    }

}

//触摸停止后再次启动定时器
- (void)scrollViewDidEndDragging:( UIScrollView *)scrollView willDecelerate:( BOOL )decelerate{
    
    [self initTimer];

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView == self.mainSv) {
        //三个图uiimageview交替部分
        if (self.mainSv.contentOffset.x == 0) {
            
            if (self.index == 0) {
                
                self.index = self.sourceArray.count - 1;
                [self setPicWithIndex:2 withImage:[self.sourceArray objectAtIndex:self.index]];
                [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
                [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.index - 1]];
                [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:0]];
                
            }else{
                
                self.index --;
                [self setPicWithIndex:2 withImage:[self.sourceArray objectAtIndex:self.index]];
                [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
                
                if (self.index == 0) {
                    
                    [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.sourceArray.count - 1]];
                    
                }else{
                
                   [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.index - 1]];
                
                }
                
                [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:self.index + 1]];
                
            }
            
            //页码翻页动画
            UILabel *index = (UILabel *)[self viewWithTag:99];
            CATransition *animation = [CATransition animation];
            animation.delegate = self;
            [animation setDuration:0.5f];
            [animation setType:@"oglFlip"];
            [animation setSubtype:kCATransitionFromRight];
            [animation setFillMode:kCAFillModeRemoved];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [index.layer addAnimation:animation forKey:nil];
            
        }else if (self.mainSv.contentOffset.x == self.currentRect.size.width * 2){
            
            if (self.index == self.sourceArray.count - 1) {
                
                self.index = 0;
                [self setPicWithIndex:2 withImage:[self.sourceArray objectAtIndex:self.index]];
                [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
                [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.sourceArray.count - 1]];
                [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:self.index + 1]];
                
                
                
            }else{
                
                self.index ++;
                [self setPicWithIndex:2 withImage:[self.sourceArray objectAtIndex:self.index]];
                [self.mainSv setContentOffset:CGPointMake(self.currentRect.size.width, 0)];
                [self setPicWithIndex:1 withImage:[self.sourceArray objectAtIndex:self.index - 1]];
                
                if (self.index == self.sourceArray.count - 1) {
                    
                    [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:0]];
                    
                }else{
                
                    [self setPicWithIndex:3 withImage:[self.sourceArray objectAtIndex:self.index + 1]];
                
                }
                
            }
            
            //页码翻页动画
            UILabel *index = (UILabel *)[self viewWithTag:99];
            CATransition *animation = [CATransition animation];
            animation.delegate = self;
            [animation setDuration:0.5f];
            [animation setType:@"oglFlip"];
            [animation setSubtype:kCATransitionFromLeft];
            [animation setFillMode:kCAFillModeRemoved];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [index.layer addAnimation:animation forKey:nil];
        
        }
        
    }

}

@end

