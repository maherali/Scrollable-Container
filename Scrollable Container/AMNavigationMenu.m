//
//  AMSampleViewController.m
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

#import "AMNavigationMenu.h"

#define NAV_ITEM_WIDTH 135.0f

@protocol AMMenuScrollViewDelegate <NSObject>

- (void)update;

@end

@interface AMMenuScrollView : UIScrollView

@property (nonatomic, weak) id<AMMenuScrollViewDelegate> scrollViewDelegate;

@end

@implementation AMMenuScrollView

- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    [_scrollViewDelegate update];
}

- (void)updateContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
}

@end

@interface AMNavigationMenu() <UIScrollViewDelegate, AMMenuScrollViewDelegate>

@end

@implementation AMNavigationMenu
{
    AMMenuScrollView        *_scrollView;
    NSArray                 *_itemsViews;
    NSArray                 *_pageTitles;
}

- (id)initWithPageTitles:(NSArray *)pageTitles
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    if (self) {        
        NSAssert(pageTitles.count, @"Page titles should not be empty");
        
        _pageTitles = pageTitles;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carousel_bg.png"]];
        [self addSubview:imgView];

        _scrollView = [[AMMenuScrollView alloc] initWithFrame:CGRectMake(160-NAV_ITEM_WIDTH/2, 0, NAV_ITEM_WIDTH, 40)];
        _scrollView.contentSize = CGSizeMake([_pageTitles count] *NAV_ITEM_WIDTH, 40);
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.scrollViewDelegate = self;
        
        __block int currX = 0;
        NSMutableArray *arr = [NSMutableArray array];
        
        [_pageTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(currX, 0, NAV_ITEM_WIDTH, 40)];
            v.textAlignment = NSTextAlignmentCenter;
            v.font = [UIFont boldSystemFontOfSize:16];
            v.text = obj;
            v.textColor = [UIColor lightTextColor];
            v.backgroundColor = [UIColor clearColor];
            [_scrollView addSubview:v];
            [arr addObject:v];
            currX += NAV_ITEM_WIDTH;
        }];
        _itemsViews = [arr copy];
        
        [self addSubview:_scrollView];
        [self updateSelectedItemIndicator];
    }
    
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if ([self pointInside:point withEvent:event]) {
        if (!self.hidden) {
            return _scrollView;
        }
    }
	return nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateSelectedItemIndicator];
    [_navigationMenuDelegate userInteractingWithMenu:CGPointMake(-999, -999)];
}

- (void)updateSelectedItemIndicator
{
    [_itemsViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *lbl = [_itemsViews objectAtIndex:idx];
        lbl.textColor = [UIColor lightTextColor];
    }];
    
    int currentPage = (_scrollView.contentOffset.x + (NAV_ITEM_WIDTH / 2)) / (NAV_ITEM_WIDTH);
    if (currentPage >= _itemsViews.count) {
        currentPage = _itemsViews.count - 1;
    }
    UILabel *lbl = [_itemsViews objectAtIndex:currentPage];
    lbl.textColor = [UIColor whiteColor];
}

- (void)update
{
    [self updateSelectedItemIndicator];
    CGPoint p = CGPointMake(_scrollView.contentOffset.x * (320.0f/NAV_ITEM_WIDTH), _scrollView.contentOffset.y);
    [_navigationMenuDelegate userInteractingWithMenu:p];
}

- (void)updateContentOffset:(CGPoint) point
{
    CGPoint p = CGPointMake(point.x * NAV_ITEM_WIDTH/320, point.y);
    [_scrollView updateContentOffset:p];
    [self updateSelectedItemIndicator];
}

- (void)showMenu:(BOOL) show
{
    self.hidden = !show;
}

@end
