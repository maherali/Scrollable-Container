//
//  AMSampleViewController.m
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

#import "AMScrollView.h"

@interface AMScrollableContainer : UIViewController {
    AMScrollView    *_scrollView;
}

- (id)initWithChildViewControllers:(NSArray *)_ctrls;

@end
