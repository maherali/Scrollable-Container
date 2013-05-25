//
//  AMSampleViewController.m
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

@protocol AMScrollViewDelegate <NSObject>

- (void) update:(CGPoint) point;

@end

@interface AMScrollView : UIScrollView {
}

@property (nonatomic, weak) id<AMScrollViewDelegate> amScrollViewDelegate;

- (void)updateContentOffset:(CGPoint) point;

@end
