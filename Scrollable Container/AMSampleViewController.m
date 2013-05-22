//
//  AMSampleViewController.m
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

#import "AMSampleViewController.h"

@interface AMSampleViewController ()

@end

@implementation AMSampleViewController

- (id)initWithTitle:(NSString*) ttl
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = ttl;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view = [self _simpleLabelWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) andText:self.title];
}

- (UILabel *)_simpleLabelWithFrame: (CGRect)frame andText: (NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:28.];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

@end
