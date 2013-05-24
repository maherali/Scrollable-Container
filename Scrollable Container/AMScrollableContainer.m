//
//  AMSampleViewController.m
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

#import "AMScrollableContainer.h"
#import "AMNavigationMenu.h"
#import "AMSampleViewController.h"
#import "AMTableViewController.h"
#import "AMUINavigationController+AMScrollableContainer.h"
#import <QuartzCore/QuartzCore.h>

@interface AMScrollableContainer () <AMScrollViewDelegate, UIScrollViewDelegate, NavigationMenuDelegate>

@end

@implementation AMScrollableContainer
{
    AMNavigationMenu    *_menu;
    NSArray             *_children;
    NSTimer             *_timer;
    BOOL                _finished;
    UIPageControl       * _statusBarPageControl;
    NSTimer             *_pageControlTimer;
}

- (id)initWithChildViewControllers:(NSArray *)_ctrls
{
    self = [super init];
    
    if (self) {
        _children = _ctrls;
        _finished = YES;
    }
    
    return self;
}

- (AMNavigationMenu *)menu
{
    return _menu;
}

- (void)didReceiveMemoryWarning
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view.backgroundColor = [UIColor blackColor];
    _scrollView = [[AMScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * _children.count, self.view.frame.size.height);
    _scrollView.pagingEnabled   = YES;
    _scrollView.delegate        = self;
    _scrollView.amScrollViewDelegate      = self;
    
    [_children enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        [obj willMoveToParentViewController:self];
        [self addChildViewController:obj];
        obj.view.frame = CGRectMake(self.view.frame.size.width*idx, 0, self.view.frame.size.width, self.view.bounds.size.height-44);
        [_scrollView addSubview:obj.view];
        [obj didMoveToParentViewController:self];
    }];
    [self.view addSubview:_scrollView];
    
    _menu = [[AMNavigationMenu alloc] initWithPageTitles:[_children valueForKeyPath:@"title"]];
    _menu.navigationMenuDelegate = self;
    [self.navigationController.navigationBar addSubview:_menu];
    
    
    if (!_statusBarPageControl) {
        _statusBarPageControl = [[UIPageControl alloc] initWithFrame:[[UIApplication sharedApplication] statusBarFrame]];
        _statusBarPageControl.numberOfPages = (_scrollView.contentSize.width / _scrollView.frame.size.width);
        _statusBarPageControl.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)applicationWillResignActive:(NSNotification *)notification {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [_statusBarPageControl removeFromSuperview];
}

- (void)update:(CGPoint) point
{
    if (_scrollView.isTracking) {
        [self showPageControl:YES];
    }
    else if (!_scrollView.isDragging) {
        [self showPageControl:NO];
    }
    _statusBarPageControl.currentPage = [self pageForX:point.x];
    
    [_menu updateContentOffset:point];
}

- (void)userInteractingWithMenu:(CGPoint)contentOffset
{
    if (CGPointEqualToPoint(contentOffset, CGPointMake(-999, -999))) {
        [self showPageControl:NO];
    }
    else
    {
        [_scrollView updateContentOffset:contentOffset];
        [self showPageControl:YES];
        _statusBarPageControl.currentPage = [self pageForX:contentOffset.x];
    }
    
    NSUInteger currentChild = (_scrollView.contentOffset.x + (self.view.frame.size.width / 2)) / (self.view.frame.size.width);
    if (currentChild >= _children.count) {
        currentChild = _children.count - 1;
    }
    
    if (CGPointEqualToPoint(contentOffset, CGPointMake(-999, -999))) {
        [_timer invalidate];
        _timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(animateScale:) userInfo:@ { @"current" : [NSNumber numberWithInt:currentChild], @"scale" : [NSNumber numberWithBool:NO] } repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    else
    {
        [_timer invalidate];
        _timer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(animateScale:) userInfo:@ { @"current" : [NSNumber numberWithInt:currentChild], @"scale" : [NSNumber numberWithBool:YES] } repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - Scrollview delegate calls

-(void)makeAllViewsIdentityExceptAtIndex:(NSUInteger) index
{
    [_children enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            obj.view.transform = CGAffineTransformIdentity;
            obj.view.layer.cornerRadius = 0;
        }
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSUInteger currentChild = (_scrollView.contentOffset.x + (self.view.frame.size.width / 2)) / (self.view.frame.size.width);
    if (currentChild >= _children.count) {
        currentChild = _children.count - 1;
    }
    CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
    [_children enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if (idx != currentChild) {
            obj.view.transform = transform;
            obj.view.layer.cornerRadius = 5;
        }
    }];
    
    [_timer invalidate];
    _timer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(animateScale:)
                                   userInfo:@ { @"current" : [NSNumber numberWithInt:currentChild], @"scale" : [NSNumber numberWithBool:YES] } repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger currentChild = (_scrollView.contentOffset.x + (self.view.frame.size.width / 2)) / (self.view.frame.size.width);
    if (currentChild >= _children.count) {
        currentChild = _children.count - 1;
    }
    [_timer invalidate];
    _timer = [NSTimer timerWithTimeInterval:0.0 target:self selector:@selector(animateScale:)
                                   userInfo:@ {@"current" : [NSNumber numberWithInt:currentChild], @"scale" : [NSNumber numberWithBool:NO] } repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)animateScale:(NSTimer *) t
{
    NSUInteger  currentChild    = [[t.userInfo valueForKey:@"current"] intValue];
    BOOL        scale           = [[t.userInfo valueForKey:@"scale"] boolValue];
    UIView      *v              = [_children[currentChild] view];
    
    if (!_finished) {
        return;
    }
    
    if (scale) {
        [self showPageControl:YES];
    }
    else
    {
        [self showPageControl:NO];
    }
   
     _finished = NO;
    
    if (scale) {
        v.layer.cornerRadius = 5;
    }
          
    __weak AMScrollableContainer *weakSelf = self;
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         v.transform = scale ? CGAffineTransformMakeScale(0.9, 0.9) : CGAffineTransformIdentity;
                     }
                     completion: ^(BOOL finished){
                         AMScrollableContainer *strongSelf = weakSelf;
                         if(strongSelf)
                         {
                             strongSelf->_finished = YES;
                         }
                         if (!scale) {
                             v.layer.cornerRadius =  0;
                         }
                     }
     ];
}

- (void)showPageControl:(BOOL)show
{
    __weak AMScrollableContainer *weakSelf = self;
    
    if (show)
    {
        [UIView animateWithDuration:0.4 animations:^{
            AMScrollableContainer *strongSelf = weakSelf;
            if (strongSelf) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
                 [[[UIApplication sharedApplication] keyWindow] addSubview:strongSelf->_statusBarPageControl];
            }
        } completion:^(BOOL finished){
            AMScrollableContainer *strongSelf = weakSelf;
            if (strongSelf) {
               
            }
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            AMScrollableContainer *strongSelf = weakSelf;
            if(strongSelf)
            {
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
                [strongSelf->_statusBarPageControl removeFromSuperview];
            }
        } completion:^(BOOL finished){
            AMScrollableContainer *strongSelf = weakSelf;
            if(strongSelf)
            {
            }
        }];
    }
}

- (NSUInteger)pageForX:(CGFloat)x
{
    return (x + (_scrollView.frame.size.width / 2)) / (_scrollView.frame.size.width);
}

@end








