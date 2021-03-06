//
//  AMUINavigationControllerAdditions.m
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

#import "AMUINavigationController+AMScrollableContainer.h"
#import "AMNavigationMenu.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationController (AMScrollableContainer)

- (void)controllerWillBePopped:(UIViewController *)ctrl
{
    if (self.viewControllers.count == 2)
    {
        [ctrl.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
        [ctrl.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
        [self.menu showMenu:YES];
    }
}

- (AMNavigationMenu *)menu
{
    UIView *v = self.navigationBar;
    for (UIView *subView in v.subviews) {
        if ([subView isKindOfClass:[AMNavigationMenu class]]) {
            return (AMNavigationMenu *)subView;
        }
    }
    return nil;
}

- (void)pushViewController:(UIViewController *)viewController
{
    [[self menu] showMenu:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self pushViewController:viewController animated:YES];
}

@end
