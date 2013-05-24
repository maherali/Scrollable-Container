//
//  AMSampleViewController.m
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

#import "AMScrollView.h"

@implementation AMScrollView

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    [self.amScrollViewDelegate update:contentOffset];
}

- (void)updateContentOffset:(CGPoint) point
{
    [super setContentOffset:point];    
}

@end
