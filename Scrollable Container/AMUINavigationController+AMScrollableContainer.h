//
//  AMUINavigationControllerAdditions.h
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMNavigationMenu;

@interface UINavigationController (AMScrollableContainer)

- (void)controllerWillBePopped:(UIViewController *)ctrl;
- (AMNavigationMenu *)menu;
- (void)pushViewController:(UIViewController *)viewController;

@end
