//
//  AMSampleViewController.m
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

#import "AMScrollView.h"

@implementation AMScrollView
{
    UIPageControl       * _statusBarPageControl;
    NSTimer             *_timer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_statusBarPageControl) {
        _statusBarPageControl = [[UIPageControl alloc] initWithFrame:[[UIApplication sharedApplication] statusBarFrame]];
        _statusBarPageControl.numberOfPages = (self.contentSize.width / self.frame.size.width);
        _statusBarPageControl.backgroundColor = [UIColor clearColor];
    }
}

- (NSUInteger)pageForX:(CGFloat)x
{
    return (x + (self.frame.size.width / 2)) / (self.frame.size.width);
}

- (void)updatePaging:(CGPoint)contentOffset
{
    if (self.isTracking) {
        [self showPageControl:YES];
    }
    else if (!self.isDragging) {
        [self showPageControl:NO];
    }
    _statusBarPageControl.currentPage = [self pageForX:contentOffset.x];
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    [self updatePaging:contentOffset];
    [self.amScrollViewDelegate update:contentOffset];
}

- (void)updateContentOffset:(CGPoint) point
{
    if (CGPointEqualToPoint(point, CGPointMake(-999, -999))) {
        [self showPageControl:NO];
    }
    else
    {
        [super setContentOffset:point];
        [self showPageControl:YES];
        _statusBarPageControl.currentPage = [self pageForX:point.x];
    }
}

- (void)animateStatusBarState:(NSTimer *)timer
{
    BOOL show = [[timer.userInfo valueForKey:@"show"] boolValue];
    
    [UIView animateWithDuration:.4 animations:^{
        if (show) {
            [[[UIApplication sharedApplication] keyWindow] addSubview:_statusBarPageControl];
        }
    } completion:^(BOOL finished) {
        if (!show) {            
            [UIView animateWithDuration:1 animations:^{
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
            } completion:^(BOOL finished) {
                [_statusBarPageControl removeFromSuperview];
            }];
        }
    }];
}

- (void)showPageControl:(BOOL)show
{
    [_timer invalidate];
    
    if (show) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    _timer = [NSTimer timerWithTimeInterval:show ? 0 : 2 target:self selector:@selector(animateStatusBarState:) userInfo:@{ @"show" : [NSNumber numberWithBool:show] } repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

@end
