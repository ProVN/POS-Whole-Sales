//
//  UIViewController+POSViewController.m
//  pos
//
//  Created by Loc Tran on 2/7/14.
//  Copyright (c) 2014 com.ecomtree. All rights reserved.
//

#import "UIViewController+POSViewController.h"
#import "MasterViewController.h"

@implementation UIViewController (POSViewController)
@dynamic isLayout, popover;

/*!
 Apply layout for POS Application
 */
-(void)setLayout
{
    if(self.navigationController)
    {
        self.navigationController.navigationBar.barTintColor = [self mainColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor]};
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    if([self.title rangeOfString:@"Information"].location == NSNotFound)
        self.navigationController.toolbarHidden = NO;
    else
        self.navigationController.toolbarHidden = YES;
    [[MasterViewController masterView].popover dismissPopoverAnimated:YES];
}

- (UIColor*) mainColor {
    return [UIColor colorWithRed:0.4 green:0.6 blue:0.2 alpha:1];
}

#pragma mark
#pragma mark UISplitViewControllerDelegate
- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    [MasterViewController masterView].popover = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [MasterViewController masterView].popover = nil;
}
@end
