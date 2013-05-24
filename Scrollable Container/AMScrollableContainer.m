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
}

- (void)update:(CGPoint) point
{
    [_menu updateContentOffset:point];
}

- (void)userInteractingWithMenu:(CGPoint)contentOffset
{
    [_scrollView updateContentOffset:contentOffset];
    
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
    _timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(animateScale:)
                                   userInfo:@ {@"current" : [NSNumber numberWithInt:currentChild], @"scale" : [NSNumber numberWithBool:NO] } repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)animateScale:(NSTimer *) t
{
    if (!_finished) {
        return;
    }
    
    NSUInteger  currentChild    = [[t.userInfo valueForKey:@"current"] intValue];
    BOOL        scale           = [[t.userInfo valueForKey:@"scale"] boolValue];
    UIView      *v              = [_children[currentChild] view];
    
    if (scale) {
        v.layer.cornerRadius = 5;
    }
    
    __weak AMScrollableContainer *weakSelf = self;
    
    _finished = NO;
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         v.transform = scale ? CGAffineTransformMakeScale(0.9, 0.9) : CGAffineTransformIdentity;
                     }
                     completion: ^(BOOL finished){
                         AMScrollableContainer *strongSelf = weakSelf;
                         strongSelf->_finished = YES;
                         if (!scale) {
                             v.layer.cornerRadius =  0;
                         }
                     }
     ];
}

@end














