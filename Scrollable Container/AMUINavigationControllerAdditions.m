//
//  AMUINavigationControllerAdditions.m
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

#import "AMUINavigationControllerAdditions.h"
#import "AMNavigationMenu.h"

@implementation UINavigationController (AMScrollableContainer)

- (void)controllerWillBePopped
{
    if (self.viewControllers.count == 2)
    {
        AMNavigationMenu *v = (AMNavigationMenu *) [self.navigationBar viewWithTag:100];
        [v showMenu:YES];        
    }
}

@end
