//
//  AMTableViewController.m
//  Scrollable Container
//
//  Created by Maher Ali on 5/22/13.
//  Copyright (c) 2013 Agilis Mobility. All rights reserved.
//

#import "AMTableViewController.h"
#import "AMNavigationMenu.h"
#import "AMScrollableContainer.h"
#import "AMUINavigationControllerAdditions.h"

@interface AMTableViewController ()

@end

@implementation AMTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(AMScrollableContainer *)self.parentViewController pushViewController:[[AMTableViewController alloc] init] animated:YES];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{    
    [super willMoveToParentViewController:parent];
    if (!parent) {
        [(UINavigationController *)self.parentViewController controllerWillBePopped:self];
    }
}

@end
