//
//  AMAppDelegate.m
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

#import "AMAppDelegate.h"
#import "AMScrollableContainer.h"
#import "AMTableViewController.h"
#import "AMSampleViewController.h"

@implementation AMAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_green.png"] forBarMetrics:UIBarMetricsDefault];

    UIBarButtonItem *barButton = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [barButton setBackButtonTitlePositionAdjustment:UIOffsetMake(2.0f, -2.0f) forBarMetrics:UIBarMetricsDefault];
	[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"nav_bar_back"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"nav_bar_back_pressed"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

    
    AMTableViewController *tblCtrl = [[AMTableViewController alloc] init];
    tblCtrl.title = @"Table";
    NSArray *arr = @[
                     [[AMSampleViewController alloc] initWithTitle:@"Page 1"],
                     tblCtrl,
                     [[AMSampleViewController alloc] initWithTitle:@"Page 3"]
                     
                     ];
    self.viewController = [[AMScrollableContainer alloc] initWithChildViewControllers:arr];
    UINavigationController *ctrl = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = ctrl;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
