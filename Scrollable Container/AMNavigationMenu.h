//
//  AMSampleViewController.m
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

@protocol NavigationMenuDelegate <NSObject>

- (void)userInteractingWithMenu:(CGPoint)contentOffset;

@end

@interface AMNavigationMenu : UIView

@property (nonatomic, assign) id<NavigationMenuDelegate> navigationMenuDelegate;

- (id)initWithPageTitles:(NSArray *)pageTitles;
- (void)updateContentOffset:(CGPoint) point;
- (void)showMenu:(BOOL) show;

@end
