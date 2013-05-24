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

@interface AMScrollableContainer () <AMScrollViewDelegate, UIScrollViewDelegate, NavigationMenuDelegate>

@end

@implementation AMScrollableContainer
{
    AMNavigationMenu    *_menu;
    NSArray             *_children;
}

- (id)initWithChildViewControllers:(NSArray *)_ctrls
{
    self = [super init];
    
    if (self) {
        _children = _ctrls;
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
}

#pragma mark - Scrollview delegate calls

- (void) x:(UIViewController *)vc
{
    CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
    vc.view.transform = transform;
    
    [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         vc.view.transform = transform;
                     }
                     completion: ^(BOOL finished){
                     }];
}

- (void)scrollIt:(NSTimer *) t
{
    NSUInteger currentChild = (_scrollView.contentOffset.x + (self.view.frame.size.width / 2)) / (self.view.frame.size.width);
    [self x:_children[currentChild]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSUInteger currentChild = (_scrollView.contentOffset.x + (self.view.frame.size.width / 2)) / (self.view.frame.size.width);
    CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
    [_children enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if (idx != currentChild) {
            obj.view.transform = transform;
        }
    }];
    
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0] interval:0 target:self selector:@selector(scrollIt:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger currentChild = (_scrollView.contentOffset.x + (self.view.frame.size.width / 2)) / (self.view.frame.size.width);
    NSLog(@"Settlled child is: %@", [_children[currentChild] title]);
    
    [_children enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        vc.view.transform = CGAffineTransformIdentity;
    }];
    
}

@end














