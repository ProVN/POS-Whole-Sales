//
//  DetailViewController.m
//  pos
//
//  Created by Loc Tran on 2/6/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "DetailViewController.h"
#import "DBManager.h"
#import "LoginViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"mainbg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([DBManager sharedInstant].currentUser == nil)
    {
        LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:loginView animated:NO completion:nil];
    }
    [self setLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void) showForm:(int) tag{
    
}

- (IBAction)products:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushForm" object:[NSNumber numberWithInt:3]];
}

- (IBAction)sales:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"PushForm" object:[NSNumber numberWithInt:1]];
}

- (IBAction)purchases:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"PushForm" object:[NSNumber numberWithInt:4]];
}

- (IBAction)customers:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"PushForm" object:[NSNumber numberWithInt:2]];
}

- (IBAction)payments:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"PushForm" object:[NSNumber numberWithInt:6]];
}

- (IBAction)suppliers:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"PushForm" object:[NSNumber numberWithInt:5]];
}

- (IBAction)reports:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"PushForm" object:[NSNumber numberWithInt:7]];
}
@end
