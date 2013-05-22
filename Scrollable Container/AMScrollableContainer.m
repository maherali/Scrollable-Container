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

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    
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

@end
